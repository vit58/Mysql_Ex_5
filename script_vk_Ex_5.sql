Урок 5
-- Операторы, фильтрация, сортировка и ограничение
-- Тема Операции,

use vk;
show TABLES;

-- Таблица users
desc users;
select * from users limit 10;
select  * from users where created_at > update_at;-- Используем фильтр для поиска дат update более ранних чем дата created
update users set update_at = NOW() where created_at > update_at; -- Запрос на ОБНОВЛЕНИЕ

 задание 1
-- Пусть в таблице users поля created_at и updated_at оказались незаполненными.
-- Заполните их текущими датой и временем.
use vk;
show tables;
select * from users limit 10; 
DROP TABLE IF EXISTS users;-- Сброс, существующей таблицы
CREATE TABLE users (
 id SERIAL PRIMARY KEY,-- Столбец id SERIAL - столбец ПЕРВИЧНОГО КЛЮЧА
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY key COMMENT "Идентификатор строки" 
  -- Т.е. задаем столбец id с параметрами: Целочисленный, Не отрицательный, не Пустой, Автоматически генерирует след-ий id и является столбцом Первичного Ключа 
  name VARCHAR(255) COMMENT 'Имя покупателя', -- Имя (name) - тип VARCHAR(255) строки ПЕРЕМЕННОЙ ДЛИНЫ
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME,
  updated_at DATETIME
  -- TIME предназначен для хранения времени в течение суток ('00:00:00')
-- YEAR хранит год (0000)
-- DATE хранит дату с точностью до дня ('0000-00-00')
-- DATETIME хранит дату и время ('0000-00-00 00:00:00')
-- TIMESTAMP также хранит дату и время, занимает в два раза меньше места, чем DATETIME, но может хранить только ограниченные даты — в интервале от 1970 года до 2038 ()
-- Кроме того, первый TIMESTAMP-столбец в таблице обновляется автоматически при операциях создания и обновления. TIMESTAMP хранит дату в UTC-формате.
  ) COMMENT = 'Покупатели';

INSERT INTO
  users (name, birthday_at, created_at, updated_at)
VALUES
  ('Геннадий', '1990-10-05', NULL, NULL),
  ('Наталья', '1984-11-12', NULL, NULL),
  ('Александр', '1985-05-20', NULL, NULL),
  ('Сергей', '1988-02-14', NULL, NULL),
  ('Иван', '1998-01-12', NULL, NULL),
  ('Мария', '2006-08-29', NULL, NULL);

UPDATE
  users
SET
  created_at = NOW(), -- NOW() - Аналог команды CURRENT_TIMESTAMP
  updated_at = NOW();
  
  
-- Тема Операции, задание 2
-- Таблица users была неудачно спроектирована.
-- Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались
-- значения в формате "20.10.2017 8:10".
-- Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(255),
  updated_at VARCHAR(255)
) COMMENT = 'Покупатели';

INSERT INTO
  users (name, birthday_at, created_at, updated_at)
VALUES
  ('Геннадий', '1990-10-05', '07.01.2016 12:05', '07.01.2016 12:05'),
  ('Наталья', '1984-11-12', '20.05.2016 16:32', '20.05.2016 16:32'),
  ('Александр', '1985-05-20', '14.08.2016 20:10', '14.08.2016 20:10'),
  ('Сергей', '1988-02-14', '21.10.2016 9:14', '21.10.2016 9:14'),
  ('Иван', '1998-01-12', '15.12.2016 12:45', '15.12.2016 12:45'),
  ('Мария', '2006-08-29', '12.01.2017 8:56', '12.01.2017 8:56');

UPDATE
  users
SET
  created_at = STR_TO_DATE(created_at, '%d.%m.%Y %k:%i'),
  updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %k:%i');

ALTER TABLE
  users
CHANGE
  created_at created_at DATETIME DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE
  users
CHANGE
  updated_at updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

DESCRIBE users;


-- Тема Операции, задание 3
-- В таблице складских запасов storehouses_products в поле value могут встречаться самые
-- разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы.
-- Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения
-- значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей.
DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';


INSERT INTO
  storehouses_products (storehouse_id, product_id, value)
VALUES
  (1, 543, 0),
  (1, 789, 2500),
  (1, 3432, 0),
  (1, 826, 30),
  (1, 719, 500),
  (1, 638, 1);
 
desc storehouses_products;
SELECT * from storehouses_products;

-- Сортировака записей, чтобы они выводились в порядке увеличения значения value
select id, storehouse_id, product_id, value, created_at, updated_at
from storehouses_products
order by value;

-- Сортировака записей, чтобы они выводились в порядке увеличения значения value, но
-- НУЛЕВЫЕ значения были в конце таблицы
SELECT
  *
FROM
  storehouses_products
ORDER BY
  IF(value > 0, 0, 1),
  value;

/*
-- Более простой вариант
SELECT
  *
FROM
  storehouses_products
ORDER BY
  value = 0, value;
 */