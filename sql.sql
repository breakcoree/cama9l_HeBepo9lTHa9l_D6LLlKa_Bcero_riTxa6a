-- @табличкииииииииииииии

CREATE TABLE customer (
    id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    birth_date DATE
);

CREATE TABLE employee (
    id SERIAL PRIMARY KEY,
    employee_name VARCHAR(100),
    position VARCHAR(50)
);

CREATE TABLE category (
    id SERIAL PRIMARY KEY,
    category_name VARCHAR(100)
);

CREATE TABLE product (
    id SERIAL PRIMARY KEY,
    product_name VARCHAR(150),
    price DECIMAL(8,2),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES category(id)
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT,
    employee_id INT,
    order_date TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customer(id),
    FOREIGN KEY (employee_id) REFERENCES employee(id)
);

CREATE TABLE order_item (
    id SERIAL PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES product(id)
);

CREATE TABLE payment (
    id SERIAL PRIMARY KEY,
    order_id INT,
    payment_type VARCHAR(50),
    amount DECIMAL(8,2),
    payment_date TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id)
);


-- данные чтобы было

-- @region_customers
INSERT INTO customer (customer_name, birth_date) VALUES
('Ivan Ivanov', '1995-02-15'),
('Petr Petrov', '1990-03-20'),
('Anna Smirnova', '2001-01-10'),
('Olga Kuznetsova', '1988-01-05'),
('Sergey Volkov', '1999-02-28'),
('Maria Orlova', '2003-04-18');
-- @endregion_customers

-- @region_employees
INSERT INTO employee (employee_name, position) VALUES
('Alexey', 'Cashier'),
('Dmitry', 'Seller'),
('Elena', 'Manager');
-- @endregion_employees

-- @region_categories
INSERT INTO category (category_name) VALUES
('Drinks'),
('Bakery'),
('Hot food');
-- @endregion_categories

-- @region_products
INSERT INTO product (product_name, price, category_id) VALUES
('Coffee', 150.00, 1),
('Tea', 100.00, 1),
('Croissant', 120.00, 2),
('Sandwich', 250.00, 3),
('Pizza slice', 300.00, 3),
('Juice', 130.00, 1);
-- @endregion_products

-- @region_orders
INSERT INTO orders (customer_id, employee_id, order_date) VALUES
(1, 1, '2025-12-17'),
(2, 2, '2025-12-17'),
(3, 1, '2025-12-12'),
(4, 3, '2025-01-14'),
(5, 2, '2025-11-30'),
(6, 1, '2025-12-15');
-- @endregion_orders

-- @region_order_items
INSERT INTO order_item (order_id, product_id, quantity) VALUES
(1, 1, 2),
(1, 3, 1),
(2, 2, 1),
(2, 4, 2),
(3, 5, 1),
(3, 1, 1),
(4, 3, 3),
(5, 5, 2),
(5, 6, 1),
(6, 4, 1),
(6, 1, 1);
-- @endregion_order_items

-- @region_payments
INSERT INTO payment (order_id, payment_type, amount, payment_date) VALUES
(1, 'card', 420.00, '2025-12-17'),
(2, 'cash', 600.00, '2025-12-17'),
(3, 'card', 450.00, '2025-12-12'),
(4, 'card', 360.00, '2025-01-14'),
(5, 'cash', 730.00, '2025-11-30'),
(6, 'card', 400.00, '2025-12-15');
-- @endregion_payments

-- @region_задания

SELECT *
FROM customer;

SELECT *
FROM employee;

SELECT *
FROM category;

SELECT *
FROM product;

SELECT *
FROM orders;

SELECT *
FROM order_item;

SELECT *
FROM payment;

-- @1: Найти всех покупателей, у которых ДР в следующем месяце
SELECT *
FROM customer
WHERE EXTRACT(MONTH FROM birth_date) =
      EXTRACT(MONTH FROM CURRENT_DATE + INTERVAL '1 month');

-- @2: Посчитать выручку за текущий месяц
SELECT SUM(amount) AS total_revenue
FROM payment
WHERE EXTRACT(MONTH FROM payment_date) = EXTRACT(MONTH FROM CURRENT_DATE);

-- @3: Топ 5 самых продаваемых продуктов за последние 3 месяца
SELECT p.product_name, SUM(oi.quantity) AS total_sold
FROM order_item oi
JOIN orders o 
    ON oi.order_id = o.id
JOIN product p 
    ON oi.product_id = p.id
WHERE o.order_date >= CURRENT_DATE - INTERVAL '3 months'
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 5;
-- @endregion_задания





