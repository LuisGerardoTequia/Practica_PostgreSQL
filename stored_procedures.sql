-- Procedimiento almacenado para insertar una nueva venta
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
    -- Calcular el total
    SELECT price * p_quantity INTO v_total_amount
    FROM products
    WHERE product_id = p_product_id;

    -- Verificar si el producto existe
    IF v_total_amount IS NULL THEN
        RAISE EXCEPTION 'Producto no encontrado con ID %', p_product_id;
    END IF;

    -- Insertar la venta
    INSERT INTO sales (customer_id, product_id, sales_date, quantity, total_amount)
    VALUES (p_customer_id, p_product_id, CURRENT_DATE, p_quantity, v_total_amount);
END;
$$;
