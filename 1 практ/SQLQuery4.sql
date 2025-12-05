USE MagazikDB;
GO
CREATE OR ALTER VIEW vw_ReturnsReport AS
SELECT r.return_id, r.return_date, c.full_name AS customer_name, p.name AS product_name, oi.quantity AS returned_qty, r.reason
FROM returns r
JOIN order_items oi ON r.order_item_id = oi.order_item_id
JOIN orders o ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON oi.product_id = p.product_id;
GO
CREATE OR ALTER VIEW vw_SalesReport AS
SELECT o.order_id, o.order_date, c.full_name AS customer, s.name AS store, p.name AS product, oi.quantity, oi.price, oi.quantity * oi.price AS total
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN stores s ON o.store_id = s.store_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'оплачен';
GO
SELECT * FROM vw_ReturnsReport;
SELECT * FROM vw_SalesReport;
GO