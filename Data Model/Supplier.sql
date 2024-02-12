CREATE TABLE Material (
    Material_ID VARCHAR(18) PRIMARY KEY,  -- MARA: MATNR, Unique identifier for materials
    BaseUnitOfMeasure VARCHAR(3),        -- MARA: MEINS, Base unit in which the material is stocked
    ProductDescription VARCHAR(255),     -- MAKT: MAKTX, Description of the material
    MaterialType VARCHAR(4),             -- MARA: MTART, Category that groups materials with the same attributes
    MaterialTypeDescription VARCHAR(255),-- T134T: MTBEZ, Description of the material type
    MaterialGroup VARCHAR(9),            -- MARA: MATKL, Grouping of materials with similar characteristics
    MaterialGroupDescription VARCHAR(255) -- T023T: WGBEZ, Description of the material group
    -- Other fields...
);

-- Suppliers
CREATE TABLE Supplier ( --- technically this mostly called vendor
    Supplier_ID INT PRIMARY KEY,                   -- LFA1: LIFNR, Unique identifier for a supplier
    SupplierName VARCHAR(255),                    -- ADRC: NAME1, Official name of the supplier
    Address VARCHAR(255),                         -- ADRC: STREET, Address of the supplier
    City VARCHAR(100),                            -- ADRC: CITY1, City of the supplier's address
    PostalCode VARCHAR(10),                       -- ADRC: POST_CODE1, Postal code of the supplier's address
    Country CHAR(2),                              -- ADRC: COUNTRY, Country code of the supplier's address
    Region CHAR(3),                               -- ADRC: REGION, Region code (state, province) of the supplier's address
    PaymentTerms VARCHAR(4),                      -- LFB1: ZTERM, Payment terms linked to the supplier
    Currency CHAR(3)                             -- LFB1: WAERS, Currency code for the supplier's transactions
    -- Other fields...
);

-- SupplierFinancialData
CREATE TABLE SupplierFinancialData (
    Supplier_ID VARCHAR(10),             -- SAP LFB1: LIFNR, Supplier's account number, foreign key to Suppliers
    CompanyCode CHAR(4) PRIMARY KEY,                -- SAP LFB1: BUKRS, Company code
    PaymentTerms VARCHAR(4),            -- SAP LFB1: ZTERM, Terms of payment key
    GeneralLedgerAccount VARCHAR(10),   -- SAP LFB1: AKONT, Reconciliation account in the general ledger
    CurrencyCode CHAR(3),               -- SAP LFB1: WAERS, Currency code for transactions
    FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID)
);

-- SupplierPurchasingData
CREATE TABLE SupplierPurchasingData (
    Supplier_ID VARCHAR(10),             -- SAP LFM1: LIFNR, Supplier's account number, foreign key to Suppliers
    PurchasingOrganization CHAR(4),     -- SAP LFM1: EKORG, Purchasing organization
    PurchasingGroup CHAR(3),            -- SAP LFM1: EKGRP, Purchasing group
    TransactionCurrency CHAR(5),        -- SAP LFM1: WAERS, Currency key
    MinimumOrderValue DECIMAL(10,2),    -- SAP LFM1: MINBW, Minimum purchase order value
    FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID)
);



-- FinancialDocumentHeader
CREATE TABLE FinancialDocumentHeader (
    DocumentNumber VARCHAR(10) PRIMARY KEY, -- SAP BKPF: BELNR, Accounting document number
    Supplier_ID VARCHAR(10),             -- SAP LFBK: LIFNR, Supplier's account number, foreign key to Suppliers
    CompanyCode CHAR(4),                    -- SAP BKPF: BUKRS, Company code
    FiscalYear SMALLINT,                    -- SAP BKPF: GJAHR, Fiscal year
    DocumentType CHAR(2),                   -- SAP BKPF: BLART, Document type
    DocumentDate DATE,                       -- SAP BKPF:
    FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID)
)

-- PurchasingDocumentHistory
CREATE TABLE PurchasingDocumentHistory (
    HistoryID INT PRIMARY KEY,               -- EKBE: BELNR, Document Number (History)
    PurchaseOrderID INT,                     -- EKBE: EBELN, Purchasing Document Number
    ItemID INT,                              -- EKBE: EBELP, Line Item in Purchasing Document
    MovementType VARCHAR(2),                 -- EKBE: BWART, Movement Type (e.g., goods receipt, invoice receipt)
    Quantity DECIMAL(14,4),                  -- EKBE: MENGE, Quantity
    PostingDate DATE,                        -- EKBE: BUDAT, Posting Date in the Document
    Supplier_ID VARCHAR(10),                  -- Link to Suppliers table
    FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID)
    -- Other fields...
);

-- PurchasingDocumentHeader
CREATE TABLE PurchasingDocumentHeader (
    PurchaseOrderID INT PRIMARY KEY,         -- EKKO: EBELN, Purchasing Document Number
    DocumentDate DATE,                       -- EKKO: AEDAT, Document Date
    Supplier_ID VARCHAR(10),                  -- EKKO: LIFNR, Supplier's Account Number
    PaymentTerms VARCHAR(4),                 -- EKKO: ZTERM, Terms of Payment Key
    TotalNetAmount DECIMAL(15,2),            -- EKKO: NETWR, Net Order Value
    CurrencyCode CHAR(3),                    -- EKKO: WAERS, Currency Key
    PurchasingOrganization CHAR(4),          -- EKKO: EKORG, Purchasing Organization
    FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID)
    -- Other fields...
);


-- MaterialDocument Table
CREATE TABLE MaterialDocument (
    DocumentNumber INT PRIMARY KEY,          -- MKPF: MBLNR, Material Document Number
    PostingDate DATE,                        -- MKPF: BUDAT, Posting Date
    MovementType VARCHAR(2),                 -- MSEG: BWART, Movement Type
    Material_ID VARCHAR(18),                 -- MSEG: MATNR, Material Number
    Quantity DECIMAL(14,4),                  -- MSEG: MENGE, Quantity
    Plant VARCHAR(4),                        -- MSEG: WERKS, Plant
    StorageLocation VARCHAR(4),              -- MSEG: LGORT, Storage Location
    PurchaseOrderID INT,                     -- Link to PurchasingDocumentHeader
    FOREIGN KEY (Material_ID) REFERENCES Material(Material_ID),
    FOREIGN KEY (PurchaseOrderID) REFERENCES PurchasingDocumentHeader(PurchaseOrderID)
    -- Other fields...
);
