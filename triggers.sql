-- Función para actualizar la vista materializada después de una inserción en ventas
CREATE OR REPLACE FUNCTION update_sales_summary()
RETURNS TRIGGER AS $$
BEGIN
    REFRESH MATERIALIZED VIEW mv_sales_summary;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger
CREATE TRIGGER trg_update_sales_summary
AFTER INSERT ON sales
FOR EACH ROW
EXECUTE FUNCTION update_sales_summary();