

USE master;
GO


IF DB_ID('MagazikDB') IS NOT NULL
BEGIN
    ALTER DATABASE MagazikDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE MagazikDB;
END
GO

-- Создаём базу
CREATE DATABASE MagazikDB;
GO

USE MagazikDB;
GO

-- 1. Магазины
CREATE TABLE stores (
    store_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    city NVARCHAR(100) NOT NULL,
    address NVARCHAR(200) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    work_hours NVARCHAR(100) NOT NULL
);
GO

-- 2. Сотрудники
CREATE TABLE employees (
    employee_id INT IDENTITY(1,1) PRIMARY KEY,
    full_name NVARCHAR(100) NOT NULL,
    position NVARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL,
    store_id INT NOT NULL,
    FOREIGN KEY (store_id) REFERENCES stores(store_id) ON DELETE CASCADE
);
GO

-- 3. Клиенты
CREATE TABLE customers (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    full_name NVARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email NVARCHAR(100) NOT NULL,
    city NVARCHAR(100) NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('обычный', 'постоянный', 'оптовый'))
);
GO

-- 4. Товары
CREATE TABLE products (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    category NVARCHAR(50) NOT NULL,
    sku VARCHAR(30) NOT NULL UNIQUE,
    unit NVARCHAR(20) NOT NULL,
    price MONEY NOT NULL CHECK (price >= 0),
    discount FLOAT NOT NULL CHECK (discount >= 0 AND discount <= 100),
    in_stock INT NOT NULL CHECK (in_stock >= 0),
    available BIT NOT NULL
);
GO

-- 5. Заказы — ВАЖНО: store_id → NULL (чтобы работало ON DELETE SET NULL)
CREATE TABLE orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('новый', 'оплачен', 'отменён')),
    store_id INT NULL,  -- ✅ NULL, а не NOT NULL
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (store_id) REFERENCES stores(store_id) ON DELETE SET NULL
);
GO

-- 6. Товары в заказе
CREATE TABLE order_items (
    order_item_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price MONEY NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE NO ACTION
);
GO

-- 7. Возвраты
CREATE TABLE returns (
    return_id INT IDENTITY(1,1) PRIMARY KEY,
    order_item_id INT NOT NULL,
    return_date DATE NOT NULL,
    reason NVARCHAR(200) NOT NULL,
    FOREIGN KEY (order_item_id) REFERENCES order_items(order_item_id) ON DELETE CASCADE
);
GO

PRINT ' База и все таблицы созданы.';