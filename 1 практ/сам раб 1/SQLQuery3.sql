USE CoffeeGo;
GO

INSERT INTO shops (name, city, address, lat, lon, work_hours, phone)
VALUES
(N'КофеГо — Арбат', N'Москва', N'ул. Арбат, д. 10', 55.7522200, 37.6155600, N'Пн–Вс 08:00–22:00', '+7 (495) 111-22-33'),
(N'КофеГо — Невский', N'СПб', N'Невский пр., д. 35', 59.9342800, 30.3350990, N'Ежедневно 09:00–23:00', '+7 (812) 222-33-44');
SELECT * FROM shops;
GO

INSERT INTO products (name, category, size, base_price, is_available)
VALUES
(N'Латте', N'Кофе', N'0.3', 220.00, 1),
(N'Капучино', N'Кофе', N'0.3', 210.00, 1),
(N'Американо', N'Кофе', N'0.3', 180.00, 1),
(N'Зелёный чай', N'Чай', N'0.4', 150.00, 1),
(N'Круассан', N'Выпечка', N'шт', 120.00, 1),
(N'Шоколадный брауни', N'Выпечка', N'шт', 160.00, 1),
(N'Ванильный сироп', N'Сироп', N'доза', 30.00, 1);
SELECT * FROM products;
GO

INSERT INTO menus (title, start_date, end_date, description)
VALUES (N'Летнее меню 2025', '2025-06-01', '2025-08-31', N'Свежие напитки с фруктами и мятой');
SELECT * FROM menus;
GO

INSERT INTO menu_items (menu_id, product_id, promo_price)
VALUES (1, 1, 199.00), (1, 2, 189.00), (1, 4, 129.00);
SELECT * FROM menu_items;
GO

INSERT INTO customers (full_name, phone, email, city, marketing_consent)
VALUES
(N'Иванов Алексей', '+79001112233', 'ivanov@example.com', N'Москва', 1),
(N'Петрова Мария', '+79012223344', 'petrova@example.com', N'СПб', 0);
SELECT * FROM customers;
GO

INSERT INTO loyalty_accounts (customer_id, bonus_balance, level)
VALUES (1, 250, N'gold'), (2, 40, N'silver');
SELECT * FROM loyalty_accounts;
GO

INSERT INTO orders (customer_id, shop_id, order_datetime, channel, status, total_amount)
VALUES
(1, 1, '2025-04-03 10:15:00', N'онлайн', N'оплачен', 450.00),
(2, 2, '2025-04-03 14:30:00', N'касса', N'выдан', 340.00);
SELECT * FROM orders;
GO

INSERT INTO order_items (order_id, product_id, quantity, price_at_order, addons)
VALUES
(1, 1, 1, 220.00, N'ванильный сироп'),
(1, 5, 1, 120.00, NULL),
(2, 2, 1, 210.00, NULL),
(2, 6, 1, 160.00, NULL);
SELECT * FROM order_items;
GO

INSERT INTO loyalty_transactions (account_id, type, amount, reason)
VALUES
(1, N'начисление', 50, N'Заказ №1'),
(2, N'начисление', 30, N'Заказ №2');
SELECT * FROM loyalty_transactions;
GO