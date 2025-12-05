USE CoffeeGo;
GO

-- 1. Список всех таблиц
SELECT name AS TableName FROM sys.tables ORDER BY name;
GO

-- 2. Внешние ключи
SELECT 
    fk.name AS FK_Name,
    OBJECT_NAME(fk.parent_object_id) AS TableFrom,
    c1.name AS ColumnFrom,
    OBJECT_NAME(fk.referenced_object_id) AS TableTo,
    c2.name AS ColumnTo
FROM sys.foreign_keys fk
JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
JOIN sys.columns c1 ON fkc.parent_object_id = c1.object_id AND fkc.parent_column_id = c1.column_id
JOIN sys.columns c2 ON fkc.referenced_object_id = c2.object_id AND fkc.referenced_column_id = c2.column_id
ORDER BY TableFrom;
GO

-- 3. Нарушения ссылочной целостности (должно быть 0)
SELECT 'Нарушения FK: Orders → Shops' AS CheckName, COUNT(*) AS BrokenLinks
FROM orders o
LEFT JOIN shops s ON o.shop_id = s.shop_id
WHERE s.shop_id IS NULL;
GO

SELECT 'Нарушения FK: Orders → Customers' AS CheckName, COUNT(*) AS BrokenLinks
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
GO

-- 4. Все заказы с полной информацией
SELECT 
    o.order_id,
    c.full_name AS Customer,
    s.name AS Shop,
    p.name AS Product,
    oi.quantity,
    oi.price_at_order AS Price,
    oi.quantity * oi.price_at_order AS Total
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN shops s ON o.shop_id = s.shop_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_datetime DESC;
GO

-- 5. Балансы лояльности
SELECT 
    c.full_name,
    la.bonus_balance,
    la.level,
    COUNT(lt.transaction_id) AS Transactions
FROM loyalty_accounts la
JOIN customers c ON la.customer_id = c.customer_id
LEFT JOIN loyalty_transactions lt ON la.account_id = lt.account_id
GROUP BY c.full_name, la.bonus_balance, la.level;
GO

-- 6. Активные товары в текущем меню
SELECT * FROM vw_SeasonalMenu;
GO

-- 7. Общая выручка за сегодня
SELECT 
    ISNULL(SUM(o.total_amount), 0) AS TodayRevenue
FROM orders o
WHERE CAST(o.order_datetime AS DATE) = CAST(GETDATE() AS DATE)
  AND o.status IN (N'оплачен', N'выдан');
GO

-- 8. Статус заказов
SELECT status, COUNT(*) AS Count FROM orders GROUP BY status;
GO

-- 9. Самый дорогой заказ
SELECT TOP 1 order_id, total_amount, customer_id FROM orders ORDER BY total_amount DESC;
GO

-- 10. ER-диаграмма: таблицы и связи 
PRINT 'Чтобы построить ER-диаграмму:';
PRINT '1. В Object Explorer → CoffeeGo → Database Diagrams';
PRINT '2. New Database Diagram → выбрать все 10 таблиц → Add → Close';
PRINT '3. Расположить: customers → orders → order_items → products';
PRINT '   shops → orders, employees';
PRINT '   menus ↔ menu_items';
PRINT '   customers → loyalty_accounts → loyalty_transactions';
GO