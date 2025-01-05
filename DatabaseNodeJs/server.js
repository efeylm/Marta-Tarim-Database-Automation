const express = require('express');
const bodyParser = require('body-parser');
const authRoutes = require('./routes/auth'); // Auth rotası
const connectToDatabase = require('./db'); // Veritabanı bağlantısı
const sql = require('mssql'); // MSSQL modülü

const app = express();

// Middleware
app.use(bodyParser.json());
app.use(express.static('public')); // Statik dosyaları servis eder

// API Routes
app.use('/api/auth', authRoutes);


app.get('/api/inventory', async (req, res) => {
    try {
        const pool = await connectToDatabase();
        const result = await pool.request().query(`
            SELECT p.ProductID, p.ProductType, inv.Quantity, inv.StockStatus, 
                   ISNULL(t.ToolName, ISNULL(c.Category, ISNULL(pl.PlantType, 'Unknown'))) AS ProductName
            FROM Product p
            LEFT JOIN Inventory inv ON p.ProductID = inv.ProductID
            LEFT JOIN Tool t ON p.ProductID = t.ProductID
            LEFT JOIN ChemicalGood c ON p.ProductID = c.ProductID
            LEFT JOIN Plant pl ON p.ProductID = pl.ProductID
        `);
        res.json(result.recordset);
    } catch (error) {
        console.error('Error fetching inventory:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

app.get('/api/plants', async (req, res) => {
    try {
        const pool = await connectToDatabase();
        const result = await pool.request().query(`
            SELECT 
                p.PlantID, 
                p.ProductID, 
                p.PlantType, 
                s.SeedID, 
                s.SeedType, 
                sl.SeedlingID, 
                sl.SeedlingType, 
                pt.PottedID, 
                pt.PottedType
            FROM Plant p
            LEFT JOIN Seed s ON p.PlantID = s.PlantID
            LEFT JOIN Seedling sl ON p.PlantID = sl.PlantID
            LEFT JOIN Potted pt ON p.PlantID = pt.PlantID
        `);
        res.json(result.recordset);
    } catch (error) {
        console.error('Error fetching plants:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

app.get('/api/chemical-goods', async (req, res) => {
    try {
        const pool = await connectToDatabase();
        const result = await pool.request().query(`
            SELECT 
                cg.GoodID, 
                cg.ProductID, 
                cg.ExpirationDate, 
                cg.Category, 
                f.FertilizerID, 
                f.FertilizerName, 
                fg.FungicideID, 
                fg.FungicideName, 
                hb.HerbicideID, 
                hb.HerbicideName, 
                ic.InsecticideID, 
                ic.InsecticideName
            FROM ChemicalGood cg
            LEFT JOIN Fertilizer f ON cg.GoodID = f.GoodID
            LEFT JOIN Fungicide fg ON cg.GoodID = fg.GoodID
            LEFT JOIN Herbicide hb ON cg.GoodID = hb.GoodID
            LEFT JOIN Insecticide ic ON cg.GoodID = ic.GoodID
        `);
        res.json(result.recordset);
    } catch (error) {
        console.error('Error fetching chemical goods:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

app.get('/api/tools', async (req, res) => {
    try {
        const pool = await connectToDatabase();
        const result = await pool.request().query(`
            SELECT 
                t.ToolID, 
                t.ProductID, 
                t.ToolName, 
                t.ToolType, 
                t.Condition
            FROM Tool t
        `);
        res.json(result.recordset);
    } catch (error) {
        console.error('Error fetching tools:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
});


//ADD SEED
app.post('/add-seed', async (req, res) => {
    const { seedType, price, quantity, minStockLevel } = req.body;

    try {
        // Connect to SQL Server
        const pool = await connectToDatabase();

        // Execute the stored procedure
        const result = await pool.request()
            .input('SeedType', sql.VarChar(50), seedType)
            .input('Price', sql.Decimal(10, 2), price)
            .input('Quantity', sql.Int, quantity || null) // Pass NULL if not provided
            .input('MinStockLevel', sql.Int, minStockLevel || null) // Pass NULL if not provided
            .execute('AddNewSeed');

        res.send({
            message: 'Seed added successfully!',
            data: result.recordset
        });
    } catch (error) {
        console.error('Error adding seed:', error);
        res.status(500).send({ message: 'An error occurred while adding the seed.' });
    }
});

//ADDSEEDLING
app.post('/add-seedling', async (req, res) => {
    const { seedlingType, price, quantity, minStockLevel } = req.body;

    // Giriş doğrulaması
    if (!seedlingType || !price) {
        return res.status(400).json({ message: 'SeedlingType ve Price gerekli alanlardır.' });
    }

    try {
        const pool = await connectToDatabase();

        // Stored procedure'ü çalıştır
        const result = await pool.request()
            .input('SeedlingType', sql.VarChar(50), seedlingType)
            .input('Price', sql.Decimal(10, 2), price)
            .input('Quantity', sql.Int, quantity || null) // NULL değeri gönder
            .input('MinStockLevel', sql.Int, minStockLevel || null) // NULL değeri gönder
            .execute('AddNewSeedling');

        res.status(200).json({
            message: 'Seedling added successfully!',
            data: result.recordset
        });
    } catch (error) {
        console.error('Error adding seedling:', error);
        res.status(500).json({ message: 'An error occurred while adding the seedling.' });
    }
});

//ADDPOTTED
app.post('/add-potted', async (req, res) => {
    const { pottedType, price, quantity, minStockLevel } = req.body;

    // Giriş doğrulaması
    if (!pottedType || !price) {
        return res.status(400).json({ message: 'PottedType ve Price gerekli alanlardır.' });
    }

    try {
        const pool = await connectToDatabase();

        // Stored procedure'ü çalıştır
        const result = await pool.request()
            .input('PottedType', sql.VarChar(50), pottedType)
            .input('Price', sql.Decimal(10, 2), price)
            .input('Quantity', sql.Int, quantity || null) // NULL değeri gönder
            .input('MinStockLevel', sql.Int, minStockLevel || null) // NULL değeri gönder
            .execute('AddNewPotted');

        res.status(200).json({
            message: 'Potted plant added successfully!',
            data: result.recordset,
        });
    } catch (error) {
        console.error('Error adding potted plant:', error);
        res.status(500).json({ message: 'An error occurred while adding the potted plant.' });
    }
});


//ADDFERTILIZER
app.post('/add-fertilizer', async (req, res) => {
    const { fertilizerName, price, expirationDate, quantity, minStockLevel } = req.body;

    // Giriş doğrulaması
    if (!fertilizerName || !price || !expirationDate) {
        return res.status(400).json({ message: 'FertilizerName, Price ve ExpirationDate gerekli alanlardır.' });
    }

    try {
        const pool = await connectToDatabase();

        // Stored procedure'ü çalıştır
        const result = await pool.request()
            .input('FertilizerName', sql.VarChar(100), fertilizerName)
            .input('Price', sql.Decimal(10, 2), price)
            .input('ExpirationDate', sql.Date, expirationDate)
            .input('Quantity', sql.Int, quantity || null) // NULL değeri gönder
            .input('MinStockLevel', sql.Int, minStockLevel || null) // NULL değeri gönder
            .execute('AddNewFertilizer');

        res.status(200).json({
            message: 'Fertilizer added successfully!',
            data: result.recordset,
        });
    } catch (error) {
        console.error('Error adding fertilizer:', error);
        res.status(500).json({ message: 'An error occurred while adding the fertilizer.' });
    }
});

//ADD FUNGICIDE
app.post('/add-fungicide', async (req, res) => {
    const { fungicideName, price, expirationDate, quantity, minStockLevel } = req.body;

    // Giriş doğrulaması
    if (!fungicideName || !price || !expirationDate) {
        return res.status(400).json({ message: 'FungicideName, Price ve ExpirationDate gerekli alanlardır.' });
    }

    try {
        const pool = await connectToDatabase();

        // Stored procedure'ü çalıştır
        const result = await pool.request()
            .input('FungicideName', sql.VarChar(100), fungicideName)
            .input('Price', sql.Decimal(10, 2), price)
            .input('ExpirationDate', sql.Date, expirationDate)
            .input('Quantity', sql.Int, quantity || null)
            .input('MinStockLevel', sql.Int, minStockLevel || null)
            .execute('AddNewFungicide');

        res.status(200).json({
            message: 'Fungicide added successfully!',
            data: result.recordset,
        });
    } catch (error) {
        console.error('Error adding fungicide:', error);
        res.status(500).json({ message: 'An error occurred while adding the fungicide.' });
    }
});

//ADDHERBICIDE
app.post('/add-herbicide', async (req, res) => {
    const { herbicideName, price, expirationDate, quantity, minStockLevel } = req.body;

    // Giriş doğrulaması
    if (!herbicideName || !price || !expirationDate) {
        return res.status(400).json({ message: 'HerbicideName, Price ve ExpirationDate gerekli alanlardır.' });
    }

    try {
        const pool = await connectToDatabase();

        // Stored procedure'ü çalıştır
        const result = await pool.request()
            .input('HerbicideName', sql.VarChar(100), herbicideName)
            .input('Price', sql.Decimal(10, 2), price)
            .input('ExpirationDate', sql.Date, expirationDate)
            .input('Quantity', sql.Int, quantity || null)
            .input('MinStockLevel', sql.Int, minStockLevel || null)
            .execute('AddNewHerbicide');

        res.status(200).json({
            message: 'Herbicide added successfully!',
            data: result.recordset,
        });
    } catch (error) {
        console.error('Error adding herbicide:', error);
        res.status(500).json({ message: 'An error occurred while adding the herbicide.' });
    }
});

//ADDINSECTICIDE
app.post('/add-insecticide', async (req, res) => {
    const { insecticideName, price, expirationDate, quantity, minStockLevel } = req.body;

    // Giriş doğrulaması
    if (!insecticideName || !price || !expirationDate) {
        return res.status(400).json({ message: 'InsecticideName, Price ve ExpirationDate gerekli alanlardır.' });
    }

    try {
        const pool = await connectToDatabase();

        // Stored procedure'ü çalıştır
        const result = await pool.request()
            .input('InsecticideName', sql.VarChar(100), insecticideName)
            .input('Price', sql.Decimal(10, 2), price)
            .input('ExpirationDate', sql.Date, expirationDate)
            .input('Quantity', sql.Int, quantity || null)
            .input('MinStockLevel', sql.Int, minStockLevel || null)
            .execute('AddNewInsecticide');

        res.status(200).json({
            message: 'Insecticide added successfully!',
            data: result.recordset,
        });
    } catch (error) {
        console.error('Error adding insecticide:', error);
        res.status(500).json({ message: 'An error occurred while adding the insecticide.' });
    }
});

//ADDSale
app.post('/add-sale', async (req, res) => {
    const { CustomerID, ProductID, TotalAmount, PaymentStatus } = req.body;

    if (!CustomerID || !ProductID || !TotalAmount || !PaymentStatus) {
        return res.status(400).json({ message: 'All fields are required.' });
    }

    try {
        const pool = await connectToDatabase();
        const result = await pool.request()
            .input('CustomerID', sql.Int, CustomerID)
            .input('ProductID', sql.Int, ProductID)
            .input('TotalAmount', sql.Decimal(10, 2), TotalAmount)
            .input('PaymentStatus', sql.VarChar(20), PaymentStatus)
            .execute('AddNewSale');

        res.status(200).json({
            message: 'Sale added successfully!',
            saleID: result.recordset[0].SaleID,
        });
    } catch (error) {
        console.error('Error adding sale:', error);
        res.status(500).json({ message: 'An error occurred while adding the sale.' });
    }
});

app.post('/add-tool', async (req, res) => {
    const { toolName, toolType, condition, price, quantity, minStockLevel } = req.body;

    // Validate input
    if (!toolName || !toolType || !condition || !price) {
        return res.status(400).json({ message: 'Tool Name, Tool Type, Condition, and Price are required.' });
    }

    try {
        const pool = await connectToDatabase();

        const result = await pool.request()
            .input('ToolName', sql.VarChar(100), toolName)
            .input('ToolType', sql.VarChar(50), toolType)
            .input('Condition', sql.VarChar(20), condition)
            .input('Price', sql.Decimal(10, 2), price)
            .input('Quantity', sql.Int, quantity || null)
            .input('MinStockLevel', sql.Int, minStockLevel || null)
            .execute('AddNewTool');

        res.status(200).json({
            message: 'Tool added successfully!',
            productID: result.recordset[0]?.ProductID,
        });
    } catch (error) {
        console.error('Error adding tool:', error);
        res.status(500).json({ message: 'An error occurred while adding the tool.' });
    }
});

app.post('/add-customer', async (req, res) => {
    const { customerName, contactInfo, noOfSelledProduct, paidCost, debt } = req.body;

    // Validate input
    if (!customerName || !contactInfo) {
        return res.status(400).json({ message: 'CustomerName and ContactInfo are required.' });
    }

    if (debt < 0) {
        return res.status(400).json({ message: 'Debt cannot be negative.' });
    }

    try {
        const pool = await connectToDatabase();

        const result = await pool.request()
            .input('CustomerName', sql.VarChar(100), customerName)
            .input('ContactInfo', sql.VarChar(100), contactInfo)
            .input('NoOfSelledProduct', sql.Int, noOfSelledProduct)
            .input('PaidCost', sql.Decimal(10, 2), paidCost)
            .input('Debt', sql.Decimal(10, 2), debt)
            .execute('AddCustomer');

        res.status(200).json({
            message: 'Customer added successfully!',
            newCustomerID: result.recordset[0]?.NewCustomerID,
        });
    } catch (error) {
        console.error('Error adding customer:', error);
        res.status(500).json({ message: 'An error occurred while adding the customer.' });
    }
});


app.post('/add-visit', async (req, res) => {
    const { customerID, employeeID, visitLocation, visitDate } = req.body;

    // Validate input
    if (!customerID || !employeeID || !visitLocation) {
        return res.status(400).json({ message: 'CustomerID, EmployeeID, and VisitLocation are required.' });
    }

    try {
        const pool = await connectToDatabase();

        const result = await pool.request()
            .input('CustomerID', sql.Int, customerID)
            .input('EmployeeID', sql.Int, employeeID)
            .input('VisitLocation', sql.VarChar(100), visitLocation)
            .input('VisitDate', sql.Date, visitDate || null)
            .execute('AddNewVisit');

        res.status(200).json({
            message: 'Visit added successfully!',
            visitID: result.recordset[0]?.VisitID,
        });
    } catch (error) {
        console.error('Error adding visit:', error);
        res.status(500).json({ message: 'An error occurred while adding the visit.' });
    }
});

//ADD EMPLOYEE
app.post('/add-employee', async (req, res) => {
    const { firstName, lastName, role, contactInfo, password, hireDate } = req.body;

    // Validate input
    if (!firstName || !lastName || !role || !contactInfo || !password) {
        return res.status(400).json({ message: 'First Name, Last Name, Role, Contact Info, and Password are required.' });
    }

    if (!['Manager', 'Salesperson', 'Consultant', 'Worker'].includes(role)) {
        return res.status(400).json({ message: 'Invalid Role. Must be Manager, Salesperson, Consultant, or Worker.' });
    }

    try {
        const pool = await connectToDatabase();

        const result = await pool.request()
            .input('FirstName', sql.VarChar(50), firstName)
            .input('LastName', sql.VarChar(50), lastName)
            .input('Role', sql.VarChar(50), role)
            .input('ContactInfo', sql.VarChar(100), contactInfo)
            .input('Password', sql.VarChar(50), password)
            .input('HireDate', sql.Date, hireDate || null)
            .execute('AddNewEmployee');

        res.status(200).json({
            message: 'Employee added successfully!',
            employeeID: result.recordset[0]?.EmployeeID,
        });
    } catch (error) {
        console.error('Error adding employee:', error);
        res.status(500).json({ message: 'An error occurred while adding the employee.' });
    }
});







//DeleteProduct
app.post('/delete-product', async (req, res) => {
    const { productID } = req.body;

    if (!productID) {
        return res.status(400).json({ message: 'Product ID is required.' });
    }

    try {
        const pool = await connectToDatabase();

        // SQL procedure to delete product
        const result = await pool.request()
            .input('ProductID', sql.Int, productID)
            .execute('DeleteProduct'); // Stored procedure name

        res.status(200).json({
            message: 'Product and all related entries deleted successfully.',
        });
    } catch (error) {
        console.error('Error deleting product:', error);
        res.status(500).json({ message: 'An error occurred while deleting the product.' });
    }
});

app.post('/delete-employee', async (req, res) => {
    const { employeeID } = req.body;

    if (!employeeID) {
        return res.status(400).json({ message: 'Employee ID is required.' });
    }

    try {
        const pool = await connectToDatabase();

        // SQL procedure to delete employee
        const result = await pool.request()
            .input('EmployeeID', sql.Int, employeeID)
            .execute('DeleteEmployee'); // Stored procedure name

        res.status(200).json({
            message: 'Employee and related records deleted successfully.',
        });
    } catch (error) {
        console.error('Error deleting employee:', error);
        res.status(500).json({ message: 'An error occurred while deleting the employee.' });
    }
});







app.get('/get-critical-products', async (req, res) => {
    try {
        const pool = await connectToDatabase(); // Veritabanı bağlantısı

        // vw_StockAlert view'inden kritik ürünleri al
        const result = await pool.request()
            .query('SELECT * FROM vw_StockAlert');

        // Eğer veri varsa, veriyi gönder
        if (result.recordset.length > 0) {
            res.status(200).json({
                message: 'Critical products retrieved successfully',
                data: result.recordset
            });
        } else {
            res.status(404).json({ message: 'No critical products found.' });
        }
    } catch (error) {
        console.error('Error fetching critical products:', error);
        res.status(500).json({ message: 'An error occurred while retrieving critical products.' });
    }
});

app.get('/get-expired-chemical-products', async (req, res) => {
    try {
        const pool = await connectToDatabase(); // Veritabanı bağlantısı

        // vw_ExpiredChemicalProducts view'inden son kullanma tarihi geçmiş kimyasal ürünleri al
        const result = await pool.request()
            .query('SELECT * FROM vw_ExpiredChemicalProducts');

        // Eğer veri varsa, veriyi gönder
        if (result.recordset.length > 0) {
            res.status(200).json({
                message: 'Expired chemical products retrieved successfully',
                data: result.recordset
            });
        } else {
            res.status(404).json({ message: 'No expired chemical products found.' });
        }
    } catch (error) {
        console.error('Error fetching expired chemical products:', error);
        res.status(500).json({ message: 'An error occurred while retrieving expired chemical products.' });
    }
});

app.get('/get-customers-with-debt', async (req, res) => {
    try {
        const pool = await connectToDatabase(); // Veritabanı bağlantısı

        // vw_CustomersWithDebt view'inden borcu olan müşterileri al
        const result = await pool.request()
            .query('SELECT * FROM vw_CustomersWithDebt');

        // Eğer veri varsa, veriyi gönder
        if (result.recordset.length > 0) {
            res.status(200).json({
                message: 'Customers with debt retrieved successfully',
                data: result.recordset
            });
        } else {
            res.status(404).json({ message: 'No customers with debt found.' });
        }
    } catch (error) {
        console.error('Error fetching customers with debt:', error);
        res.status(500).json({ message: 'An error occurred while retrieving customers with debt.' });
    }
});

app.get('/get-customer-performance', async (req, res) => {
    try {
        const pool = await connectToDatabase(); // Veritabanı bağlantısı

        // vw_CustomerPerformance view'inden müşteri performansı verilerini al
        const result = await pool.request()
            .query('SELECT * FROM vw_CustomerPerformance');

        // Eğer veri varsa, veriyi gönder
        if (result.recordset.length > 0) {
            res.status(200).json({
                message: 'Customer performance data retrieved successfully',
                data: result.recordset
            });
        } else {
            res.status(404).json({ message: 'No customer performance data found.' });
        }
    } catch (error) {
        console.error('Error fetching customer performance:', error);
        res.status(500).json({ message: 'An error occurred while retrieving customer performance data.' });
    }
});



// Start server
const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
