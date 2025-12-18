CREATE DATABASE SanPham;

/*BẢN SẢN PHẨM - PRODUCTS*/
Create table Products
(
	ImageUrl NVARCHAR(200) NULL,
	Warranty NVARCHAR(200) NULL,
	OldPrice DECIMAL(18,2) NULL,
	Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX), --Thời gian bảo hành
	BrandName NVARCHAR(100) NULL,
    Price DECIMAL(18,2) NOT NULL DEFAULT 0,
     CategoryKey nvarchar(100) -- Mặc định là các giá trị: dobep, giatla, donha, dongho,saykho,bongden
)


/*BẢN ĐƠN HÀNG - ORDERS*/
CREATE TABLE Orders
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ProductId INT NOT NULL,
    ReceiverName NVARCHAR(100) NOT NULL, --Người nhận
    Phone NVARCHAR(20) NOT NULL,
    Address NVARCHAR(255) NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity >= 1),
    UnitPrice decimal NOT NULL CHECK (UnitPrice >= 0),
    TotalAmount decimal NOT NULL CHECK (TotalAmount >= 0),
    PaymentMethod NVARCHAR(50) NOT NULL, --Hiện tại web sử dụng ShipCOD
    Note NVARCHAR(255) NULL,
    Status NVARCHAR(50) NOT NULL, --Nhận 1 trong các giá trị: Chờ xử lý, Chuẩn bị giao, Đang giao, Hoàn thành (Tạo trên web nên không thêm check vào đây)
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    Customers_ID int --Người đặt
);


/*BẢN TIN TỨC CỬA HÀNG VÀ SỨC KHỎE - NEWS*/
CREATE TABLE News
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    Content NVARCHAR(MAX) NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    Category NVARCHAR(50) NOT NULL,        -- nhận giá trị: 'cua-hang' | 'suc-khoe'
    ImageUrl NVARCHAR(255) NULL,           
    IsFeatured BIT NOT NULL DEFAULT 0
);

--Insert ví dụ
INSERT INTO News
(
    Title,
    Content,
    Category,
    ImageUrl,
    IsFeatured,
    CreatedAt
)
VALUES
(
    N'Siêu sale cực khủng ngày 20/10',
    N'Ngày Phụ nữ Việt Nam 20/10 là dịp đặc biệt để tôn vinh, tri ân và gửi lời cảm ơn đến những người phụ nữ tuyệt vời xung quanh chúng ta – từ mẹ, vợ, chị gái cho đến người yêu, bạn bè, hay đồng nghiệp.

Đây không chỉ là ngày của những bó hoa hay lời chúc ngọt ngào, mà còn là cơ hội để nói “cảm ơn” và “yêu thương” bằng hành động thực tế nhất: một món quà được chọn bằng cả tấm lòng.

Nhân dịp này, cửa hàng Aloladu triển khai chương trình SIÊU SALE CỰC KHỦNG với hàng trăm sản phẩm gia dụng chính hãng, giảm giá sâu lên đến 50%, số lượng có hạn.',
    N'cua-hang',
    N'Images/download.jpg',
    1,
    GETDATE()
),
(
    N'Ưu đãi cuối tuần – Mua sắm thả ga',
    N'Cuối tuần này, Aloladu mang đến nhiều ưu đãi hấp dẫn cho các sản phẩm gia dụng thiết yếu, giúp bạn tiết kiệm chi phí và nâng cấp không gian sống.',
    N'cua-hang',
    N'Images/download.jpg',
    0,
    DATEADD(DAY, -1, GETDATE())
),
(
    N'Ra mắt dòng sản phẩm gia dụng mới 2025',
    N'Aloladu chính thức ra mắt loạt sản phẩm gia dụng thông minh năm 2025 với thiết kế hiện đại, tiết kiệm điện và thân thiện với môi trường.',
    N'cua-hang',
    N'Images/download.jpg',
    0,
    DATEADD(DAY, -2, GETDATE())
);



INSERT INTO News (Title, Content, Category, ImageUrl, IsFeatured, CreatedAt)
VALUES
(
    N'Các tip nấu đồ ăn bằng lò vi sóng',
    N'Trong những năm gần đây, nồi chiên không dầu đã trở thành một thiết bị gia dụng phổ biến... (bạn thay nội dung thật sau)',
    N'suc-khoe',
    N'Images/health-1.jpg',
    1,
    GETDATE()
),
(N'Ăn uống khoa học mỗi ngày', N'Một vài gợi ý ăn uống lành mạnh...', N'suc-khoe', N'Images/health-2.jpg', 0, DATEADD(DAY,-1,GETDATE())),
(N'Ngủ đủ giấc giúp tăng đề kháng', N'Mẹo ngủ đủ và đúng giờ...', N'suc-khoe', N'Images/health-3.jpg', 0, DATEADD(DAY,-2,GETDATE()));




/*BẢN TIN TỨC TUYỂN DỤNG - RECRUITMENTS*/
CREATE TABLE Recruitments
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Position NVARCHAR(100) NOT NULL,          
    CvDeadline DATETIME NOT NULL,             
    Salary NVARCHAR(100) NOT NULL,            -- Mức lương (vd: "10-15tr" / "Thỏa thuận")
    WorkType NVARCHAR(50) NOT NULL,           -- Hình thức làm việc (Remote/Onsite/Hybrid)
    WorkingTime NVARCHAR(50) NULL,            -- Thời gian (vd: "8h00 - 17h30")
    JobDescription NVARCHAR(MAX) NULL,        
    Location NVARCHAR(200) NULL,              -
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
);

--Insert thử
INSERT INTO Recruitments
(Position, CvDeadline, Salary, WorkType, WorkingTime, JobDescription, Location)
VALUES
(N'IT BACK - END', '2025-12-12T17:00:00', N'Thỏa thuận', N'Remote', N'8h00 - 17h30',
 N'Xây dựng giao diện web, phối hợp backend, tối ưu UI/UX...', N'Hà Nội'),

(N'IT FRONT - END', '2025-12-11T17:00:00', N'Thỏa thuận', N'Remote', N'8h00 - 17h30',
 N'Xây dựng giao diện web, phối hợp backend, tối ưu UI/UX...', N'Hà Nội'),

(N'IT BACK - END', '2025-12-20T17:00:00', N'15 - 25 triệu', N'Hybrid', N'8h30 - 18h00',
 N'Xây dựng API, làm việc với SQL Server, tối ưu hiệu năng...', N'Hà Nội'),

(N'Tester (Manual)', '2025-12-18T17:00:00', N'10 - 15 triệu', N'Onsite', N'8h00 - 17h30',
 N'Test chức năng, viết test case, phối hợp dev fix bug...', N'Hồ Chí Minh'),

(N'Content Marketing', '2025-12-25T17:00:00', N'Thỏa thuận', N'Onsite', N'8h00 - 17h30',
 N'Viết nội dung fanpage, bài PR, xây dựng kế hoạch nội dung...', N'Hà Nội');


 /*BẢNG KHÁCH HÀNG - CUSTOMERS*/
 CREATE TABLE Customers (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(120) NULL,
    Phone NVARCHAR(20) NOT NULL,
    Address NVARCHAR(255) NULL,
    CCCD NVARCHAR(20) NOT NULL,
    Gender NVARCHAR(10) NULL,        -- "Nam", "Nữ", "Khác"
    BirthDate DATE NULL,
    CreatedAt DATETIME NOT NULL DEFAULT(GETDATE())
);

-- Không cho trùng
CREATE UNIQUE INDEX UX_Customers_CCCD ON Customers(CCCD);
CREATE UNIQUE INDEX UX_Customers_Phone ON Customers(Phone);



/*TẠO CÁC VIEW ĐỂ HIỂN THỊ*/

/*VIEW HIỂN THỊ DANH SÁCH ĐƠN HÀNG*/
Create view vw_Orders_Customers as
Select 
    Orders.id as [Order_ID],
    Orders.CreatedAt as [Order_Time],
    Orders.Status,
    Customers.FullName as [Order_Cus],
    Products.Name as [Order_Prod],
    Orders.Address as [Order_Address],
    Orders.ReceiverName as [Order_Rec],
    Orders.Phone as [Order_Phone],
    Orders.UnitPrice as [Order_Unit],
    Orders.Quantity as [Order_Quan],
    Orders.TotalAmount as [Order_Toltal],
    Orders.Note as [Order_Note]
From Orders left join Customers On Orders.Customers_ID=Customers.Id
            left join Products on Orders.ProductId = Products.Id

/*VIEW HIỂN THỊ DANH SÁCH SẢN PHẨM*/
Create View vw_Products as
Select
    Products.Id as [Proc_ID],
    Name as [Proc_Name],
    CategoryKey as [Proc_Cat],
    BrandName as [Proc_Brand],
    Products.Price as [Proc_Price],
    Products.OldPrice as [Proc_OldPrice],
	Products.ImageUrl as [Proc_Image],
	Products.Description as [Proc_Des],
    SUM(Orders.Quantity) as [Proc_Quan],
    SUM(Orders.TotalAmount) as [Proc_Total]
From Products left join Orders on Products.Id=Orders.ProductId
Group by Products.Id, Name,CategoryKey, BrandName,Products.Price,Products.OldPrice,Products.ImageUrl,Products.Description

/*VIEW HIỂN THỊ TIN TỨC CỬA HÀNG*/
CREATE VIEW vw_News_Store as
Select
	Id as [Nest_ID],
	CreatedAt as [Nest_Time],
	IsFeatured as [Nest_Featured],
	Title as [Nest_Title],
	Content as [Nest_Cont],
	ImageUrl as [Nest_Ima]
From News where Category='cua-hang'

/*VIEW HIỂN THỊ TIN TỨC SỨC KHỎE*/
CREATE VIEW vw_News_Health as
Select
	Id as [Nest_ID],
	CreatedAt as [Nest_Time],
	IsFeatured as [Nest_Featured],
	Title as [Nest_Title],
	Content as [Nest_Cont],
	ImageUrl as [Nest_Ima]
From News where Category='suc-khoe'

/*VIEW HIỂN THỊ TIN TỨC TUYỂN DỤNG*/
CREATE VIEW vw_News_Rec as
Select
    Id as [Rec_ID],
    Position as [Rec_Pos],
    CvDeadline as [Rec_DL],
    WorkType as [Rec_Type],
    WorkingTime as [Rec_Time],
    JobDescription as [Rec_Desc],
    Salary as [Rec_Sal],
    Location as [Rec_Address],
    CreatedAt as [Rec_Create]
From Recruitments

/*VIEW HIỂN THỊ KHÁCH HÀNG*/
CREATE VIEW vw_Customers as
Select
    Customers.Id as [Cus_ID],
    FullName as [Cus_Name],
    Customers.Phone as [Cus_Phone],
    CCCD as [Cus_CCCD],
    Customers.Gender as [Cus_Gender],
    Email as [Cus_Mail],
    Customers.CreatedAt as [Cus_Create],
    Customers.Address as [Cus_Address],
    Customers.BirthDate as [Cus_Birth],
    COUNT(Orders.Id) as [Cus_Order_Quan],
    SUM(Orders.TotalAmount) as [Cus_Total]
From Customers left join Orders on Customers.Id=Orders.Customers_ID
Group by Customers.Id, FullName, Customers.Phone, CCCD,Customers.Gender,Email,Customers.CreatedAt,Customers.Address, Customers.BirthDate 



/*TRIGGER CẦN THIẾT*/
/*CẬP NHẬT LỰA CHỌN TIN CHÍNH*/
--Đối với insert
CREATE TRIGGER insert_news_isfeauture ON News
AFTER INSERT
As
Begin
    Declare @ID INT
    Declare @Isfeature bit
    Declare @Cat nvarchar(50)
    Select @ID=id from INSERTED
    Select @Cat= Category from INSERTED
    Select @Isfeature= IsFeatured from INSERTED

    If @Isfeature=1
            UPDATE News SET IsFeatured=0 where Id<>@ID and Category=@Cat
End

--Đối với update
CREATE TRIGGER update_news_isfeauture ON News
AFTER UPDATE
As
Begin
    Declare @ID INT
    Declare @Isfeature bit
    Declare @Cat nvarchar(50)
    Select @ID=id from INSERTED
    Select @Cat= Category from INSERTED
    Select @Isfeature= IsFeatured from INSERTED

    If @Isfeature=1
            UPDATE News SET IsFeatured=0 where Id<>@ID and Category=@Cat
End





Select * from Orders
Select * from Customers
Select * from vw_Orders_Customers
Select * from Products
Select * from vw_Products
Select * from News
Select * from vw_News_Store
Select * from vw_News_Health
Select * from Recruitments
Select * from vw_News_Rec
Select * from vw_Customers




