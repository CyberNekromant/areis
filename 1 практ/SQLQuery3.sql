

USE MagazikDB;
GO

-- Проверка: сколько данных в каждой таблице?
SELECT 'stores' AS table_name, COUNT(*) AS cnt FROM stores UNION ALL
SELECT 'employees', COUNT(*) FROM employees UNION ALL
SELECT 'customers', COUNT(*) FROM customers UNION ALL
SELECT 'products', COUNT(*) FROM products UNION ALL
SELECT 'orders', COUNT(*) FROM orders UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items UNION ALL
SELECT 'returns', COUNT(*) FROM returns;
GO

-- Заказы с клиентами, магазинами и товарами
SELECT
    o.order_id,
    c.full_name AS customer,
    ISNULL(s.name, 'Интернет') AS store,
    o.status,
    CONVERT(VARCHAR, o.order_date, 120) AS order_date,
    p.name AS product,
    oi.quantity,
    oi.price,
    r.reason AS return_reason
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN stores s ON o.store_id = s.store_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
LEFT JOIN returns r ON oi.order_item_id = r.order_item_id
ORDER BY o.order_id, oi.order_item_id;
GO

