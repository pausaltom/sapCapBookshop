const cds = require('@sap/cds')

/** Service implementation for AdminService */
module.exports = cds.service.impl(srv => {
    const { OrderItems } = srv.entities('bookshop.db')

    srv.after(['READ', 'EDIT'], 'Orders', _calculateTotals)
    srv.before('CREATE', 'Orders', _checkOrderCreateAuth)

    /** Check authorization  */
    function _checkOrderCreateAuth(req) {
        req.user.currency[0] === req.data.currency_code || req.reject(403)
    }
    // on-the-fly calculate the total Order price based on the OrderItems' netAmounts
    async function _calculateTotals(orders, req) {
        const ordersByID = Array.isArray(orders)
            ? orders.reduce((all, o) => { (all[o.ID] = o).total = 0; return all }, {})
            : { [orders.ID]: orders }
        return cds.transaction(req).run(
            SELECT.from(OrderItems).columns('parent_ID', 'netAmount')
                .where({ parent_ID: { in: Object.keys(ordersByID) } })
        ).then(items =>
            items.forEach(item => ordersByID[item.parent_ID].total += item.netAmount)
        )
    }

})
