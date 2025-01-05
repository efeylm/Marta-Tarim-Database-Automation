-- Create Tables
CREATE TABLE PlantTypeRequirement (
    PlantType VARCHAR(50) PRIMARY KEY CHECK (PlantType IN ('Seed', 'Seedling', 'Potted')),
    RequiredTemperature DECIMAL(4,1) NOT NULL DEFAULT 20.0
);

CREATE TABLE ChemicalCategoryRequirement (
    Category VARCHAR(50) PRIMARY KEY CHECK (Category IN ('Fertilizer', 'Insecticide', 'Fungicide', 'Herbicide')),
    RequiredTemperature DECIMAL(4,1) NOT NULL DEFAULT 20.0
);

CREATE TABLE Employee (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    FullName AS (FirstName + ' ' + LastName) PERSISTED,  -- Computed column
    Role VARCHAR(50) NOT NULL CHECK (Role IN ('Manager', 'Salesperson', 'Consultant', 'Worker')),
    ContactInfo VARCHAR(100) NOT NULL,
    HireDate DATE DEFAULT GETDATE(),
	Password VARCHAR(50) NOT NULL,
    UNIQUE (ContactInfo)
);

CREATE TABLE Customer (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    NoOfSelledProduct INT DEFAULT 0,
    PaidCost DECIMAL(10,2) DEFAULT 0.00,
    Debt DECIMAL(10,2) DEFAULT 0.00,
    ContactInfo VARCHAR(100) NOT NULL,
    TotalBalance AS (PaidCost - Debt) PERSISTED,  -- Computed column
    UNIQUE (ContactInfo),
    CHECK (Debt >= 0)
);

CREATE TABLE Product (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    Price DECIMAL(10,2) NOT NULL CHECK (Price > 0),
    PurchaseDate DATE DEFAULT GETDATE(),
    ProductType VARCHAR(50) NOT NULL CHECK (ProductType IN ('Chemical', 'Tool', 'Plant')),
    INDEX idx_product_type (ProductType)  -- Index for frequent searches
);

CREATE TABLE Plant (
    PlantID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT FOREIGN KEY REFERENCES Product(ProductID),
    PlantType VARCHAR(50) FOREIGN KEY REFERENCES PlantTypeRequirement(PlantType)
);

CREATE TABLE Seed (
    SeedID INT IDENTITY(1,1) PRIMARY KEY,
    PlantID INT FOREIGN KEY REFERENCES Plant(PlantID),
    SeedType VARCHAR(50) NOT NULL,
    INDEX idx_seed_type (SeedType)
);

CREATE TABLE Seedling (
    SeedlingID INT IDENTITY(1,1) PRIMARY KEY,
    PlantID INT FOREIGN KEY REFERENCES Plant(PlantID),
    SeedlingType VARCHAR(50) NOT NULL
);

CREATE TABLE Potted (
    PottedID INT IDENTITY(1,1) PRIMARY KEY,
    PlantID INT FOREIGN KEY REFERENCES Plant(PlantID),
    PottedType VARCHAR(50) NOT NULL
);

CREATE TABLE ChemicalGood (
    GoodID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT FOREIGN KEY REFERENCES Product(ProductID),
    ExpirationDate DATE NOT NULL,
    Category VARCHAR(50) FOREIGN KEY REFERENCES ChemicalCategoryRequirement(Category),
    INDEX idx_expiration (ExpirationDate)
);

CREATE TABLE Fertilizer (
    FertilizerID INT IDENTITY(1,1) PRIMARY KEY,
    GoodID INT FOREIGN KEY REFERENCES ChemicalGood(GoodID),
    FertilizerName VARCHAR(100) NOT NULL,
    UNIQUE (FertilizerName)
);

CREATE TABLE Fungicide (
    FungicideID INT IDENTITY(1,1) PRIMARY KEY,
    GoodID INT FOREIGN KEY REFERENCES ChemicalGood(GoodID),
    FungicideName VARCHAR(100) NOT NULL,
    UNIQUE (FungicideName)
);

CREATE TABLE Herbicide (
    HerbicideID INT IDENTITY(1,1) PRIMARY KEY,
    GoodID INT FOREIGN KEY REFERENCES ChemicalGood(GoodID),
    HerbicideName VARCHAR(100) NOT NULL,
    UNIQUE (HerbicideName)
);

CREATE TABLE Insecticide (
    InsecticideID INT IDENTITY(1,1) PRIMARY KEY,
    GoodID INT FOREIGN KEY REFERENCES ChemicalGood(GoodID),
    InsecticideName VARCHAR(100) NOT NULL,
    UNIQUE (InsecticideName)
);

CREATE TABLE Tool (
    ToolID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT FOREIGN KEY REFERENCES Product(ProductID),
    ToolName VARCHAR(100) NOT NULL,
    ToolType VARCHAR(50) NOT NULL,
    Condition VARCHAR(20) DEFAULT 'New' CHECK (Condition IN ('New', 'Good', 'Fair', 'Poor')),
    UNIQUE (ToolName)
);

CREATE TABLE Inventory (
    InventoryID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT FOREIGN KEY REFERENCES Product(ProductID),
    Quantity INT DEFAULT 0 CHECK (Quantity >= 0),
    MinStockLevel INT DEFAULT 5,
    StockStatus AS (CASE WHEN Quantity <= MinStockLevel THEN 'Low' ELSE 'OK' END),  -- Computed column
    UNIQUE (ProductID)
);

CREATE TABLE Visit (
    VisitID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID),
    EmployeeID INT FOREIGN KEY REFERENCES Employee(EmployeeID),
    VisitDate DATE DEFAULT GETDATE(),
    VisitLocation VARCHAR(100) NOT NULL,
    INDEX idx_visit_date (VisitDate)
);

CREATE TABLE Sale (
    SaleID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID),
    ProductID INT FOREIGN KEY REFERENCES Product(ProductID),
    SaleDate DATE DEFAULT GETDATE(),
    PaymentStatus VARCHAR(20) DEFAULT 'Pending' CHECK (PaymentStatus IN ('Pending', 'Completed', 'Cancelled')),
    TotalAmount DECIMAL(10,2) NOT NULL CHECK (TotalAmount > 0),
    INDEX idx_sale_date (SaleDate)
);