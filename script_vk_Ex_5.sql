���� 5
-- ���������, ����������, ���������� � �����������
-- ���� ��������,

use vk;
show TABLES;

-- ������� users
desc users;
select * from users limit 10;
select  * from users where created_at > update_at;-- ���������� ������ ��� ������ ��� update ����� ������ ��� ���� created
update users set update_at = NOW() where created_at > update_at; -- ������ �� ����������

 ������� 1
-- ����� � ������� users ���� created_at � updated_at ��������� ��������������.
-- ��������� �� �������� ����� � ��������.
use vk;
show tables;
select * from users limit 10; 
DROP TABLE IF EXISTS users;-- �����, ������������ �������
CREATE TABLE users (
 id SERIAL PRIMARY KEY,-- ������� id SERIAL - ������� ���������� �����
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY key COMMENT "������������� ������" 
  -- �.�. ������ ������� id � �����������: �������������, �� �������������, �� ������, ������������� ���������� ����-�� id � �������� �������� ���������� ����� 
  name VARCHAR(255) COMMENT '��� ����������', -- ��� (name) - ��� VARCHAR(255) ������ ���������� �����
  birthday_at DATE COMMENT '���� ��������',
  created_at DATETIME,
  updated_at DATETIME
  -- TIME ������������ ��� �������� ������� � ������� ����� ('00:00:00')
-- YEAR ������ ��� (0000)
-- DATE ������ ���� � ��������� �� ��� ('0000-00-00')
-- DATETIME ������ ���� � ����� ('0000-00-00 00:00:00')
-- TIMESTAMP ����� ������ ���� � �����, �������� � ��� ���� ������ �����, ��� DATETIME, �� ����� ������� ������ ������������ ���� � � ��������� �� 1970 ���� �� 2038 ()
-- ����� ����, ������ TIMESTAMP-������� � ������� ����������� ������������� ��� ��������� �������� � ����������. TIMESTAMP ������ ���� � UTC-�������.
  ) COMMENT = '����������';

INSERT INTO
  users (name, birthday_at, created_at, updated_at)
VALUES
  ('��������', '1990-10-05', NULL, NULL),
  ('�������', '1984-11-12', NULL, NULL),
  ('���������', '1985-05-20', NULL, NULL),
  ('������', '1988-02-14', NULL, NULL),
  ('����', '1998-01-12', NULL, NULL),
  ('�����', '2006-08-29', NULL, NULL);

UPDATE
  users
SET
  created_at = NOW(), -- NOW() - ������ ������� CURRENT_TIMESTAMP
  updated_at = NOW();
  
  
-- ���� ��������, ������� 2
-- ������� users ���� �������� ��������������.
-- ������ created_at � updated_at ���� ������ ����� VARCHAR � � ��� ������ ����� ����������
-- �������� � ������� "20.10.2017 8:10".
-- ���������� ������������� ���� � ���� DATETIME, �������� �������� ����� ��������.
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '��� ����������',
  birthday_at DATE COMMENT '���� ��������',
  created_at VARCHAR(255),
  updated_at VARCHAR(255)
) COMMENT = '����������';

INSERT INTO
  users (name, birthday_at, created_at, updated_at)
VALUES
  ('��������', '1990-10-05', '07.01.2016 12:05', '07.01.2016 12:05'),
  ('�������', '1984-11-12', '20.05.2016 16:32', '20.05.2016 16:32'),
  ('���������', '1985-05-20', '14.08.2016 20:10', '14.08.2016 20:10'),
  ('������', '1988-02-14', '21.10.2016 9:14', '21.10.2016 9:14'),
  ('����', '1998-01-12', '15.12.2016 12:45', '15.12.2016 12:45'),
  ('�����', '2006-08-29', '12.01.2017 8:56', '12.01.2017 8:56');

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


-- ���� ��������, ������� 3
-- � ������� ��������� ������� storehouses_products � ���� value ����� ����������� �����
-- ������ �����: 0, ���� ����� ���������� � ���� ����, ���� �� ������ ������� ������.
-- ���������� ������������� ������ ����� �������, ����� ��� ���������� � ������� ����������
-- �������� value. ������, ������� ������ ������ ���������� � �����, ����� ���� �������.
DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT '����� �������� ������� �� ������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '������ �� ������';


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

-- ����������� �������, ����� ��� ���������� � ������� ���������� �������� value
select id, storehouse_id, product_id, value, created_at, updated_at
from storehouses_products
order by value;

-- ����������� �������, ����� ��� ���������� � ������� ���������� �������� value, ��
-- ������� �������� ���� � ����� �������
SELECT
  *
FROM
  storehouses_products
ORDER BY
  IF(value > 0, 0, 1),
  value;

/*
-- ����� ������� �������
SELECT
  *
FROM
  storehouses_products
ORDER BY
  value = 0, value;
 */