USE CoffeeGo;
GO

CREATE OR ALTER VIEW vw_DailySales AS
SELECT
    CAST(o.order_datetime AS DATE) AS order_date,
    s.name AS shop_name,
    COUNT(o.order_id) AS orders_count,
    SUM(o.total_amount) AS total_revenue
FROM orders o
JOIN shops s ON o.shop_id = s.shop_id
WHERE o.status IN (N'оплачен', N'выдан')
GROUP BY CAST(o.order_datetime AS DATE), s.name;
GO

CREATE OR ALTER VIEW vw_LoyalCustomers AS
SELECT
    c.full_name,
    c.phone,
    la.bonus_balance,
    la.level,
    COUNT(o.order_id) AS orders_last_30d
FROM loyalty_accounts la
JOIN customers c ON la.customer_id = c.customer_id
LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.order_datetime >= DATEADD(DAY, -30, GETDATE())
GROUP BY c.full_name, c.phone, la.bonus_balance, la.level;
GO

CREATE OR ALTER VIEW vw_SeasonalMenu AS
SELECT
    m.title,
    m.start_date,
    m.end_date,
    p.name AS product_name,
    p.base_price,
    mi.promo_price,
    CASE WHEN mi.promo_price IS NOT NULL THEN p.base_price - mi.promo_price ELSE 0 END AS discount
FROM menus m
JOIN menu_items mi ON m.menu_id = mi.menu_id
JOIN products p ON mi.product_id = p.product_id
WHERE m.start_date <= GETDATE() AND m.end_date >= GETDATE();
GO

-- Проверка: показать данные из представлений
SELECT 'vw_DailySales' AS [View], * FROM vw_DailySales;
SELECT 'vw_LoyalCustomers' AS [View], * FROM vw_LoyalCustomers;
SELECT 'vw_SeasonalMenu' AS [View], * FROM vw_SeasonalMenu;
GO