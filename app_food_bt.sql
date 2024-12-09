-- Tạo database
CREATE DATABASE RestaurantDB
USE RestaurantDB

-- Tạo bảng user
CREATE TABLE user (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255),
    email VARCHAR(255),
    password VARCHAR(255)
)

-- Tạo bảng restaurant
CREATE TABLE restaurant (
    res_id INT AUTO_INCREMENT PRIMARY KEY,
    res_name VARCHAR(255),
    image VARCHAR(255),
    `desc` VARCHAR(255)
)

-- Tạo bảng food_type
CREATE TABLE food_type (
    type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(255)
)

-- Tạo bảng food
CREATE TABLE food (
    food_id INT AUTO_INCREMENT PRIMARY KEY,
    food_name VARCHAR(255),
    image VARCHAR(255),
    price FLOAT,
    `desc` VARCHAR(255),
    type_id INT,
    FOREIGN KEY (type_id) REFERENCES food_type(type_id)
)

-- Tạo bảng sub_food
CREATE TABLE sub_food (
    sub_id INT AUTO_INCREMENT PRIMARY KEY,
    sub_name VARCHAR(255),
    sub_price FLOAT,
    food_id INT,
    FOREIGN KEY (food_id) REFERENCES food(food_id)
)

-- Tạo bảng order
CREATE TABLE `order` (
    user_id INT,
    food_id INT,
    amount INT,
    code VARCHAR(255),
    arr_sub_id VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (food_id) REFERENCES food(food_id)
)

-- Tạo bảng like_res
CREATE TABLE like_res (
    user_id INT,
    res_id INT,
    date_like DATETIME,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (res_id) REFERENCES restaurant(res_id)
)

-- Tạo bảng rate_res
CREATE TABLE rate_res (
    user_id INT,
    res_id INT,
    amount INT,
    date_rate DATETIME,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (res_id) REFERENCES restaurant(res_id)
)

-- Chèn dữ liệu mẫu vào bảng user
INSERT INTO user (full_name, email, password) VALUES
('John Doe', 'john@example.com', 'password123'),
('Jane Smith', 'jane@example.com', 'securepass')

-- Chèn dữ liệu mẫu vào bảng restaurant
INSERT INTO restaurant (res_name, image, `desc`) VALUES
('Pizza Palace', 'pizza.jpg', 'Best pizzas in town'),
('Sushi World', 'sushi.jpg', 'Authentic Japanese sushi')

-- Chèn dữ liệu mẫu vào bảng food_type
INSERT INTO food_type (type_name) VALUES
('Pizza'),
('Sushi'),
('Drinks')

-- Chèn dữ liệu mẫu vào bảng food
INSERT INTO food (food_name, image, price, `desc`, type_id) VALUES
('Margherita Pizza', 'margherita.jpg', 8.99, 'Classic cheese pizza', 1),
('Pepperoni Pizza', 'pepperoni.jpg', 9.99, 'Spicy pepperoni pizza', 1),
('California Roll', 'california_roll.jpg', 7.99, 'Crab and avocado sushi roll', 2)

-- Chèn dữ liệu mẫu vào bảng sub_food
INSERT INTO sub_food (sub_name, sub_price, food_id) VALUES
('Extra Cheese', 1.50, 1),
('Bacon', 2.00, 1)

-- Chèn dữ liệu mẫu vào bảng order
INSERT INTO `order` (user_id, food_id, amount, code, arr_sub_id) VALUES
(1, 1, 2, 'ORD001', '1,2'),
(2, 3, 1, 'ORD002', '')

-- Chèn dữ liệu mẫu vào bảng like_res
INSERT INTO like_res (user_id, res_id, date_like) VALUES
(1, 1, '2023-12-01 14:30:00'),
(2, 2, '2023-12-02 15:00:00')

-- Chèn dữ liệu mẫu vào bảng rate_res
INSERT INTO rate_res (user_id, res_id, amount, date_rate) VALUES
(1, 1, 5, '2023-12-01 16:00:00'),
(2, 2, 4, '2023-12-02 17:00:00')


-- Câu truy vấn 1: Tìm 5 người đã like nhà hàng nhiều nhất

SELECT 
    u.user_id,
    u.full_name,
    u.email,
    COUNT(lr.res_id) AS total_likes
FROM 
    user u
JOIN 
    like_res lr ON u.user_id = lr.user_id
GROUP BY 
    u.user_id, u.full_name, u.email
ORDER BY 
    total_likes DESC
LIMIT 5;


-- Câu truy vấn 2: Tìm 2 nhà hàng có lượt like nhiều nhất
SELECT 
    r.res_id,
    r.res_name,
    r.image,
    r.`desc`,
    COUNT(lr.user_id) AS total_likes
FROM 
    restaurant r
JOIN 
    like_res lr ON r.res_id = lr.res_id
GROUP BY 
    r.res_id, r.res_name, r.image, r.`desc`
ORDER BY 
    total_likes DESC
LIMIT 2;

-- Câu truy vấn 3: Tìm người đã đặt hàng nhiều nhất
SELECT 
    u.user_id,
    u.full_name,
    u.email,
    SUM(o.amount) AS total_items_ordered
FROM 
    user u
JOIN 
    `order` o ON u.user_id = o.user_id
GROUP BY 
    u.user_id, u.full_name, u.email
ORDER BY 
    total_items_ordered DESC
LIMIT 1;

-- Câu truy vấn 4: Tìm người dùng không hoạt động trong hệ thống
SELECT 
    u.user_id,
    u.full_name,
    u.email
FROM 
    user u
WHERE 
    u.user_id NOT IN (SELECT DISTINCT user_id FROM `order`)
    AND u.user_id NOT IN (SELECT DISTINCT user_id FROM like_res)
    AND u.user_id NOT IN (SELECT DISTINCT user_id FROM rate_res);
