
CREATE TABLE SalesOrderHeader (
    OrderNumber INT PRIMARY KEY,             -- VBAK: VBELN (Sales Document Number)
    OrderDate DATE,                          -- VBAK: ERDAT (Date on which the record was created)
    Customer_ID INT,                         -- VBAK: KUNNR (Customer's Account Number)
    SalesOrg VARCHAR(255),                   -- VBAK: VKORG (Sales Organization)
    DistributionChannel VARCHAR(255),        -- VBAK: VTWEG (Distribution Channel)
    Division VARCHAR(255),                   -- VBAK: SPART (Division)
    OrderStatus CHAR(1),                        -- VBAK: GBSTK, Overall Status of the Sales Order
    BillingAddress VARCHAR(255),             -- ADRC table for address, linked via ADRC-ADDRNUMBER
    ShippingAddress VARCHAR(255),            -- ADRC table for address, linked via ADRC-ADDRNUMBER
    PaymentTerms VARCHAR(255),               -- VBAK: ZTERM (Terms of Payment Key)
    TotalNetAmount DECIMAL(15,2)            -- VBAK: NETWR (Net Value of the Sales Order in Document Currency)
  --  FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
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
    FOREIGN KEY (OrderNumber) REFERENCES SalesOrderHeader(OrderNumber)
  --  FOREIGN KEY (Material_ID) REFERENCES Material(Material_ID)
    -- Other fields...
);





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
    FOREIGN KEY (HandlingUnit_ID) REFERENCES HandlingUnitHeaders(HandlingUnit_ID)
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
    FOREIGN KEY (HandlingUnit_ID) REFERENCES HandlingUnitHeaders(HandlingUnit_ID)
);