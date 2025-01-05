CREATE VIEW vw_CustomerPerformance AS
SELECT 
    c.CustomerID,
    c.CustomerName,
    c.NoOfSelledProduct,
    c.PaidCost,
    c.Debt,
    c.TotalBalance,
    COUNT(s.SaleID) AS TotalTransactions,
    AVG(s.TotalAmount) AS AverageTransactionValue,
    MAX(s.SaleDate) AS LastPurchaseDate,
    SUM(CASE WHEN s.PaymentStatus = 'Pending' THEN 1 ELSE 0 END) AS PendingPayments
FROM Customer c
LEFT JOIN Sale s ON c.CustomerID = s.CustomerID
GROUP BY 
    c.CustomerID, 
    c.CustomerName,
    c.NoOfSelledProduct,
    c.PaidCost,
    c.Debt,
    c.TotalBalance;


CREATE VIEW vw_CustomersWithDebt AS
SELECT 
    CustomerID,
    CustomerName,
    ContactInfo,
    PaidCost,
    Debt,
    TotalBalance AS Balance
FROM Customer
WHERE Debt > 0;
GO


CREATE VIEW vw_ExpiredChemicalProducts AS
SELECT 
    CG.GoodID,
    P.ProductID,
    P.Price,
    P.ProductType,
    CG.ExpirationDate,
    CG.Category
FROM ChemicalGood CG
INNER JOIN Product P ON CG.ProductID = P.ProductID
WHERE CG.ExpirationDate < GETDATE();
GO


CREATE VIEW vw_StockAlert AS
SELECT 
    i.ProductID,
    p.ProductType,
    i.Quantity,
    i.MinStockLevel,
    i.StockStatus,
    CASE p.ProductType
        WHEN 'Plant' THEN pl.PlantType
        WHEN 'Chemical' THEN cg.Category
        WHEN 'Tool' THEN t.ToolName
    END AS ProductSpecification,
    p.Price,
    CASE 
        WHEN p.ProductType = 'Chemical' THEN cg.ExpirationDate
        ELSE NULL
    END AS ExpirationDate
FROM Inventory i
JOIN Product p ON i.ProductID = p.ProductID
LEFT JOIN Plant pl ON p.ProductID = pl.ProductID
LEFT JOIN ChemicalGood cg ON p.ProductID = cg.ProductID
LEFT JOIN Tool t ON p.ProductID = t.ProductID
WHERE i.StockStatus = 'Low'
OR (p.ProductType = 'Chemical' AND cg.ExpirationDate <= DATEADD(month, 3, GETDATE()));