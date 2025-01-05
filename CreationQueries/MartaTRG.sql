CREATE TRIGGER trg_UpdateCustomerBalance
ON Sale
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF UPDATE(PaymentStatus)
    BEGIN
        -- Update customer balance when payment status changes to 'Completed'
        UPDATE c
        SET 
            PaidCost = PaidCost + i.TotalAmount,
            Debt = CASE 
                      WHEN c.Debt >= i.TotalAmount THEN c.Debt - i.TotalAmount
                      ELSE 0 -- Prevent Debt from going below zero
                  END
        FROM Customer c
        JOIN inserted i ON c.CustomerID = i.CustomerID
        JOIN deleted d ON d.SaleID = i.SaleID
        WHERE i.PaymentStatus = 'Completed'
          AND d.PaymentStatus = 'Pending';
    END;
END;
GO

CREATE TRIGGER trg_UpdateInventoryAfterSale
ON Sale
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Update inventory quantity
    UPDATE i
    SET Quantity = i.Quantity - 1
    FROM Inventory i
    JOIN inserted ins ON i.ProductID = ins.ProductID;
    
    -- Update customer statistics
    UPDATE c
    SET NoOfSelledProduct = NoOfSelledProduct + 1,
        PaidCost = PaidCost + 
            CASE 
                WHEN ins.PaymentStatus = 'Completed' THEN ins.TotalAmount
                ELSE 0
            END,
        Debt = Debt + 
            CASE 
                WHEN ins.PaymentStatus = 'Pending' THEN ins.TotalAmount
                ELSE 0
            END
    FROM Customer c
    JOIN inserted ins ON c.CustomerID = ins.CustomerID;
END;