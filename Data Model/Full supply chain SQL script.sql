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





-- Genereric Functional Tables to explain the high level concepts for the supply chain
-- n

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

CREATE TABLE ProductLocation (
    ProductLocationID INT PRIMARY KEY, -- Unique identifier for each record
    Material_ID VARCHAR(18) ,-- MARA: MATNR, References the material or SKU
    Location_ID INT, -- T001L: LGORT, References the location ID where the material is stocked
    BusinessPartnerID INT,                           -- General field, can reference KNA1: KUNNR for customers or LFA1: LIFNR for vendors
    ProductionSourcingHeaderID INT,                  -- Reference to a header table for production sourcing details
    ProductionSourcingBOMID INT,                     -- Reference to a Bill of Materials, which is part of production sourcing
    TransportationSourcingID INT,                    -- Reference to a transportation sourcing record
    PhaseInDate DATE,                                -- Indicates when the SKU is activated or phased into a location
    PhaseOutDate DATE,                               -- Indicates when the SKU is phased out or no longer stocked at a location
    SalesOrderID INT,                                -- VBAK: VBELN, Reference to sales orders associated with this SKU and location
    StockHistoryID INT,                              -- Reference to a table with historical stock levels for the SKU at the location
    SupplyOrderID INT,                               -- Reference to supply orders associated with the SKU at this location
    ForecastID INT,                                  -- Reference to a forecast record for future demand of the SKU at the location
    UnitOfMeasure VARCHAR(3),                         -- MARA: MEINS, Base unit of measure for the SKU
    FOREIGN KEY (Material_ID) REFERENCES Material(Material_ID),
    FOREIGN KEY (Location_ID) REFERENCES Location(Location_ID),
    FOREIGN KEY (BusinessPartnerID) REFERENCES BusinessPartner(BusinessPartnerID)
);



CREATE TABLE Location (
    Location_ID INT PRIMARY KEY,               -- Uniquely identifies a location entry
    Name VARCHAR(255),                        -- The common name of the location
    Country VARCHAR(3),                       -- T005: LAND1, Country code of the location
    Type VARCHAR(50),                         -- Can be used to distinguish between types like 'Warehouse', 'Store', etc.
    Supplier_ID INT,                             -- LFA1: LIFNR, Links to Vendor Master if this location is associated with a vendor
    Customer_ID INT,                           -- KNA1: KUNNR, Links to Customer Master if this location is associated with a customer
    Region VARCHAR(3),                        -- T005: REGIO, Region or state code within the country
    GeoLongitude DECIMAL(9,6),                -- Longitude coordinate for the location
    GeoLatitude DECIMAL(9,6)                  -- Latitude coordinate for the location
);


CREATE TABLE BusinessPartner (
    BusinessPartnerID INT PRIMARY KEY, -- Unique identifier for the business partner
    Supplier_ID INT,                   -- LFA1: LIFNR, Foreign key referencing the supplier table
    Customer_ID INT,                    -- KNA1: KUNNR, Foreign key referencing the customer table
    FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);



CREATE TABLE ProductionPlanning (
    Material_ID VARCHAR(18),               -- MARA: MATNR, Material Number
    Location_ID VARCHAR(10),               -- T001L: LGORT, Storage Location
    MinimumLotSize DECIMAL(14, 4),        -- MARC: BSTRF, Base quantity for minimum lot size
    MaximumLotSize DECIMAL(14, 4),        -- MARC: BSTMA, Maximum stock level
    RoundingValue DECIMAL(14, 4),         -- MARC: AUSSS, Rounding value for order quantity
    FixedLotSize DECIMAL(14, 4),          -- MARC: BSTFE, Fixed lot size for production
    LotSizeProcedure VARCHAR(4),          -- MARC: DISPO, Lot size procedure
    MinimumDaysOfCoverage INT,            -- MARC: MINLGR, Minimum range of coverage
    InHouseProductionTime INT,            -- MARC: PLIFZ, Planned delivery time in days
    GRProcessingTime INT,                 -- MARC: WEBAZ, Goods receipt processing time in days
    PlannedDeliveryTime INT,              -- MARC: PLIFZ, In-house production time
    UnitOfMeasure VARCHAR(3),             -- MARA: MEINS, Base Unit of Measure
    ProducedQuantity DECIMAL(14, 4),      -- MSEG: MENGE, Quantity in a goods movement
    Planner VARCHAR(3),                    -- MARC: DISPO, MRP controller (Materials Planner)
    FOREIGN KEY (Material_ID) REFERENCES Material(Material_ID),
    FOREIGN KEY (Location_ID) REFERENCES Location(Location_ID)
);


----- Production Relevant


-- BillOfMaterials Table
CREATE TABLE BillOfMaterials (
    BOMID INT PRIMARY KEY,                 -- STKO: STLNR, BOM Header Number
    Material_ID VARCHAR(18),                -- STPO: IDNRK, Component Material Number
    QuantityRequired DECIMAL(14,4),        -- STPO: MENGE, Quantity of Component Required
    ValidFrom DATE,                        -- STKO: DATUV, Valid-From Date
    ValidTo DATE,                          -- STKO: DATUB, Valid-To Date
    BOMUsage VARCHAR(1),                   -- STKO: STLAN, BOM Usage
    AlternativeBOM VARCHAR(2),             -- STKO: STLAL, Alternative BOM
    FOREIGN KEY (Material_ID) REFERENCES Material(Material_ID)
    -- Other fields...
);


-- WorkCenters Table
CREATE TABLE WorkCenters (
    WorkCenterID VARCHAR(8) PRIMARY KEY,   -- CRHD: OBJID, Work Center ID
    WorkCenterName VARCHAR(255),           -- CRHD: ARBPL, Work Center Name
    Plant VARCHAR(4),                      -- CRHD: WERKS, Plant
    WorkCenterCategory CHAR(1),            -- CRHD: VERWE, Work Center Category
    CostCenter VARCHAR(10),                -- CRHD: KOSTL, Cost Center
    StandardValueKey VARCHAR(3),           -- CRHD: VERWE, Standard Value Key
    CapacityCategory CHAR(1)               -- CRCA: FHMKT, Capacity Category
    -- Other fields...
);

-- Routings Table
CREATE TABLE Routings (
    RoutingID INT PRIMARY KEY,                 -- PLKO: PLNNR, Routing Number
    Material_ID VARCHAR(18),                    -- The finished product this Routing applies to
    OperationCounter INT,                      -- PLPO: VORNR, Operation/Activity Counter
    Operation VARCHAR(255),                    -- PLPO: LTXA1, Operation Short Text
    WorkCenterID VARCHAR(8),                   -- PLPO: ARBID, Work Center ID
    StandardTextKey VARCHAR(7),                -- PLPO: TXTSP, Standard Text Key
    ControlKey VARCHAR(4),                     -- PLPO: STEUS, Control Key
    ActivityType VARCHAR(6),                   -- PLPO: LARNT, Activity Type
    SetupTime DECIMAL(14,4),                   -- PLPO: RUEST, Setup Time
    MachineTime DECIMAL(14,4),                 -- PLPO: MASCH, Machine Time
    LaborTime DECIMAL(14,4),                   -- PLPO: ARBEI, Labor Time
    ProcessingTime DECIMAL(14,4),              -- PLPO: VGW01, Processing Time
    Scrap DECIMAL(14,4),                       -- PLPO: AUERU, Scrap Quantity
    MoveTime DECIMAL(14,4),                    -- PLPO: WEGZE, Move Time
    WaitTime DECIMAL(14,4),                    -- PLPO: LIEZE, Wait Time
    OperationDescription VARCHAR(255),         -- PLPO: LTXA1, Operation Long Text
    FOREIGN KEY (Material_ID) REFERENCES Material(Material_ID),
    FOREIGN KEY (WorkCenterID) REFERENCES WorkCenters(WorkCenterID)
    -- Other fields...
);
    

-- ProductionOrders Table
CREATE TABLE ProductionOrders (
    ProductionOrderID INT PRIMARY KEY,     -- AUFK: AUFNR, Order Number
    Material_ID VARCHAR(18),                -- AFPO: MATNR, Material Number
    RoutingID INT,                         -- Link to the Routings table defining the sequence of operations
    Quantity DECIMAL(14,4),                -- AFKO: GAMNG, Order Quantity
    StartDate DATE,                        -- AFKO: GSTRP, Basic Start Date
    FinishDate DATE,                       -- AFKO: GLTRP, Basic Finish Date
    OrderStatus VARCHAR(2),                -- JEST: STAT, System Status
    OrderType VARCHAR(4),                  -- AUFK: AUART, Order Type
    FOREIGN KEY (Material_ID) REFERENCES Material(Material_ID),
    FOREIGN KEY (RoutingID) REFERENCES Routings(RoutingID)
    -- Other fields...
);

-- GoodsMovements
CREATE TABLE GoodsMovements (
    Movement_ID INT PRIMARY KEY,            -- MSEG: MBLNR, Document Number
    ProductionOrderID INT,                 -- MSEG: AUFNR, Order Number
    Material_ID VARCHAR(18),                -- MSEG: MATNR, Material Number
    Quantity DECIMAL(14,4),                -- MSEG: MENGE, Quantity
    MovementType VARCHAR(3),               -- MSEG: BWART, Movement Type (e.g., goods receipt, goods issue)
    -- Other fields...
    FOREIGN KEY (ProductionOrderID) REFERENCES ProductionOrders(ProductionOrderID),
    FOREIGN KEY (Material_ID) REFERENCES Material(Material_ID)
);

---------- Deliver

-- DeliveryHeaders Table
CREATE TABLE DeliveryHeaders (
    DeliveryID INT PRIMARY KEY,                 -- LIKP: VBELN, Delivery Document Number
    DeliveryDate DATE,                          -- LIKP: WADAT_IST, Actual Goods Movement Date
    ShippingPoint VARCHAR(4),                   -- LIKP: VSTEL, Shipping Point
    DeliveryType VARCHAR(4),                    -- LIKP: LFART, Delivery Type
    OrderCombinationIndicator CHAR(1),          -- LIKP: KZAZU, Indicator for Order Combination
    TotalWeight DECIMAL(14,3),                  -- LIKP: BRGEW, Total Weight of Delivery
    WeightUnit VARCHAR(3)                      -- LIKP: GEWEI, Weight Unit
    -- Other fields...
);

-- DeliveryItems Table
CREATE TABLE DeliveryItems (
    ItemID INT PRIMARY KEY,                     -- LIPS: POSNR, Delivery Item Number
    DeliveryID INT,                             -- LIPS: VBELN, Delivery Document Number
    HandlingUnit_ID INT,                      -- VEKP: EXIDV, External Handling Unit Number
    Material_ID VARCHAR(18),                     -- LIPS: MATNR, Material Number
    OrderQuantity DECIMAL(14,4),                -- LIPS: LFIMG, Delivered Quantity
    BatchNumber VARCHAR(10),                    -- LIPS: CHARG, Batch Number
    Plant VARCHAR(4),                           -- LIPS: WERKS, Plant
    StorageLocation VARCHAR(4),                 -- LIPS: LGORT, Storage Location
    FOREIGN KEY (DeliveryID) REFERENCES DeliveryHeaders(DeliveryID),
    FOREIGN KEY (HandlingUnit_ID) REFERENCES HandlingUnitHeaders(HandlingUnit_ID),
    FOREIGN KEY (Material_ID) REFERENCES Material(Material_ID)
    -- Other fields...
);




-- DocumentFlow Table
CREATE TABLE DocumentFlow (
    FlowID INT PRIMARY KEY,                     -- VBFA: VBELV, Preceding Sales and Distribution Document Number
    OrderNumber INT,                           -- VBFA: VBELN, Sales Document Number
    DeliveryID INT,                             -- VBFA: VBTYP_N, Subsequent Document Category
    -- Other fields...
    FOREIGN KEY (OrderNumber) REFERENCES SalesOrderHeader(OrderNumber),
    FOREIGN KEY (DeliveryID) REFERENCES DeliveryHeaders(DeliveryID)
);

-- HandlingUnitHeaders Table
CREATE TABLE HandlingUnitHeaders (
    HandlingUnit_ID INT PRIMARY KEY,                      -- VEKP: EXIDV, External Handling Unit Number
    HU_Status VARCHAR(2),                       -- VEKP: HUSTA, Handling Unit Status
    TotalWeight DECIMAL(14,3),                  -- VEKP: GEWEI, Total Weight of Handling Unit
    WeightUnit VARCHAR(3),                      -- VEKP: BRGEW, Weight Unit
    PackingMaterial VARCHAR(18)                -- VEKP: VEMAT, Packing Material
    -- Other fields...
);

-- PackingItems Table
CREATE TABLE PackingItems (
    PackingItemID INT PRIMARY KEY,              -- VEPO: VENUM, Handling Unit Item Number
    HandlingUnit_ID INT,                                  -- VEPO: EXIDV, External Handling Unit Number
    Material_ID VARCHAR(18),                     -- VEPO: MATNR, Material Number
    Quantity DECIMAL(14,4),                     -- VEPO: LFIMG, Delivered Quantity
    -- Other fields...
    FOREIGN KEY (HandlingUnit_ID) REFERENCES HandlingUnitHeaders(HandlingUnit_ID),
    FOREIGN KEY (Material_ID) REFERENCES Material(Material_ID)
);

--------------------------



CREATE TABLE Customer (
    Customer_ID INT PRIMARY KEY,                   -- KNA1: KUNNR, Unique identifier for a customer
    CustomerName VARCHAR(255),                    -- KNA1: NAME1, Official name of the customer
    Address VARCHAR(255),                         -- ADRC: STREET, Address of the customer
    City VARCHAR(100),                            -- ADRC: CITY1, City of the customer's address
    PostalCode VARCHAR(10),                       -- ADRC: POST_CODE1, Postal code of the customer's address
    Country CHAR(2),                              -- ADRC: LAND1, Country code of the customer's address
    Region CHAR(3),                               -- ADRC: REGION, Region code (state, province) of the customer's address
    PaymentTerms VARCHAR(4),                      -- KNB1: ZTERM, Payment terms linked to the customer
    Currency CHAR(3)                              -- KNB1: WAERS, Currency code for the customer's transactions
    -- Other fields...
);

CREATE TABLE SalesOrderHeader (
    OrderNumber INT PRIMARY KEY,             -- VBAK: VBELN (Sales Document Number)
    OrderDate DATE,                          -- VBAK: ERDAT (Date on which the record was created)
    Customer_ID INT,                         -- VBAK: KUNNR (Customer's Account Number)
    SalesOrg VARCHAR(255),                   -- VBAK: VKORG (Sales Organization)
    DistributionChannel VARCHAR(255),        -- VBAK: VTWEG (Distribution Channel)
    Division VARCHAR(255),                   -- VBAK: SPART (Division)
    BillingAddress VARCHAR(255),             -- ADRC table for address, linked via ADRC-ADDRNUMBER
    ShippingAddress VARCHAR(255),            -- ADRC table for address, linked via ADRC-ADDRNUMBER
    PaymentTerms VARCHAR(255),               -- VBAK: ZTERM (Terms of Payment Key)
    TotalNetAmount DECIMAL(15,2),            -- VBAK: NETWR (Net Value of the Sales Order in Document Currency)
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
    -- Other fields...
);

CREATE TABLE SalesOrderLineItems (
    LineItemID INT PRIMARY KEY,              -- VBAP: POSNR (Sales Document Item)
    OrderNumber INT,                         -- VBAP: VBELN (Sales Document Number)
    Material_ID VARCHAR(18),                  -- VBAP: MATNR (Material Number)
    Description VARCHAR(255),                -- VBAP: ARKTX (Short Text for Sales Order Item)
    OrderQuantity DECIMAL(15,2),             -- VBAP: KWMENG (Ordered Quantity)
    UnitPrice DECIMAL(15,2),                 -- KONP: KBETR (Condition amount or percentage for the condition)
    TotalLineAmount DECIMAL(15,2),           -- Calculated as OrderQuantity * UnitPrice
    DeliveryDate DATE,                       -- VBEP: EINDT (Schedule line delivery date)
    AccountAssignment VARCHAR(255),          -- VBAP: KNTTP (Account assignment category for the item)
    FOREIGN KEY (OrderNumber) REFERENCES SalesOrderHeader(OrderNumber),
    FOREIGN KEY (Material_ID) REFERENCES Material(Material_ID)
    -- Other fields...
);

CREATE TABLE PurchaseOrderHeader (
    PO_Number INT PRIMARY KEY,  -- EKKO: EBELN (Purchase Document Number)
    PO_Date DATE,              -- EKKO: BEDAT (Document Date in Document)
    Supplier_ID INT,           -- EKKO: LIFNR (Vendor's Account Number)
    Buyer_Info VARCHAR(255),   -- EKKO: EKGRP (Purchasing Group)
    Delivery_Address VARCHAR(255), -- ADRC table for address, linked via ADRC-ADDRNUMBER
    Billing_Address VARCHAR(255),  -- ADRC table for address, linked via ADRC-ADDRNUMBER
    Payment_Terms VARCHAR(255),    -- EKKO: ZTERM (Terms of Payment Key)
    Shipping_Terms VARCHAR(255),   -- EKKO: INCO1-INCO2 (Incoterms)
    Total_Amount DECIMAL,           -- Can be calculated from EKPO table line items
    FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID)
    -- Other fields...
);

CREATE TABLE PurchaseOrderLineItems (
    Line_Item_ID INT PRIMARY KEY,  -- EKPO: EBELP (Item Number of Purchasing Document)
    PO_Number INT,                 -- EKPO: EBELN (Purchase Document Number)
    Material_ID VARCHAR(18),  -- MARA: MATNR, Unique identifier for materials
    Quantity INT,                  -- EKPO: MENGE (Quantity)
    Unit_Price DECIMAL,            -- EKPO: NETPR (Net Price)
    Total_Price DECIMAL,           -- Calculated as EKPO: MENGE * EKPO: NETPR
    Delivery_Date DATE,            -- EKET table for schedule lines, EKET-EINDT (Delivery Date)
    Account_Assignment VARCHAR(255), -- EKKN (Account Assignment in Purchasing Document)
    FOREIGN KEY (PO_Number) REFERENCES PurchaseOrderHeader(PO_Number),
    FOREIGN KEY (Material_ID) REFERENCES Material(Material_ID)
    -- Other fields...
);