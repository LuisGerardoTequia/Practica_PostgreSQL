---CODIGO SQL DE POSTGRESQL :)

-- Crear Tablas de la base de datos :)
CREATE TABLE customers (
	customer_id SERIAL PRIMARY KEY,
	first_name VARCHAR(59) NOT NULL,
	last_name VARCHAR(67) NOT NULL,
	date_of_birth DATE,
	region VARCHAR(30)
);

CREATE TABLE products(
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
	quantity INTEGER NOT NULL CHECK (quantity >0),
	total_amount DECIMAL (12, 2) NOT NULL
);


-- Crear un indice
CREATE INDEX idx_customer_region ON customers(region);

-- Insertar datos
INSERT INTO customers (first_name,last_name,date_of_birth,region) VALUES ('Luis', 'Tequia', '1985-02-15', 'Bogotá'),
('Ana', 'Lopez', '1990-06-25', 'Medellín'),
('Carlos', 'Martinez', '1975-11-10', 'Cali');

INSERT INTO products (product_name,category,price) VALUES ('Laptop', 'Electronics', 1200),
('Smartphone', 'Electronics', 800),
('Tablet', 'Electronics', 600);

INSERT INTO sales (customer_id,product_id,sales_date,quantity,total_amount) VALUES (1, 1, '2024-01-15', 1, 1200),
(2, 2, '2024-02-10', 2, 1600),
(3, 3, '2024-03-05', 1, 600);


--Crear Vista materializada "analisis de ventas por region"
CREATE MATERIALIZED VIEW mv_sales_summary AS
SELECT c.region, COUNT (s.sale_id) AS total_sales, SUM (s.total_amount) AS total_revenue
FROM sales AS s
JOIN customers AS c ON s.customer_id =c.customer_id
GROUP BY c.region;

-- Refrescar la vistra materializada
REFRESH MATERIALIZED VIEW mv_sales_summary;

-- Generación de un CTE para obtener ventas de alto valor
WITH high_value_sales AS(
	SELECT sale_id, total_amount
	FROM sales
	WHERE total_amount >1000
)

SELECT * FROM high_value_sales;

-- Procedimiento Almacenado "Inserta una nueva venta"

CREATE OR REPLACE PROCEDURE insert_sale(
	p_customer_id INTEGER,
	p_product_id INTEGER,
	p_quantity INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE 
 v_total_amount DECIMAL;
BEGIN

BEGIN
SELECT price* p_quantity INTO v_total_amount
FROM products
WHERE product_id = p_product_id;

IF v_total_amount IS NULL THEN
RAISE EXCEPTION 'Producto no encontrado con ID %', p_product_id;
END IF;

--- Inserta la venta
INSERT INTO sales (customer_id,product_id,sales_date,quantity,total_amount) 
	VALUES (p_customer_id,p_product_id,CURRENT_DATE,p_quantity,v_total_amount);

EXCEPTION 
WHEN OTHERS THEN
RAISE NOTICE 'Ocurrio un error desconocido : %', SQLERRM;

END;

END;

$$;

-- Crear un trigger "Actualizar la vista materializada"
CREATE OR REPLACE FUNCTION update_sales_summary()
RETURNS TRIGGER AS $$
BEGIN
REFRESH MATERIALIZED VIEW mv_sales_summary;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_sales_summary
AFTER INSERT ON sales
FOR EACH ROW
EXECUTE FUNCTION update_sales_summary();

-- Analisis Avanzado
SELECT c.region,
COUNT (c.customer_id) AS total_custumers,
SUM (s.total_amount) AS total_revenue,
CASE
WHEN SUM(s.total_amount)> 2000 THEN 'High Revenue'
ELSE 'Low Revenue'
END AS revenue_category
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.region
HAVING SUM(s.total_amount) >500;

-- Espero que puedas aplicar más funciones o variables que consideres pertinente :)
