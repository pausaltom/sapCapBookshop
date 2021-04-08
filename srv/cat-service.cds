using { bookshop.db as my } from '../db/schema';


//tambien se pueden referenciar de esta manera los servicios, sino los detecta automáticamente pq no tiene el mismo nombre que el .cds 
// @path:'/browse'
// @impl:'./t-service.js'
@path:'/browse'
service CatalogService {
   @readonly entity Books as SELECT from my.Books {*,
    author.name as author
  } excluding { createdBy, modifiedBy };

  @requires_: 'authenticated-user'
  @insertonly entity Orders as projection on my.Orders;
}