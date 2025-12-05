USE CoffeeGo;
GO

DROP TABLE IF EXISTS loyalty_transactions;
DROP TABLE IF EXISTS loyalty_accounts;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS menu_items;
DROP TABLE IF EXISTS menus;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS shops;
DROP TABLE IF EXISTS customers;
GO

-- 1. shops
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'shops')
CREATE TABLE shops (
    shop_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    city NVARCHAR(100) NOT NULL,
    address NVARCHAR(200) NOT NULL,
    lat DECIMAL(9,6) NOT NULL,
    lon DECIMAL(9,6) NOT NULL,
    work_hours NVARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL
);
GO

-- 2. employees
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'employees')
CREATE TABLE employees (
    employee_id INT IDENTITY(1,1) PRIMARY KEY,
    full_name NVARCHAR(100) NOT NULL,
    position NVARCHAR(50) NOT NULL CHECK (position IN (N'Бариста', N'Менеджер', N'Кассир')),
    hire_date DATE NOT NULL,
    shop_id INT NOT NULL,
    is_active BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_employees_shops FOREIGN KEY (shop_id) REFERENCES shops(shop_id) ON DELETE CASCADE
);
GO

-- 3. products
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'products')
CREATE TABLE products (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    category NVARCHAR(50) NOT NULL CHECK (category IN (N'Кофе', N'Чай', N'Выпечка', N'Сироп', N'Молоко')),
    size NVARCHAR(20) NOT NULL,
    base_price DECIMAL(10,2) NOT NULL CHECK (base_price >= 0),
    is_available BIT NOT NULL DEFAULT 1
);
GO

-- 4. menus
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'menus')
CREATE TABLE menus (
    menu_id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    description NVARCHAR(500)
);
GO

-- 5. menu_items
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'menu_items')
CREATE TABLE menu_items (
    menu_item_id INT IDENTITY(1,1) PRIMARY KEY,
    menu_id INT NOT NULL,
    product_id INT NOT NULL,
    promo_price DECIMAL(10,2) NULL CHECK (promo_price >= 0),
    CONSTRAINT FK_menu_items_menus FOREIGN KEY (menu_id) REFERENCES menus(menu_id) ON DELETE CASCADE,
    CONSTRAINT FK_menu_items_products FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    CONSTRAINT UQ_menu_product UNIQUE (menu_id, product_id)
);
GO

-- 6. customers
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'customers')
CREATE TABLE customers (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    full_name NVARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    email NVARCHAR(100) NOT NULL UNIQUE,
    city NVARCHAR(100),
    marketing_consent BIT NOT NULL DEFAULT 0,
    reg_date DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- 7. orders
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'orders')
CREATE TABLE orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    shop_id INT NOT NULL,
    order_datetime DATETIME NOT NULL DEFAULT GETDATE(),
    channel NVARCHAR(20) NOT NULL CHECK (channel IN (N'онлайн', N'касса')),
    status NVARCHAR(20) NOT NULL CHECK (status IN (N'новый', N'оплачен', N'отменён', N'выдан')),
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    CONSTRAINT FK_orders_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    CONSTRAINT FK_orders_shops FOREIGN KEY (shop_id) REFERENCES shops(shop_id) ON DELETE NO ACTION
);
GO

-- 8. order_items
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'order_items')
CREATE TABLE order_items (
    order_item_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price_at_order DECIMAL(10,2) NOT NULL CHECK (price_at_order >= 0),
    addons NVARCHAR(200),
    CONSTRAINT FK_order_items_orders FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    CONSTRAINT FK_order_items_products FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE NO ACTION
);
GO

-- 9. loyalty_accounts
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'loyalty_accounts')
CREATE TABLE loyalty_accounts (
    account_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL UNIQUE,
    bonus_balance INT NOT NULL CHECK (bonus_balance >= 0) DEFAULT 0,
    level NVARCHAR(20) NOT NULL CHECK (level IN (N'silver', N'gold', N'platinum')) DEFAULT N'silver',
    last_activity_date DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_loyalty_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);
GO

-- 10. loyalty_transactions
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'loyalty_transactions')
CREATE TABLE loyalty_transactions (
    transaction_id INT IDENTITY(1,1) PRIMARY KEY,
    account_id INT NOT NULL,
    transaction_date DATETIME NOT NULL DEFAULT GETDATE(),
    type NVARCHAR(20) NOT NULL CHECK (type IN (N'начисление', N'списание')),
    amount INT NOT NULL CHECK (amount > 0),
    reason NVARCHAR(100) NOT NULL,
    CONSTRAINT FK_transactions_accounts FOREIGN KEY (account_id) REFERENCES loyalty_accounts(account_id) ON DELETE CASCADE
);
GO

-- Проверка: сколько таблиц создано?
SELECT COUNT(*) AS TablesCreated, 'Ожидаемо: 10' AS Note
FROM sys.tables
WHERE name IN (
    'shops','employees','products','menus','menu_items',
    'customers','orders','order_items','loyalty_accounts','loyalty_transactions'
);
GO