-- Crear la base de datos (opcional, solo si no la has creado)
CREATE DATABASE sales_db;

-- Conectarse a la base de datos
\c sales_db;

-- Crear tablas
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(59) NOT NULL,
    last_name VARCHAR(67) NOT NULL,
    date_of_birth DATE,
    region VARCHAR(30)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(11, 2) NOT NULL
);

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products(product_id) ON DELETE CASCADE,
    sales_date DATE NOT NULL DEFAULT CURRENT_DATE,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    total_amount DECIMAL(12, 2) NOT NULL
);

-- Crear índice
CREATE INDEX idx_customer_region ON customers(region);
