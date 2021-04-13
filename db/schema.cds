namespace bookshop.db;

using {
    Currency,
    managed,
    cuid
} from '@sap/cds/common';


entity Books : additionalInfo, managed {
    key ID       : Integer;
        title    : localized String(111);
        descr    : localized String(1111);
        author   : Association to Authors;
        movie    : Association to Movies;
        stock    : Integer;
        price    : Decimal(9, 2);
        currency : Currency;
}


entity Authors : managed {
    key ID           : Integer;
        name         : String(111);
        dateOfBirth  : Date;
        dateOfDeath  : Date;
        placeOfBirth : String;
        placeOfDeath : String;
        books        : Association to many Books on books.author = $self;
}

entity Orders : managed, cuid {
    OrderNo  : String       @title : 'Order Number'; //> readable key
    Items    : Composition of many OrderItems
                   on Items.parent = $self;
    total    : Decimal(9, 2)@readonly;
    currency : Currency;
}

entity OrderItems : cuid {
    parent    : Association to Orders;
    book      : Association to Books;
    amount    : Integer;
    netAmount : Decimal(9, 2);
}

entity Movies : managed, additionalInfo {
    key ID    : Integer;
        name  : String(111);
        
}

aspect additionalInfo {
    gendre   : String(100);
    language : String(100);
}
