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