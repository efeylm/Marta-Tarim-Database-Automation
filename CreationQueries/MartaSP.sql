CREATE PROCEDURE AddNewSeed
    @SeedType VARCHAR(50),
    @Price DECIMAL(10,2),
    @Quantity INT = NULL, -- Optional for Inventory
    @MinStockLevel INT = NULL -- Optional for Inventory
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Step 1: Validate Input Parameters
        IF @SeedType IS NULL OR LTRIM(RTRIM(@SeedType)) = ''
        BEGIN
            RAISERROR('SeedType cannot be NULL or empty.', 16, 1);
            RETURN;
        END
        IF @Price <= 0
        BEGIN
            RAISERROR('Price must be greater than zero.', 16, 1);
            RETURN;
        END

        -- Step 2: Insert into Product Table
        INSERT INTO Product (Price, ProductType)
        VALUES (@Price, 'Plant');

        -- Retrieve the newly generated ProductID
        DECLARE @NewProductID INT = SCOPE_IDENTITY();

        -- Step 3: Insert into Plant Table
        INSERT INTO Plant (ProductID, PlantType)
        VALUES (@NewProductID, 'Seed');

        -- Retrieve the newly generated PlantID
        DECLARE @NewPlantID INT = SCOPE_IDENTITY();

        -- Step 4: Insert into Seed Table
        INSERT INTO Seed (PlantID, SeedType)
        VALUES (@NewPlantID, @SeedType);

        -- Optional Step: Add to Inventory Table if Quantity and MinStockLevel are provided
        IF @Quantity IS NOT NULL AND @MinStockLevel IS NOT NULL
        BEGIN
            IF @Quantity < 0 OR @MinStockLevel < 0
            BEGIN
                RAISERROR('Quantity and MinStockLevel must be non-negative.', 16, 1);
                RETURN;
            END

            INSERT INTO Inventory (ProductID, Quantity, MinStockLevel)
            VALUES (@NewProductID, @Quantity, @MinStockLevel);
        END

        -- Success Message
        SELECT 
            'New seed added successfully.' AS Message,
            @NewProductID AS ProductID,
            @NewPlantID AS PlantID;
    END TRY
    BEGIN CATCH
        -- Handle Errors
        IF ERROR_NUMBER() = 2627 -- Unique constraint violation
        BEGIN
            RAISERROR('Duplicate entry detected.', 16, 1);
        END
        ELSE
        BEGIN
            THROW; -- Re-throw the original error
        END
    END CATCH
END
GO


CREATE PROCEDURE AddCustomer
    @CustomerName VARCHAR(100),
    @ContactInfo VARCHAR(100),
    @NoOfSelledProduct INT = 0,
    @PaidCost DECIMAL(10,2) = 0.00,
    @Debt DECIMAL(10,2) = 0.00
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validate input parameters
        IF @CustomerName IS NULL OR LTRIM(RTRIM(@CustomerName)) = ''
        BEGIN
            RAISERROR('CustomerName cannot be NULL or empty.', 16, 1);
            RETURN;
        END

        IF @ContactInfo IS NULL OR LTRIM(RTRIM(@ContactInfo)) = ''
        BEGIN
            RAISERROR('ContactInfo cannot be NULL or empty.', 16, 1);
            RETURN;
        END

        IF @Debt < 0
        BEGIN
            RAISERROR('Debt cannot be negative.', 16, 1);
            RETURN;
        END

        -- Insert the new customer
        INSERT INTO Customer (CustomerName, NoOfSelledProduct, PaidCost, Debt, ContactInfo)
        VALUES (@CustomerName, @NoOfSelledProduct, @PaidCost, @Debt, @ContactInfo);

        -- Retrieve the newly inserted CustomerID
        DECLARE @NewCustomerID INT = SCOPE_IDENTITY();

        -- Return success message with the new CustomerID
        SELECT 
            'Customer added successfully.' AS Message,
            @NewCustomerID AS NewCustomerID;
    END TRY
    BEGIN CATCH
        -- Check if the error is due to unique constraint violation on ContactInfo
        IF ERROR_NUMBER() = 2627 -- Unique constraint error number
        BEGIN
            RAISERROR('A customer with the provided ContactInfo already exists.', 16, 1);
        END
        ELSE
        BEGIN
            -- Re-throw the original error using THROW
            THROW;
        END
    END CATCH
END
GO


CREATE PROCEDURE AddNewSeedling
    @SeedlingType VARCHAR(50),
    @Price DECIMAL(10,2),
    @Quantity INT = NULL, -- Optional for Inventory
    @MinStockLevel INT = NULL -- Optional for Inventory
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Step 1: Validate Input Parameters
        IF @SeedlingType IS NULL OR LTRIM(RTRIM(@SeedlingType)) = ''
        BEGIN
            RAISERROR('SeedlingType cannot be NULL or empty.', 16, 1);
            RETURN;
        END
        IF @Price <= 0
        BEGIN
            RAISERROR('Price must be greater than zero.', 16, 1);
            RETURN;
        END

        -- Step 2: Insert into Product Table
        INSERT INTO Product (Price, ProductType)
        VALUES (@Price, 'Plant');

        -- Retrieve the newly generated ProductID
        DECLARE @NewProductID INT = SCOPE_IDENTITY();

        -- Step 3: Insert into Plant Table
        INSERT INTO Plant (ProductID, PlantType)
        VALUES (@NewProductID, 'Seedling');

        -- Retrieve the newly generated PlantID
        DECLARE @NewPlantID INT = SCOPE_IDENTITY();

        -- Step 4: Insert into Seedling Table
        INSERT INTO Seedling (PlantID, SeedlingType)
        VALUES (@NewPlantID, @SeedlingType);

        -- Optional Step: Add to Inventory Table if Quantity and MinStockLevel are provided
        IF @Quantity IS NOT NULL AND @MinStockLevel IS NOT NULL
        BEGIN
            IF @Quantity < 0 OR @MinStockLevel < 0
            BEGIN
                RAISERROR('Quantity and MinStockLevel must be non-negative.', 16, 1);
                RETURN;
            END

            INSERT INTO Inventory (ProductID, Quantity, MinStockLevel)
            VALUES (@NewProductID, @Quantity, @MinStockLevel);
        END

        -- Success Message
        SELECT 
            'New seedling added successfully.' AS Message,
            @NewProductID AS ProductID,
            @NewPlantID AS PlantID;
    END TRY
    BEGIN CATCH
        -- Handle Errors
        IF ERROR_NUMBER() = 2627 -- Unique constraint violation
        BEGIN
            RAISERROR('Duplicate entry detected.', 16, 1);
        END
        ELSE
        BEGIN
            THROW; -- Re-throw the original error
        END
    END CATCH
END
GO


CREATE PROCEDURE AddNewPotted
    @PottedType VARCHAR(50),
    @Price DECIMAL(10,2),
    @Quantity INT = NULL, -- Optional for Inventory
    @MinStockLevel INT = NULL -- Optional for Inventory
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Step 1: Validate Input Parameters
        IF @PottedType IS NULL OR LTRIM(RTRIM(@PottedType)) = ''
        BEGIN
            RAISERROR('PottedType cannot be NULL or empty.', 16, 1);
            RETURN;
        END
        IF @Price <= 0
        BEGIN
            RAISERROR('Price must be greater than zero.', 16, 1);
            RETURN;
        END

        -- Step 2: Insert into Product Table
        INSERT INTO Product (Price, ProductType)
        VALUES (@Price, 'Plant');

        -- Retrieve the newly generated ProductID
        DECLARE @NewProductID INT = SCOPE_IDENTITY();

        -- Step 3: Insert into Plant Table
        INSERT INTO Plant (ProductID, PlantType)
        VALUES (@NewProductID, 'Potted');

        -- Retrieve the newly generated PlantID
        DECLARE @NewPlantID INT = SCOPE_IDENTITY();

        -- Step 4: Insert into Potted Table
        INSERT INTO Potted (PlantID, PottedType)
        VALUES (@NewPlantID, @PottedType);

        -- Optional Step: Add to Inventory Table if Quantity and MinStockLevel are provided
        IF @Quantity IS NOT NULL AND @MinStockLevel IS NOT NULL
        BEGIN
            IF @Quantity < 0 OR @MinStockLevel < 0
            BEGIN
                RAISERROR('Quantity and MinStockLevel must be non-negative.', 16, 1);
                RETURN;
            END

            INSERT INTO Inventory (ProductID, Quantity, MinStockLevel)
            VALUES (@NewProductID, @Quantity, @MinStockLevel);
        END

        -- Success Message
        SELECT 
            'New potted plant added successfully.' AS Message,
            @NewProductID AS ProductID,
            @NewPlantID AS PlantID;
    END TRY
    BEGIN CATCH
        -- Handle Errors
        IF ERROR_NUMBER() = 2627 -- Unique constraint violation
        BEGIN
            RAISERROR('Duplicate entry detected.', 16, 1);
        END
        ELSE
        BEGIN
            THROW; -- Re-throw the original error
        END
    END CATCH
END
GO

CREATE PROCEDURE AddNewFertilizer
    @FertilizerName VARCHAR(100),
    @Price DECIMAL(10,2),
    @ExpirationDate DATE,
    @Quantity INT = NULL, -- Optional for Inventory
    @MinStockLevel INT = NULL -- Optional for Inventory
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Step 1: Validate Input Parameters
        IF @FertilizerName IS NULL OR LTRIM(RTRIM(@FertilizerName)) = ''
        BEGIN
            RAISERROR('FertilizerName cannot be NULL or empty.', 16, 1);
            RETURN;
        END
        IF @Price <= 0
        BEGIN
            RAISERROR('Price must be greater than zero.', 16, 1);
            RETURN;
        END
        IF @ExpirationDate IS NULL OR @ExpirationDate <= GETDATE()
        BEGIN
            RAISERROR('ExpirationDate must be a future date.', 16, 1);
            RETURN;
        END

        -- Step 2: Insert into Product Table
        INSERT INTO Product (Price, ProductType)
        VALUES (@Price, 'Chemical');

        -- Retrieve the newly generated ProductID
        DECLARE @NewProductID INT = SCOPE_IDENTITY();

        -- Step 3: Insert into ChemicalGood Table
        INSERT INTO ChemicalGood (ProductID, ExpirationDate, Category)
        VALUES (@NewProductID, @ExpirationDate, 'Fertilizer');

        -- Retrieve the newly generated GoodID
        DECLARE @NewGoodID INT = SCOPE_IDENTITY();

        -- Step 4: Insert into Fertilizer Table
        INSERT INTO Fertilizer (GoodID, FertilizerName)
        VALUES (@NewGoodID, @FertilizerName);

        -- Optional Step: Add to Inventory Table if Quantity and MinStockLevel are provided
        IF @Quantity IS NOT NULL AND @MinStockLevel IS NOT NULL
        BEGIN
            IF @Quantity < 0 OR @MinStockLevel < 0
            BEGIN
                RAISERROR('Quantity and MinStockLevel must be non-negative.', 16, 1);
                RETURN;
            END

            INSERT INTO Inventory (ProductID, Quantity, MinStockLevel)
            VALUES (@NewProductID, @Quantity, @MinStockLevel);
        END

        -- Success Message
        SELECT 
            'New fertilizer added successfully.' AS Message,
            @NewProductID AS ProductID,
            @NewGoodID AS GoodID;
    END TRY
    BEGIN CATCH
        -- Handle Errors
        IF ERROR_NUMBER() = 2627 -- Unique constraint violation
        BEGIN
            RAISERROR('Duplicate entry detected.', 16, 1);
        END
        ELSE
        BEGIN
            THROW; -- Re-throw the original error
        END
    END CATCH
END
GO

CREATE PROCEDURE AddNewFungicide
    @FungicideName VARCHAR(100),
    @Price DECIMAL(10,2),
    @ExpirationDate DATE,
    @Quantity INT = NULL,
    @MinStockLevel INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validate Parameters
        IF @FungicideName IS NULL OR LTRIM(RTRIM(@FungicideName)) = ''
        BEGIN
            RAISERROR('FungicideName cannot be NULL or empty.', 16, 1);
            RETURN;
        END
        IF @Price <= 0
        BEGIN
            RAISERROR('Price must be greater than zero.', 16, 1);
            RETURN;
        END
        IF @ExpirationDate < GETDATE()
        BEGIN
            RAISERROR('ExpirationDate must be in the future.', 16, 1);
            RETURN;
        END

        -- Insert into Product
        INSERT INTO Product (Price, ProductType)
        VALUES (@Price, 'Chemical');

        DECLARE @NewProductID INT = SCOPE_IDENTITY();

        -- Insert into ChemicalGood
        INSERT INTO ChemicalGood (ProductID, ExpirationDate, Category)
        VALUES (@NewProductID, @ExpirationDate, 'Fungicide');

        DECLARE @NewGoodID INT = SCOPE_IDENTITY();

        -- Insert into Fungicide
        INSERT INTO Fungicide (GoodID, FungicideName)
        VALUES (@NewGoodID, @FungicideName);

        -- Optional Inventory Update
        IF @Quantity IS NOT NULL AND @MinStockLevel IS NOT NULL
        BEGIN
            IF @Quantity < 0 OR @MinStockLevel < 0
            BEGIN
                RAISERROR('Quantity and MinStockLevel must be non-negative.', 16, 1);
                RETURN;
            END

            INSERT INTO Inventory (ProductID, Quantity, MinStockLevel)
            VALUES (@NewProductID, @Quantity, @MinStockLevel);
        END

        SELECT 
            'New fungicide added successfully.' AS Message,
            @NewProductID AS ProductID,
            @NewGoodID AS GoodID;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO



CREATE PROCEDURE AddNewHerbicide
    @HerbicideName VARCHAR(100),
    @Price DECIMAL(10,2),
    @ExpirationDate DATE,
    @Quantity INT = NULL,
    @MinStockLevel INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @HerbicideName IS NULL OR LTRIM(RTRIM(@HerbicideName)) = ''
        BEGIN
            RAISERROR('HerbicideName cannot be NULL or empty.', 16, 1);
            RETURN;
        END
        IF @Price <= 0
        BEGIN
            RAISERROR('Price must be greater than zero.', 16, 1);
            RETURN;
        END
        IF @ExpirationDate < GETDATE()
        BEGIN
            RAISERROR('ExpirationDate must be in the future.', 16, 1);
            RETURN;
        END

        INSERT INTO Product (Price, ProductType)
        VALUES (@Price, 'Chemical');

        DECLARE @NewProductID INT = SCOPE_IDENTITY();

        INSERT INTO ChemicalGood (ProductID, ExpirationDate, Category)
        VALUES (@NewProductID, @ExpirationDate, 'Herbicide');

        DECLARE @NewGoodID INT = SCOPE_IDENTITY();

        INSERT INTO Herbicide (GoodID, HerbicideName)
        VALUES (@NewGoodID, @HerbicideName);

        IF @Quantity IS NOT NULL AND @MinStockLevel IS NOT NULL
        BEGIN
            IF @Quantity < 0 OR @MinStockLevel < 0
            BEGIN
                RAISERROR('Quantity and MinStockLevel must be non-negative.', 16, 1);
                RETURN;
            END

            INSERT INTO Inventory (ProductID, Quantity, MinStockLevel)
            VALUES (@NewProductID, @Quantity, @MinStockLevel);
        END

        SELECT 
            'New herbicide added successfully.' AS Message,
            @NewProductID AS ProductID,
            @NewGoodID AS GoodID;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO


CREATE PROCEDURE AddNewInsecticide
    @InsecticideName VARCHAR(100),
    @Price DECIMAL(10,2),
    @ExpirationDate DATE,
    @Quantity INT = NULL,
    @MinStockLevel INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @InsecticideName IS NULL OR LTRIM(RTRIM(@InsecticideName)) = ''
        BEGIN
            RAISERROR('InsecticideName cannot be NULL or empty.', 16, 1);
            RETURN;
        END
        IF @Price <= 0
        BEGIN
            RAISERROR('Price must be greater than zero.', 16, 1);
            RETURN;
        END
        IF @ExpirationDate < GETDATE()
        BEGIN
            RAISERROR('ExpirationDate must be in the future.', 16, 1);
            RETURN;
        END

        INSERT INTO Product (Price, ProductType)
        VALUES (@Price, 'Chemical');

        DECLARE @NewProductID INT = SCOPE_IDENTITY();

        INSERT INTO ChemicalGood (ProductID, ExpirationDate, Category)
        VALUES (@NewProductID, @ExpirationDate, 'Insecticide');

        DECLARE @NewGoodID INT = SCOPE_IDENTITY();

        INSERT INTO Insecticide (GoodID, InsecticideName)
        VALUES (@NewGoodID, @InsecticideName);

        IF @Quantity IS NOT NULL AND @MinStockLevel IS NOT NULL
        BEGIN
            IF @Quantity < 0 OR @MinStockLevel < 0
            BEGIN
                RAISERROR('Quantity and MinStockLevel must be non-negative.', 16, 1);
                RETURN;
            END

            INSERT INTO Inventory (ProductID, Quantity, MinStockLevel)
            VALUES (@NewProductID, @Quantity, @MinStockLevel);
        END

        SELECT 
            'New insecticide added successfully.' AS Message,
            @NewProductID AS ProductID,
            @NewGoodID AS GoodID;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO


CREATE PROCEDURE AddNewSale
    @CustomerID INT,
    @ProductID INT,
    @TotalAmount DECIMAL(10,2),
    @PaymentStatus VARCHAR(20) -- 'Completed', 'Pending', or 'Cancelled'
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validate Input Parameters
        IF @CustomerID IS NULL OR @ProductID IS NULL OR @TotalAmount <= 0
        BEGIN
            RAISERROR('Invalid input parameters.', 16, 1);
            RETURN;
        END

        IF @PaymentStatus NOT IN ('Completed', 'Pending', 'Cancelled')
        BEGIN
            RAISERROR('Invalid PaymentStatus value.', 16, 1);
            RETURN;
        END

        -- Insert Sale Record
        INSERT INTO Sale (CustomerID, ProductID, TotalAmount, PaymentStatus)
        VALUES (@CustomerID, @ProductID, @TotalAmount, @PaymentStatus);

        -- Return success message with the SaleID
        SELECT 
            'Sale added successfully.' AS Message,
            SCOPE_IDENTITY() AS SaleID;
    END TRY
    BEGIN CATCH
        -- Handle Errors
        THROW;
    END CATCH
END
GO


CREATE PROCEDURE AddNewTool
    @ToolName VARCHAR(100),
    @ToolType VARCHAR(50),
    @Condition VARCHAR(20), -- e.g., 'New', 'Good', 'Fair', 'Poor'
    @Price DECIMAL(10,2),
    @Quantity INT = NULL, -- Optional for Inventory
    @MinStockLevel INT = NULL -- Optional for Inventory
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Step 1: Validate Input Parameters
        IF @ToolName IS NULL OR LTRIM(RTRIM(@ToolName)) = ''
        BEGIN
            RAISERROR('ToolName cannot be NULL or empty.', 16, 1);
            RETURN;
        END
        IF @ToolType IS NULL OR LTRIM(RTRIM(@ToolType)) = ''
        BEGIN
            RAISERROR('ToolType cannot be NULL or empty.', 16, 1);
            RETURN;
        END
        IF @Condition NOT IN ('New', 'Good', 'Fair', 'Poor')
        BEGIN
            RAISERROR('Invalid Tool Condition.', 16, 1);
            RETURN;
        END
        IF @Price <= 0
        BEGIN
            RAISERROR('Price must be greater than zero.', 16, 1);
            RETURN;
        END

        -- Step 2: Insert into Product Table
        INSERT INTO Product (Price, ProductType)
        VALUES (@Price, 'Tool');

        -- Retrieve the newly generated ProductID
        DECLARE @NewProductID INT = SCOPE_IDENTITY();

        -- Step 3: Insert into Tool Table
        INSERT INTO Tool (ProductID, ToolName, ToolType, Condition)
        VALUES (@NewProductID, @ToolName, @ToolType, @Condition);

        -- Optional Step: Add to Inventory Table if Quantity and MinStockLevel are provided
        IF @Quantity IS NOT NULL AND @MinStockLevel IS NOT NULL
        BEGIN
            IF @Quantity < 0 OR @MinStockLevel < 0
            BEGIN
                RAISERROR('Quantity and MinStockLevel must be non-negative.', 16, 1);
                RETURN;
            END

            INSERT INTO Inventory (ProductID, Quantity, MinStockLevel)
            VALUES (@NewProductID, @Quantity, @MinStockLevel);
        END

        -- Success Message
        SELECT 
            'New tool added successfully.' AS Message,
            @NewProductID AS ProductID;
    END TRY
    BEGIN CATCH
        -- Handle Errors
        IF ERROR_NUMBER() = 2627 -- Unique constraint violation
        BEGIN
            RAISERROR('Duplicate entry detected.', 16, 1);
        END
        ELSE
        BEGIN
            THROW; -- Re-throw the original error
        END
    END CATCH
END
GO


CREATE PROCEDURE AddNewVisit
    @CustomerID INT,
    @EmployeeID INT,
    @VisitLocation VARCHAR(100),
    @VisitDate DATE = NULL -- Optional; uses current date if not provided
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Step 1: Validate Input Parameters
        IF @CustomerID IS NULL OR @EmployeeID IS NULL OR LTRIM(RTRIM(@VisitLocation)) = ''
        BEGIN
            RAISERROR('Invalid input parameters. CustomerID, EmployeeID, and VisitLocation are required.', 16, 1);
            RETURN;
        END

        -- Step 2: Use current date if VisitDate is not specified
        IF @VisitDate IS NULL
        BEGIN
            SET @VisitDate = GETDATE();
        END

        -- Step 3: Insert into Visit Table
        INSERT INTO Visit (CustomerID, EmployeeID, VisitLocation, VisitDate)
        VALUES (@CustomerID, @EmployeeID, @VisitLocation, @VisitDate);

        -- Step 4: Success Message
        SELECT 
            'New visit added successfully.' AS Message,
            SCOPE_IDENTITY() AS VisitID;
    END TRY
    BEGIN CATCH
        -- Handle Errors
        THROW;
    END CATCH
END
GO



CREATE PROCEDURE AddNewEmployee
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Role VARCHAR(50), -- Must be 'Manager', 'Salesperson', 'Consultant', or 'Worker'
    @ContactInfo VARCHAR(100),
    @Password VARCHAR(50),
    @HireDate DATE = NULL -- Optional; uses current date if not provided
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Step 1: Validate Input Parameters
        IF @FirstName IS NULL OR LTRIM(RTRIM(@FirstName)) = ''
        BEGIN
            RAISERROR('FirstName cannot be NULL or empty.', 16, 1);
            RETURN;
        END
        IF @LastName IS NULL OR LTRIM(RTRIM(@LastName)) = ''
        BEGIN
            RAISERROR('LastName cannot be NULL or empty.', 16, 1);
            RETURN;
        END
        IF @Role NOT IN ('Manager', 'Salesperson', 'Consultant', 'Worker')
        BEGIN
            RAISERROR('Invalid Role. Must be Manager, Salesperson, Consultant, or Worker.', 16, 1);
            RETURN;
        END
        IF @ContactInfo IS NULL OR LTRIM(RTRIM(@ContactInfo)) = ''
        BEGIN
            RAISERROR('ContactInfo cannot be NULL or empty.', 16, 1);
            RETURN;
        END
        IF @Password IS NULL OR LTRIM(RTRIM(@Password)) = ''
        BEGIN
            RAISERROR('Password cannot be NULL or empty.', 16, 1);
            RETURN;
        END

        -- Step 2: Use current date if HireDate is not specified
        IF @HireDate IS NULL
        BEGIN
            SET @HireDate = GETDATE();
        END

        -- Step 3: Insert into Employee Table
        INSERT INTO Employee (FirstName, LastName, Role, ContactInfo, Password, HireDate)
        VALUES (@FirstName, @LastName, @Role, @ContactInfo, @Password, @HireDate);

        -- Step 4: Success Message
        SELECT 
            'New employee added successfully.' AS Message,
            SCOPE_IDENTITY() AS EmployeeID;
    END TRY
    BEGIN CATCH
        -- Handle Errors
        THROW;
    END CATCH
END
GO


CREATE PROCEDURE DeleteProduct
    @ProductID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Step 1: Identify Product Type
        DECLARE @ProductType VARCHAR(50);
        DECLARE @PlantID INT;
        DECLARE @GoodID INT;

        SELECT @ProductType = ProductType FROM Product WHERE ProductID = @ProductID;

        IF @ProductType IS NULL
        BEGIN
            RAISERROR('ProductID not found.', 16, 1);
            RETURN;
        END

        -- Step 2: Handle Based on Product Type
        IF @ProductType = 'Plant'
        BEGIN
            -- Get PlantID
            SELECT @PlantID = PlantID FROM Plant WHERE ProductID = @ProductID;

            IF @PlantID IS NOT NULL
            BEGIN
                -- Check if it's a Seed
                IF EXISTS (SELECT 1 FROM Seed WHERE PlantID = @PlantID)
                BEGIN
                    DELETE FROM Seed WHERE PlantID = @PlantID;
                END

                -- Check if it's a Seedling
                IF EXISTS (SELECT 1 FROM Seedling WHERE PlantID = @PlantID)
                BEGIN
                    DELETE FROM Seedling WHERE PlantID = @PlantID;
                END

                -- Check if it's a Potted Plant
                IF EXISTS (SELECT 1 FROM Potted WHERE PlantID = @PlantID)
                BEGIN
                    DELETE FROM Potted WHERE PlantID = @PlantID;
                END

                -- Delete from Plant Table
                DELETE FROM Plant WHERE PlantID = @PlantID;
            END
        END
        ELSE IF @ProductType = 'Chemical'
        BEGIN
            -- Get GoodID
            SELECT @GoodID = GoodID FROM ChemicalGood WHERE ProductID = @ProductID;

            IF @GoodID IS NOT NULL
            BEGIN
                -- Check if it's Fertilizer
                IF EXISTS (SELECT 1 FROM Fertilizer WHERE GoodID = @GoodID)
                BEGIN
                    DELETE FROM Fertilizer WHERE GoodID = @GoodID;
                END

                -- Check if it's Fungicide
                IF EXISTS (SELECT 1 FROM Fungicide WHERE GoodID = @GoodID)
                BEGIN
                    DELETE FROM Fungicide WHERE GoodID = @GoodID;
                END

                -- Check if it's Herbicide
                IF EXISTS (SELECT 1 FROM Herbicide WHERE GoodID = @GoodID)
                BEGIN
                    DELETE FROM Herbicide WHERE GoodID = @GoodID;
                END

                -- Check if it's Insecticide
                IF EXISTS (SELECT 1 FROM Insecticide WHERE GoodID = @GoodID)
                BEGIN
                    DELETE FROM Insecticide WHERE GoodID = @GoodID;
                END

                -- Delete from ChemicalGood Table
                DELETE FROM ChemicalGood WHERE GoodID = @GoodID;
            END
        END
        ELSE IF @ProductType = 'Tool'
        BEGIN
            -- Delete from Tool Table
            DELETE FROM Tool WHERE ProductID = @ProductID;
        END

        -- Step 3: Delete from Inventory Table (if exists)
        DELETE FROM Inventory WHERE ProductID = @ProductID;

        -- Step 4: Delete from Product Table
        DELETE FROM Product WHERE ProductID = @ProductID;

        -- Success Message
        SELECT 'Product and all related entries deleted successfully.' AS Message;
    END TRY
    BEGIN CATCH
        -- Handle Errors
        THROW;
    END CATCH
END
GO



CREATE PROCEDURE DeleteEmployee
    @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Step 1: Check if Employee Exists
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE EmployeeID = @EmployeeID)
        BEGIN
            RAISERROR('EmployeeID not found.', 16, 1);
            RETURN;
        END

        -- Step 2: Handle Related Records in the Visit Table (if applicable)
        DELETE FROM Visit WHERE EmployeeID = @EmployeeID;

        -- Step 3: Delete from Employee Table
        DELETE FROM Employee WHERE EmployeeID = @EmployeeID;

        -- Success Message
        SELECT 'Employee deleted successfully.' AS Message;
    END TRY
    BEGIN CATCH
        -- Handle Errors
        THROW;
    END CATCH
END
GO


