-- First, insert plant type requirements
INSERT INTO PlantTypeRequirement (PlantType, RequiredTemperature) VALUES
('Seed', 18.5),
('Seedling', 22.0),
('Potted', 20.0);

-- Insert chemical category requirements
INSERT INTO ChemicalCategoryRequirement (Category, RequiredTemperature) VALUES
('Fertilizer', 15.0),
('Insecticide', 18.0),
('Fungicide', 20.0),
('Herbicide', 22.0);

-- Insert employees
INSERT INTO Employee (FirstName, LastName, Role, ContactInfo, HireDate, Password) VALUES
('John', 'Smith', 'Manager', 'john.smith@email.com', '2023-01-15', 'pass123'),
('Mary', 'Johnson', 'Salesperson', 'mary.j@email.com', '2023-02-01', 'pass456'),
('Robert', 'Davis', 'Consultant', 'robert.d@email.com', '2023-03-10', 'pass789'),
('Sarah', 'Wilson', 'Worker', 'sarah.w@email.com', '2023-04-20', 'pass321');

-- Insert customers
INSERT INTO Customer (CustomerName, ContactInfo) VALUES
('Green Gardens LLC', 'contact@greengardens.com'),
('Home Depot', 'supplier@homedepot.com'),
('Local Farm Co', 'info@localfarm.com'),
('City Parks Department', 'parks@citygovt.com');

-- Insert products
INSERT INTO Product (Price, PurchaseDate, ProductType) VALUES
-- Plants
(25.99, '2024-01-01', 'Plant'),  -- ID: 1
(15.99, '2024-01-01', 'Plant'),  -- ID: 2
(35.99, '2024-01-01', 'Plant'),  -- ID: 3
-- Chemicals
(45.99, '2024-01-01', 'Chemical'),  -- ID: 4
(55.99, '2024-01-01', 'Chemical'),  -- ID: 5
(65.99, '2024-01-01', 'Chemical'),  -- ID: 6
(75.99, '2024-01-01', 'Chemical'),  -- ID: 7
-- Tools
(29.99, '2024-01-01', 'Tool'),  -- ID: 8
(39.99, '2024-01-01', 'Tool'),  -- ID: 9
(49.99, '2024-01-01', 'Tool');  -- ID: 10

-- Insert plants
INSERT INTO Plant (ProductID, PlantType) VALUES
(1, 'Seed'),
(2, 'Seedling'),
(3, 'Potted');

-- Insert seeds
INSERT INTO Seed (PlantID, SeedType) VALUES
(1, 'Tomato');

-- Insert seedlings
INSERT INTO Seedling (PlantID, SeedlingType) VALUES
(2, 'Pepper');

-- Insert potted plants
INSERT INTO Potted (PlantID, PottedType) VALUES
(3, 'Rose');

-- Insert chemical goods
INSERT INTO ChemicalGood (ProductID, ExpirationDate, Category) VALUES
(4, '2025-12-31', 'Fertilizer'),
(5, '2025-12-31', 'Insecticide'),
(6, '2025-12-31', 'Fungicide'),
(7, '2025-12-31', 'Herbicide');

-- Insert fertilizers
INSERT INTO Fertilizer (GoodID, FertilizerName) VALUES
(1, 'All-Purpose Plant Food');

-- Insert insecticides
INSERT INTO Insecticide (GoodID, InsecticideName) VALUES
(2, 'Bug-B-Gone');

-- Insert fungicides
INSERT INTO Fungicide (GoodID, FungicideName) VALUES
(3, 'Anti-Fungal Spray');

-- Insert herbicides
INSERT INTO Herbicide (GoodID, HerbicideName) VALUES
(4, 'Weed Control Plus');

-- Insert tools
INSERT INTO Tool (ProductID, ToolName, ToolType, Condition) VALUES
(8, 'Premium Garden Shears', 'Cutting', 'New'),
(9, 'Ergonomic Trowel', 'Digging', 'New'),
(10, 'Heavy-Duty Rake', 'Cleaning', 'New');

-- Insert inventory records
INSERT INTO Inventory (ProductID, Quantity, MinStockLevel) VALUES
(1, 100, 20),
(2, 75, 15),
(3, 50, 10),
(4, 200, 30),
(5, 150, 25),
(6, 125, 20),
(7, 100, 20),
(8, 50, 10),
(9, 40, 8),
(10, 30, 5);

-- Insert visits
INSERT INTO Visit (CustomerID, EmployeeID, VisitDate, VisitLocation) VALUES
(1, 2, '2024-01-02', 'Green Gardens Main Office'),
(2, 2, '2024-01-03', 'Home Depot Store #123'),
(3, 3, '2024-01-04', 'Local Farm Location'),
(4, 3, '2024-01-05', 'City Park Central');

-- Insert sales
INSERT INTO Sale (CustomerID, ProductID, SaleDate, PaymentStatus, TotalAmount) VALUES
(1, 1, '2024-01-02', 'Completed', 259.90),
(2, 4, '2024-01-03', 'Completed', 459.90),
(3, 8, '2024-01-04', 'Pending', 299.90),
(4, 3, '2024-01-05', 'Completed', 359.90);

-- Update customer statistics based on sales
UPDATE Customer 
SET NoOfSelledProduct = 1,
    PaidCost = 259.90,
    Debt = 0.00
WHERE CustomerID = 1;

UPDATE Customer 
SET NoOfSelledProduct = 1,
    PaidCost = 459.90,
    Debt = 0.00
WHERE CustomerID = 2;

UPDATE Customer 
SET NoOfSelledProduct = 1,
    PaidCost = 0.00,
    Debt = 299.90
WHERE CustomerID = 3;

UPDATE Customer 
SET NoOfSelledProduct = 1,
    PaidCost = 359.90,
    Debt = 0.00
WHERE CustomerID = 4;