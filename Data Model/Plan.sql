-- MaterialMaster Table
CREATE TABLE MaterialMaster (
    MaterialID VARCHAR(18) PRIMARY KEY,   -- MARA: MATNR, Material Number
    MaterialDescription VARCHAR(255),     -- MAKT: MAKTX, Material Description
    MaterialType VARCHAR(4),              -- MARA: MTART, Material Type
    BaseUnitOfMeasure VARCHAR(3),         -- MARA: MEINS, Base Unit of Measure
    MaterialGroup VARCHAR(9),             -- MARA: MATKL, Material Group
    OldMaterialNumber VARCHAR(18),        -- MARA: BISMT, Old Material Number
    Division VARCHAR(2)                  -- MARA: SPART, Division
    -- Other fields...
);

-- PlantDataForMaterial Table
CREATE TABLE PlantDataForMaterial (
    MaterialID VARCHAR(18),               -- MARC: MATNR, Material Number
    Plant VARCHAR(4),                      -- MARC: WERKS, Plant
    StorageLocation VARCHAR(4),            -- MARC: LGORT, Storage Location
    MRPController VARCHAR(3),             -- MARC: DISPO, MRP Controller
    LotSize VARCHAR(4),                   -- MARC: LOSFX, Lot Size
    ProcurementType CHAR(1),              -- MARC: BESKZ, Procurement Type
    SafetyStock DECIMAL(14,4),            -- MARC: EISBE, Safety Stock
    PRIMARY KEY (MaterialID, Plant),
    FOREIGN KEY (MaterialID) REFERENCES MaterialMaster(MaterialID)
    -- Other fields...
);

-- MRPDocumentHeader Table
CREATE TABLE MRPDocumentHeader (
    PlanningRunID INT PRIMARY KEY,        -- MDKP: MRPNR, Planning Run Number
    MaterialID VARCHAR(18),               -- MDKP: MATNR, Material Number
    Plant VARCHAR(4),                     -- MDKP: WERKS, Plant
    MRPListDate DATE,                     -- MDKP: DATAB, MRP List Date
    MRPListTime TIME,                     -- MDKP: UZEIT, MRP List Time
    MRPType CHAR(3),                      -- MDKP: DISMM, MRP Type
    MRPController VARCHAR(3),             -- MDKP: DISPO, MRP Controller
    FOREIGN KEY (MaterialID) REFERENCES MaterialMaster(MaterialID)
    -- Other fields...
);

-- MRPTable Table
CREATE TABLE MRPTable (
    MaterialID VARCHAR(18),               -- MDTB: MATNR, Material Number
    Plant VARCHAR(4),                     -- MDTB: WERKS, Plant
    RequirementDate DATE,                 -- MDTB: BDTER, Requirement Date
    MRPElement CHAR(10),                  -- MDTB: DSNAM, MRP Element
    Quantity DECIMAL(14,4),               -- MDTB: BDMNG, Requirement Quantity
    MRPController VARCHAR(3),             -- MDTB: DISPO, MRP Controller
    PRIMARY KEY (MaterialID, Plant, RequirementDate),
    FOREIGN KEY (MaterialID) REFERENCES MaterialMaster(MaterialID)
    -- Other fields...
);

-- MasterProductionSchedule Table
CREATE TABLE MasterProductionSchedule (
    MPSID INT PRIMARY KEY,                -- Planned manually or derived from planning tables
    MaterialID VARCHAR(18),               -- Link to MaterialMaster
    Plant VARCHAR(4),                     -- Link to PlantDataForMaterial
    PlannedQuantity DECIMAL(14,4),        -- Planned quantity to be produced
    ScheduleStartDate DATE,               -- Start date of production
    ScheduleFinishDate DATE,              -- Finish date of production
    FOREIGN KEY (MaterialID) REFERENCES MaterialMaster(MaterialID)
    -- Other fields...
);

-- Reservations Table
CREATE TABLE Reservations (
    ReservationID INT PRIMARY KEY,        -- RESB: RSNUM, Reservation Number
    MaterialID VARCHAR(18),               -- RESB: MATNR, Material Number
    Plant VARCHAR(4),                     -- RESB: WERKS, Plant
    ReservationQuantity DECIMAL(14,4),    -- RESB: BDMNG, Reserved Quantity
    WithdrawalDate DATE,                  -- RESB: BDTER, Withdrawal Date
    MovementType VARCHAR(3),              -- RESB: BWART, Movement Type
    FOREIGN KEY (MaterialID) REFERENCES MaterialMaster(MaterialID)
    -- Other fields...
);

-- PlanningFileEntry Table
CREATE TABLE PlanningFileEntry (
    MaterialID VARCHAR(18),               -- S024: MATNR, Material Number
    Plant VARCHAR(4),                     -- S024: WERKS, Plant
    MRPStatus CHAR(1),                    -- S024: KZDIS, MRP Status
    LastMRPDate DATE,                     -- S024: MMDDA, Last MRP Date
    TotalReplenishmentLeadTime INT,       -- S024: WZEIT, Total Replenishment Lead Time
    PRIMARY KEY (MaterialID, Plant),
    FOREIGN KEY (MaterialID) REFERENCES MaterialMaster(MaterialID)
    -- Other fields...
);