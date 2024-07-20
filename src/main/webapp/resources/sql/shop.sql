CREATE TABLE product (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price INT NOT NULL,
    stock INT NOT NULL,
    image VARCHAR(255)
);

CREATE TABLE cart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES product(id)
);


CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    name VARCHAR(20) NOT NULL,
    phone VARCHAR(100) NOT NULL,
    address VARCHAR(100) NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT NOT NULL,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES product(id)
);

DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS order_items;

SELECT * FROM product;
SELECT * FROM orders;
SELECT * FROM cart;
SELECT * FROM order_items;
