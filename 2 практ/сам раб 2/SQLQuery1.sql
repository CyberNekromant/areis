USE PharmacyDB;

SELECT 
    Category,
    COUNT(*) AS КоличествоЛекарств,
    AVG(Price) AS СредняяЦена,
    SUM(Price * Quantity) AS ОбщаяСтоимостьОстатков
FROM Prak2BD
GROUP BY Category;

SELECT TOP 1
    Category,
    SUM(Price * Quantity) AS ОбщаяСтоимость
FROM Prak2BD
GROUP BY Category
ORDER BY SUM(Price * Quantity) DESC;

SELECT 
    Category,
    SUM(Price * Quantity) AS СтоимостьОстатков,
    ROUND(SUM(Price * Quantity) * 100.0 / (SELECT SUM(Price * Quantity) FROM Prak2BD), 2) AS ДоляПроцентов
FROM Prak2BD
GROUP BY Category;

SELECT TOP 3
    MedicineName,
    Price,
    ExpirationDate
FROM Prak2BD
WHERE ExpirationDate > GETDATE()
ORDER BY Price DESC;

SELECT 
    CASE 
        WHEN Price < 100 THEN 'Дешёвые'
        WHEN Price BETWEEN 100 AND 300 THEN 'Средние'
        ELSE 'Дорогие'
    END AS ЦеноваяКатегория,
    COUNT(*) AS КоличествоЛекарств,
    SUM(Quantity) AS СуммарныйОстаток
FROM Prak2BD
GROUP BY 
    CASE 
        WHEN Price < 100 THEN 'Дешёвые'
        WHEN Price BETWEEN 100 AND 300 THEN 'Средние'
        ELSE 'Дорогие'
    END;

SELECT 
    MedicineName,
    ExpirationDate,
    DATEDIFF(DAY, GETDATE(), ExpirationDate) AS ДнейДоИстечения
FROM Prak2BD
WHERE ExpirationDate > GETDATE()
ORDER BY ДнейДоИстечения ASC;