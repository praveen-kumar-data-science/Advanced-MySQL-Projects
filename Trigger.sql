USE sloppyjoes;
SELECT * FROM staff;
SELECT * FROM customer_orders;
CREATE TRIGGER trigger_
AFTER INSERT ON customer_orders
FOR EACH ROW
		UPDATE staff
        SET orders_served = orders_served + 1
			WHERE staff.staff_id = NEW.staff_id;
INSERT INTO customer_orders VALUES
(21, 1, 10.9),
(22, 1, 9.9),
(23, 2, 8.9),
(24, 2, 8.0);
DROP TRIGGER IF EXISTS trigger_;