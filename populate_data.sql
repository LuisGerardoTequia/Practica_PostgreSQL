-- Insertar datos de ejemplo en la tabla customers
INSERT INTO customers (first_name, last_name, date_of_birth, region)
VALUES
    ('Luis', 'Tequia', '1985-02-15', 'Bogotá'),
    ('Ana', 'Lopez', '1990-06-25', 'Medellín'),
    ('Carlos', 'Martinez', '1975-11-10', 'Cali');

-- Insertar datos de ejemplo en la tabla products
INSERT INTO products (product_name, category, price)
VALUES
    ('Laptop', 'Electronics', 1200),
    ('Smartphone', 'Electronics', 800),
    ('Tablet', 'Electronics', 600);

-- Insertar datos de ejemplo en la tabla sales
INSERT INTO sales (customer_id, product_id, sales_date, quantity, total_amount)
VALUES
    (1, 1, '2024-01-15', 1, 1200),
    (2, 2, '2024-02-10', 2, 1600),
    (3, 3, '2024-03-05', 1, 600);