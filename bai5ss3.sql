CREATE TABLE ORDERS (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerName VARCHAR(100),
    OrderDate DATETIME,
    TotalAmount DECIMAL(18, 2),
    Status VARCHAR(20),
    IsDeleted TINYINT(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO ORDERS (CustomerName, OrderDate, TotalAmount, Status) 
VALUES
('Nguyễn Văn A', '2023-01-10', 500000, 'Completed'),
('Khách hàng vãng lai', '2023-02-15', 1200000, 'Canceled'),
('Trần Thị B', '2023-05-20', 300000, 'Canceled'),
('Lê Văn C', '2024-01-05', 850000, 'Completed');

SELECT * FROM ORDERS WHERE Status = 'Completed';

SET SQL_SAFE_UPDATES = 0;

UPDATE ORDERS 
SET IsDeleted = 1 
WHERE Status = 'Canceled';

CREATE INDEX idx_active_orders ON ORDERS (IsDeleted, Status);

SELECT * FROM ORDERS 
WHERE IsDeleted = 0;

-- Sử dụng lệnh DELETE để loại bỏ hoàn toàn các bản ghi không còn giá trị khỏi hệ thống
-- Không xóa dữ liệu khỏi bảng mà sử dụng một cột cờ đẻ đánh dấu cho việc ẩn dữ liệu đó đi trong các truy vấn thông thường
-- Bảng so sánh
/*
------------------------|-----------------------------------|-------------------------------------------------
Tiêu chí				|		Cách 1						|		Cách 2
------------------------|-----------------------------------|-------------------------------------------------
Giải phóng dung lượng	|	Giải phóng dung lượng thật sự	|	 Không thật sự giải phóng bộ
						|	trên ổ cứng bằng cách giảm dung	|	 nhớ mà chỉ ẩn nó đi
                        |   lượng file						|
------------------------|-----------------------------------|-------------------------------------------------
Tốc độ truy vấn			|	Nhanh vì ít bản ghi hơn			|	Trung bình vì phải thêm điều kiện 
						|									|	WHERE IsDeleted = 0 vào mọi câu lệnh
------------------------|-----------------------------------|-------------------------------------------------
Tính toàn vẹn dữ liệu	|	Mất hết dữ liệu gây khó khăn	|	Chỉ ẩn đi mà không thật sự xóa nên g
						|	cho việc đối chiếu sau này		|	gây mất dữ liệu trong trường hợp cần đối chiếu
------------------------|-----------------------------------|-------------------------------------------------
*/
-- Chọn cách 2