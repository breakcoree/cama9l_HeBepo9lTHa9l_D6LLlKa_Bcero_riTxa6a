-- @Подготовка


CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0)
);

CREATE TABLE order_history (
    log_id SERIAL PRIMARY KEY,
    product_id INT,
    quantity_changed INT,
    notes VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO products (product_id, name, quantity) VALUES
(1, 'Ноутбук', 20),
(2, 'Смартфон', 50);


-- @Задание 1: Успешная продажа (COMMIT)

BEGIN;

UPDATE products
SET quantity = quantity - 5
    WHERE name = 'Ноутбук';

INSERT INTO order_history (product_id, quantity_changed, notes)
VALUES (
    1,
    -5,
    'Продажа 5 ноутбуков'
);

COMMIT;

-- Проверка
SELECT * FROM products;
SELECT * FROM order_history;

-- @Задание 2: Неудачная продажа (ROLLBACK)


BEGIN;

-- Попытка списать больше, чем есть (вызовет ошибку CHECK)
UPDATE products
SET quantity = quantity - 100
    WHERE name = 'Смартфон';

-- Эта команда не выполнится из-за ошибки выше
INSERT INTO order_history (product_id, quantity_changed, notes)
VALUES (2, -100, 'Попытка продажи 100 смартфонов');

-- PostgreSQL перевёл транзакцию в состояние aborted,
-- поэтому обязательно делаем ROLLBACK
ROLLBACK;

-- Проверка: данные не изменились
SELECT * 
FROM products;
SELECT * 
FROM order_history;

-- @Задание 3: Ручной откат


BEGIN;

UPDATE products
SET quantity = quantity - 2
    WHERE name = 'Ноутбук';

-- откат вручную
ROLLBACK;

SELECT * 
FROM products;

-- @Задание 4 (со звездочкой): Демонстрация уровня изоляции


-- Это задание требует двух одновременно открытых подключений к базе данных (например, два окна терминала с `psql`).

-- Сессия 1:
BEGIN;
UPDATE products SET quantity = quantity - 10 
    WHERE product_id = 2;
-- (не COMMIT пока)

-- Сессия 2 (одновременно):
SELECT * FROM products 
    WHERE product_id = 2;
-- quantity всё ещё 50, изменения из сессии 1 не видны

-- Сессия 1:
COMMIT;

-- Сессия 2:
SELECT * FROM products 
    WHERE product_id = 2;
-- -- теперь quantity = 40, изменения из сессии 1 зафиксированы
