
select * from "728d6361"

-- Заполнение name по phone
UPDATE "728d6361" AS main
SET "name" = sub."name"
FROM (
  SELECT DISTINCT phone, "name"
  FROM "728d6361"
  WHERE phone IS NOT NULL AND "name" IS NOT NULL
) AS sub
WHERE main.phone = sub.phone;

-- Заполнение phone по name
UPDATE "728d6361" AS main
SET phone = sub.phone
FROM (
  SELECT DISTINCT phone, "name"
  FROM "728d6361"
  WHERE phone IS NOT NULL AND "name" IS NOT NULL
) AS sub
WHERE main."name" = sub."name";

-- Заполнение email по name
UPDATE "728d6361" AS main
SET email = sub.email
FROM (
  SELECT DISTINCT email, "name"
  FROM "728d6361"
  WHERE email IS NOT NULL AND "name" IS NOT NULL
) AS sub
WHERE main."name" = sub."name";


-- Заполнение password по name, email и phone
UPDATE "728d6361" AS main
SET "password" = sub."password"
FROM (
  SELECT DISTINCT "password", phone, email, "name"
  FROM "728d6361"
  WHERE "password" IS NOT NULL AND phone IS NOT NULL AND email IS NOT NULL AND "name" IS NOT NULL
) AS sub
WHERE main."name" = sub."name" AND main.email = sub.email AND main.phone = sub.phone;

-- Проверяем что получилось и видим, что у нас получились дублирующиеся данные, очистим их позже
SELECT "name", phone, email, "password"
FROM "728d6361";

-- Заполнение car по vin
UPDATE "728d6361" AS main
SET car = sub.car
FROM (
  SELECT DISTINCT car, vin
  FROM "728d6361"
  WHERE car IS NOT NULL AND vin IS NOT NULL
) AS sub
WHERE main.vin = sub.vin;

-- Заполнение car_number по car и vin
UPDATE "728d6361" AS main
SET car_number = sub.car_number
FROM (
  SELECT DISTINCT car_number, car, vin
  FROM "728d6361"
  WHERE car IS NOT NULL AND vin IS NOT NULL AND car_number IS NOT NULL
) AS sub
WHERE main.vin = sub.vin AND main.car = sub.car;

-- Заполнение vin по car и car_number
UPDATE "728d6361" AS main
SET vin = sub.vin
FROM (
  SELECT DISTINCT car_number, car, vin
  FROM "728d6361"
  WHERE car IS NOT NULL AND vin IS NOT NULL AND car_number IS NOT NULL
) AS sub
WHERE main.car_number = sub.car_number AND main.car = sub.car;

-- Заполнение color по vin
UPDATE "728d6361" AS main
SET color = sub.color
FROM (
  SELECT DISTINCT color, vin
  FROM "728d6361"
  WHERE color IS NOT NULL AND vin IS NOT NULL
) AS sub
WHERE main.vin = sub.vin;

-- проверим что у нас получилось
SELECT car, car_number, vin, color
FROM "728d6361";

-- Заполнение w_name по w_phone
UPDATE "728d6361" AS main
SET w_name = sub.w_name
FROM (
  SELECT DISTINCT w_name, w_phone
  FROM "728d6361"
  WHERE w_name IS NOT NULL AND w_phone IS NOT NULL
) AS sub
WHERE main.w_phone = sub.w_phone;

-- Заполнение w_phone по w_name
UPDATE "728d6361" AS main
SET w_phone = sub.w_phone
FROM (
  SELECT DISTINCT w_name, w_phone
  FROM "728d6361"
  WHERE w_name IS NOT NULL AND w_phone IS NOT NULL
) AS sub
WHERE main.w_name = sub.w_name;

-- Заполнение w_exp по w_name
UPDATE "728d6361" AS main
SET w_exp = sub.w_exp
FROM (
  SELECT DISTINCT w_name, w_exp
  FROM "728d6361"
  WHERE w_exp IS NOT NULL AND w_name IS NOT NULL
) AS sub
WHERE main.w_name = sub.w_name;

-- Заполнение wages по w_name
UPDATE "728d6361" AS main
SET wages = sub.wages
FROM (
  SELECT DISTINCT w_name, wages
  FROM "728d6361"
  WHERE wages IS NOT NULL AND w_name IS NOT NULL
) AS sub
WHERE main.w_name = sub.w_name;

-- Заполнение service_addr по w_name
UPDATE "728d6361" AS main
SET service_addr = sub.service_addr
FROM (
  SELECT DISTINCT w_name, service_addr
  FROM "728d6361"
  WHERE w_name IS NOT NULL AND service_addr IS NOT NULL
) AS sub
WHERE main.w_name = sub.w_name;

-- Заполнение service по service_addr
UPDATE "728d6361" AS main
SET service = sub.service
FROM (
  SELECT DISTINCT service, service_addr
  FROM "728d6361"
  WHERE service IS NOT NULL AND service_addr IS NOT NULL
) AS sub
WHERE main.service_addr = sub.service_addr;

-- Восстановление pin по дате, payment и card
UPDATE "728d6361" AS main
SET pin = sub.pin
FROM (
  SELECT date, payment, card, MAX(pin) AS pin
  FROM "728d6361"
  WHERE pin IS NOT NULL
  GROUP BY date, payment, card
) AS sub
WHERE main.date = sub.date AND main.payment = sub.payment AND main.card = sub.card AND main.pin IS NULL;

-- Восстановление card по дате, payment и pin
UPDATE "728d6361" AS main
SET card = sub.card
FROM (
  SELECT date, payment, pin, MAX(card) AS card
  FROM "728d6361"
  WHERE card IS NOT NULL
  GROUP BY date, payment, pin
) AS sub
WHERE main.date = sub.date AND main.payment = sub.payment AND main.pin = sub.pin AND main.card IS NULL;

-- Восстановление payment по дате, card и pin
UPDATE "728d6361" AS main
SET payment = sub.payment
FROM (
  SELECT date, card, pin, MAX(payment) AS payment
  FROM "728d6361"
  WHERE payment IS NOT NULL
  GROUP BY date, card, pin
) AS sub
WHERE main.date = sub.date AND main.card = sub.card AND main.pin = sub.pin AND main.payment IS NULL;

-- Проверка на наличие данных, которые можно использовать для восстановления
SELECT date, payment, card, pin
FROM "728d6361"
GROUP BY date, payment, card, pin
HAVING COUNT(*) > 1;

select * from "728d6361"

-- Не совсем понял как восстановить данные по картам, размерам оплаты и пину, потому что уникальные данные для каждого случая
-- Думал, что у нас в определенную дату может быть заполнена карта и размер оплаты, а пина нет, и похожие данные, но такого нет



