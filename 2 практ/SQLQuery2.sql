USE PharmacyDB;
GO
INSERT INTO Prak2BD (MedicineName, Category, Price, Quantity, ExpirationDate)
VALUES
(N'Парацетамол', N'Таблетки', 55.00, 120, '2026-01-01'),
(N'Ибупрофен', N'Таблетки', 75.50, 80, '2025-11-15'),
(N'Амоксициллин', N'Антибиотики', 230.00, 50, '2025-06-20'),
(N'АкваМарис', N'Спрей', 320.00, 40, '2026-09-10'),
(N'Називин', N'Капли', 150.00, 60, '2025-03-05'),
(N'Фенистил', N'Гель', 450.00, 30, '2026-02-20'),
(N'Мезим Форте', N'Таблетки', 210.00, 90, '2026-12-31');
GO
SELECT * FROM Prak2BD;
GO
SELECT MedicineName, Price, Quantity FROM Prak2BD WHERE Category = N'Таблетки';
GO
SELECT MedicineName, Price FROM Prak2BD WHERE Price > 200;
GO
SELECT MedicineName, Quantity FROM Prak2BD WHERE Quantity < 50;
GO
SELECT MedicineName, ExpirationDate FROM Prak2BD WHERE YEAR(ExpirationDate) = 2025;
GO
SELECT * INTO Antibiotics FROM Prak2BD WHERE Category = N'Антибиотики';
SELECT * FROM Antibiotics;
GO
SELECT MedicineID, MedicineName, Price INTO ExpensiveMedicines FROM Prak2BD WHERE Price > 200;
SELECT * FROM ExpensiveMedicines;
GO
SELECT Category, SUM(Quantity) AS TotalQuantity INTO CategorySummary FROM Prak2BD GROUP BY Category;
SELECT * FROM CategorySummary;
GO
UPDATE Prak2BD SET Price = 65.00 WHERE MedicineName = N'Парацетамол';
GO
UPDATE Prak2BD SET Price = Price * 1.10 WHERE Category = N'Таблетки';
GO
UPDATE Prak2BD SET Price = Price * 0.85 WHERE YEAR(ExpirationDate) = 2025;
GO
UPDATE Prak2BD SET Quantity = Quantity + 100 WHERE MedicineName = N'Називин';
GO
UPDATE Prak2BD SET Quantity = 0 WHERE ExpirationDate < CAST(GETDATE() AS DATE);
GO
UPDATE Prak2BD SET Category = N'Назальные средства' WHERE Category = N'Спрей';
GO
UPDATE Prak2BD SET Price = Price * 1.05 WHERE Quantity < 50;
GO
UPDATE Prak2BD SET Price = 60.00 WHERE Price < 60.00;
GO
UPDATE Prak2BD SET ExpirationDate = DATEADD(YEAR, 1, ExpirationDate) WHERE MedicineName = N'АкваМарис';
GO
UPDATE Prak2BD SET ExpirationDate = DATEADD(MONTH, 6, ExpirationDate) WHERE Category = N'Гель';
GO
SELECT Category, COUNT(*) AS Medicines FROM Prak2BD GROUP BY Category;
GO
SELECT Category, SUM(Quantity) AS Total FROM Prak2BD GROUP BY Category;
GO
SELECT Category, AVG(Price) AS AvgPrice FROM Prak2BD GROUP BY Category;
GO
SELECT Category, MIN(Price) AS Min, MAX(Price) AS Max FROM Prak2BD GROUP BY Category;
GO
SELECT 
    CASE WHEN ExpirationDate < CAST(GETDATE() AS DATE) THEN N'Просроченные' ELSE N'Годные' END AS Status,
    COUNT(*) AS Count
FROM Prak2BD
GROUP BY CASE WHEN ExpirationDate < CAST(GETDATE() AS DATE) THEN N'Просроченные' ELSE N'Годные' END;
GO
SELECT Category, SUM(Quantity) AS Total FROM Prak2BD GROUP BY Category HAVING SUM(Quantity) > 100;
GO
SELECT Category, AVG(Price) AS AvgPrice FROM Prak2BD GROUP BY Category HAVING COUNT(*) > 2;
GO