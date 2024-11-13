SELECT 
    o.client_id,
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS total_visits
FROM orders o
JOIN clients c ON o.client_id = c.client_id
GROUP BY o.client_id, c.first_name, c.last_name
ORDER BY total_visits DESC;

CREATE TABLE discounts (
    discount_id SERIAL PRIMARY KEY,
    client_id INT REFERENCES clients(client_id),
    discount_percentage DECIMAL(5, 2)
);

-- Заполнение таблицы скидок на основе количества обращений
INSERT INTO discounts (client_id, discount_percentage)
SELECT 
    o.client_id,
    CASE 
        WHEN COUNT(o.order_id) > 175 THEN 15.00
        WHEN COUNT(o.order_id) > 150 THEN 10.00
        ELSE NULL
    END AS discount_percentage
FROM orders o
GROUP BY o.client_id
HAVING COUNT(o.order_id) > 150; -- Учитываем только клиентов с количеством обращений более 150

select * from discounts

-- задание 2
SELECT 
    w.worker_id,
    w.first_name,
    w.last_name,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN services s ON o.service_id = s.service_id
JOIN workers w ON s.service_id = w.service_id
GROUP BY w.worker_id, w.first_name, w.last_name
ORDER BY total_orders desc

UPDATE workers
SET wages = wages * 1.10
WHERE worker_id IN (
    SELECT w.worker_id
    FROM orders o
    JOIN services s ON o.service_id = s.service_id
    JOIN workers w ON s.service_id = w.service_id
    GROUP BY w.worker_id
    ORDER BY COUNT(o.order_id) DESC
    LIMIT 3
);
--вообще у нас аж 5 работник с одинаковым количеством заказов, я посмотрел по id клиентов в orders и они все отличаются, поэтому не знаю должно ли быть так или нет

--задание 3
CREATE VIEW director_report AS
SELECT 
    s.service_addr AS branch,
    COUNT(o.order_id) AS total_orders_last_month,
    SUM(o.payment) AS total_earnings,
    SUM(o.payment) - SUM(w.wages) AS earnings_after_wages
FROM orders o
JOIN services s ON o.service_id = s.service_id
JOIN workers w ON s.service_id = w.service_id
WHERE o.date >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 month'
GROUP BY s.service_addr;

SELECT * FROM director_report;
-- вообще правильно, у нас нет заказов, поэтому сделаюю за сентябрь 2024
DROP VIEW IF EXISTS director_report;

CREATE VIEW director_report AS
SELECT 
    s.service_addr AS branch,
    COUNT(o.order_id) AS total_orders_september,
    SUM(o.payment) AS total_earnings,
    SUM(o.payment) - SUM(w.wages) AS earnings_after_wages
FROM orders o
JOIN services s ON o.service_id = s.service_id
JOIN workers w ON s.service_id = w.service_id
WHERE o.date >= '2024-09-01' AND o.date <= '2024-09-30'
GROUP BY s.service_addr;

select * from director_report

--задание 4
-- Топ-10 самых ненадежных автомобилей
SELECT 
    car.car AS car_model,
    COUNT(o.order_id) AS visit_count
FROM orders o
JOIN cars car ON o.car_id = car.car_id
GROUP BY car.car
ORDER BY visit_count DESC
LIMIT 10;

-- Топ-10 самых надежных автомобилей
SELECT 
    car.car AS car_model,
    COUNT(o.order_id) AS visit_count
FROM orders o
JOIN cars car ON o.car_id = car.car_id
GROUP BY car.car
ORDER BY visit_count ASC
LIMIT 10;

--5 задание
SELECT DISTINCT ON (car.car) 
    car.car AS car_model,
    car.color,
    COUNT(o.order_id) AS visit_count
FROM orders o
JOIN cars car ON o.car_id = car.car_id
GROUP BY car.car, car.color
ORDER BY car.car, visit_count ASC;







