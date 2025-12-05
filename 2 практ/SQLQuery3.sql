USE PharmacyDB;
GO

-- 1. Анализ категорий
SELECT 
    Category,
    COUNT(*) AS MedicinesCount,
    AVG(Price) AS AvgPrice,
    SUM(Price * Quantity) AS TotalStockValue
FROM Prak2BD
GROUP BY Category;
GO

-- 2. Категория-лидер по общей стоимости
SELECT TOP 1 
    Category,
    SUM(Price * Quantity) AS TotalStockValue
FROM Prak2BD
GROUP BY Category
ORDER BY TotalStockValue DESC;
GO

-- 3. Доля каждой категории в общей стоимости
SELECT 
    Category,
    SUM(Price * Quantity) AS CategoryValue,
    CAST(SUM(Price * Quantity) * 100.0 / (SELECT SUM(Price * Quantity) FROM Prak2BD) AS DECIMAL(5,2)) AS PercentShare
FROM Prak2BD
GROUP BY Category;
GO

-- 4. Три самых дорогих лекарства (ещё не просрочены)
SELECT TOP 3 
    MedicineName, Price, ExpirationDate
FROM Prak2BD
WHERE ExpirationDate >= CAST(GETDATE() AS DATE)
ORDER BY Price DESC;
GO

-- 5. Распределение по ценовым группам
SELECT 
    PriceGroup,
    COUNT(*) AS MedicinesCount,
    SUM(Quantity) AS TotalQuantity
FROM (
    SELECT *,
        CASE
            WHEN Price < 100 THEN N'Дешёвые'
            WHEN Price BETWEEN 100 AND 300 THEN N'Средние'
            ELSE N'Дорогие'
        END AS PriceGroup
    FROM Prak2BD
) t
GROUP BY PriceGroup;
GO

-- 6. Дни до истечения срока (с сортировкой)
SELECT 
    MedicineName,
    ExpirationDate,
    DATEDIFF(DAY, GETDATE(), ExpirationDate) AS DaysLeft
FROM Prak2BD
ORDER BY DaysLeft ASC;
GO