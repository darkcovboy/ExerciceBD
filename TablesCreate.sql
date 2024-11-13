create table "728d6361" (
date date
,service text
,service_addr text
,w_name text
,w_exp text
,w_phone text
,wages text
,card text
,payment text
,pin text
,name text
,phone text
,email text
,password text
,car text
,mileage text
,vin text
,car_number text
,color text)

select * from "728d6361"


--в скрипте Fill уже объединил данные какие мог
-- создадим нужные сущности и заполним данными, включая создания ключей 
CREATE TABLE clients (
    client_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(100),
    password VARCHAR(50)
);


CREATE TABLE cars (
    car_id SERIAL PRIMARY KEY,
    client_id INT REFERENCES clients(client_id),
    car VARCHAR(100),
    vin VARCHAR(50) UNIQUE,
    car_number VARCHAR(20),
    color VARCHAR(20)
);

CREATE TABLE services (
    service_id SERIAL PRIMARY KEY,
    service VARCHAR(100),
    service_addr VARCHAR(255)
);


CREATE TABLE workers (
    worker_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    w_exp INT,
    w_phone VARCHAR(20),
    wages INT,
    service_id INT REFERENCES services(service_id)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    client_id INT REFERENCES clients(client_id),
    car_id INT REFERENCES cars(car_id),
    service_id INT REFERENCES services(service_id),
    mileage INT,
    date DATE,
    card VARCHAR(20),
    payment DECIMAL(10, 2),
    pin CHAR(4)
);

--заполнение и вывод
INSERT INTO clients (first_name, last_name, phone, email, password)
SELECT DISTINCT split_part(name, ' ', 1), split_part(name, ' ', 2), phone, email, password
FROM "728d6361"
WHERE name IS NOT NULL;

select * from clients c 

INSERT INTO cars (client_id, car, vin, car_number, color)
SELECT DISTINCT c.client_id, t.car, t.vin, t.car_number, t.color
FROM "728d6361" t
JOIN clients c ON t.name = c.first_name || ' ' || c.last_name AND t.phone = c.phone
WHERE t.vin IS NOT NULL;

select * from cars c 

INSERT INTO services (service, service_addr)
SELECT DISTINCT service, service_addr
FROM "728d6361"
WHERE service IS NOT NULL;

select * from services s 

INSERT INTO workers (first_name, last_name, w_exp, w_phone, wages, service_id)
SELECT DISTINCT 
    split_part(t.w_name, ' ', 1), 
    split_part(t.w_name, ' ', 2), 
    t.w_exp::INTEGER, -- Преобразование данных в INTEGER
    t.w_phone, 
    t.wages::INTEGER, -- Преобразование данных в INTEGER
    s.service_id
FROM "728d6361" t
JOIN services s ON t.service = s.service AND t.service_addr = s.service_addr
WHERE t.w_name IS NOT NULL;

select * from workers w 

INSERT INTO orders (client_id, car_id, service_id, mileage, date, card, payment, pin)
SELECT DISTINCT 
    c.client_id, 
    car.car_id, 
    s.service_id, 
    t.mileage::INTEGER, -- Преобразование данных в INTEGER
    DATE(t.date), 
    t.card, 
    t.payment::DECIMAL(10, 2), -- Преобразование данных в DECIMAL
    t.pin
FROM "728d6361" t
JOIN clients c ON t.name = c.first_name || ' ' || c.last_name AND t.phone = c.phone
JOIN cars car ON t.vin = car.vin
JOIN services s ON t.service = s.service AND t.service_addr = s.service_addr
WHERE t.mileage IS NOT NULL AND t.date IS NOT NULL;

select * from orders o 


--очистим повторяющиеся данные
WITH duplicates AS (
    SELECT 
        order_id,
        ROW_NUMBER() OVER (PARTITION BY client_id, car_id, service_id, date, payment ORDER BY order_id) AS rn
    FROM orders
)
DELETE FROM orders
WHERE order_id IN (
    SELECT order_id
    FROM duplicates
    WHERE rn > 1
);































