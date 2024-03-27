USE SP24_ksjefreav;
GO

-- Drop existing views and tables
DROP VIEW IF EXISTS vw_AllProductDetails;
GO

DROP TABLE IF EXISTS ProductReviews;
DROP TABLE IF EXISTS Products;
DROP TABLE if EXISTS ScentMaster;
DROP TABLE if EXISTS ColorMaster;
DROP TABLE if EXISTS MaterialMaster;
DROP TABLE IF EXISTS RatingSystem;
GO

-- Create Products table with attributes
Create TABLE ScentMaster (
	ScentID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_ScentID PRIMARY KEY,
	ScentName VARCHAR (50) NOT NULL)
GO

Create TABLE ColorMaster (
	ColorID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_ColorID PRIMARY KEY,
	ColorName VARCHAR (50) NOT NULL)
GO

Create TABLE MaterialMaster (
	MaterialID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_MaterialID PRIMARY KEY,
	MaterialName VARCHAR (50) NOT NULL)
GO

CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Products PRIMARY KEY,
    ProductName VARCHAR(255) NOT NULL,
    ProductDescription TEXT NOT NULL,
    ScentID INT NOT NULL CONSTRAINT FK_ScentMaster_ScentID Foreign KEY References ScentMaster (ScentID), 
    ColorID INT NOT NULL CONSTRAINT FK_ColorMaster_ColorID Foreign KEY References ColorMaster (ColorID),
    MaterialID INT NOT NULL CONSTRAINT FK_MaterialMaster_MaterialID Foreign KEY References MaterialMaster (MaterialID)
);
GO

-- Create RatingSystem Table
CREATE TABLE RatingSystem (
    RatingID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_RatingSystem PRIMARY KEY,
    StarsID INT NOT NULL,
    StarImagePath VARCHAR(255) NOT NULL
);
GO

-- Create ProductReviews Table directly linked to Products and RatingSystem
CREATE TABLE ProductReviews (
    ReviewID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_ProductReviews PRIMARY KEY,
    ProductID INT NOT NULL CONSTRAINT FK_Products_ProductID  FOREIGN KEY References Products (ProductID),
    CustomerName VARCHAR(255) NOT NULL,
    ReviewText TEXT NOT NULL,
    RatingID INT NOT NULL CONSTRAINT FK_RatingSystem_RatingID  FOREIGN KEY References RatingSystem(RatingID)
);
GO

-- Insert data into Products and attributes
INSERT INTO ScentMaster (ScentName) VALUES
('Lavender'),
('Vanilla'),
('Citrus'),
('Sandalwood'),
('Linen'),
('Ocean Mist')
GO

INSERT INTO ColorMaster (ColorName) VALUES
('Purple'),
('Ivory'),
('Yellow'),
('Brown'),
('White'),
('Blue')
GO

INSERT INTO MaterialMaster (MaterialName) VALUES
('Soy'),
('Wax'),
('Organic')
GO

INSERT INTO Products (ProductName, ProductDescription, ScentID, ColorID, MaterialID) VALUES
('Tranquil Lavender Meadows', 'Calming lavender for serenity. Made with premium soy wax.', 1, 1, 1),
('Vanilla Bean Comfort', 'Warm, inviting vanilla bean aroma. Perfect for creating a sense of home.', 2, 2, 1),
('Citrus Zest Revival', 'Energizing citrus blend to refresh any room.', 3, 3, 2),
('Earthy Sandalwood Serenity', 'Grounding sandalwood aroma for peace.', 4, 4, 2),
('Crisp White Linen Breeze', 'The scent of freshly laundered linens.', 5, 5, 3),
('Refreshing Ocean Mist', 'Breezy and light, capturing the essence of the ocean.', 6, 6, 3);
GO

-- Insert data into RatingSystem
INSERT INTO RatingSystem (StarsID, StarImagePath) VALUES
(1, '/images/star1.jpg'),
(2, '/images/star2.jpg'),
(3, '/images/star3.jpg'),
(4, '/images/star4.jpg'),
(5, '/images/star5.jpg');
GO

-- Insert multiple reviews for each product (adjust ProductID as necessary)
INSERT INTO ProductReviews (ProductID, CustomerName, ReviewText, RatingID) VALUES
-- For 'Tranquil Lavender Meadows'
(1, 'Jane Doe', 'Extremely disappointed with the Lavender candle. The scent is barely noticeable and fades away in minutes. Not worth the money at all.', 1),
(1, 'John Doe', 'Perfect for meditation and relaxation. Highly recommend.', 5),
(1, 'Emily Stone', 'A wonderful addition to any room for a serene atmosphere.' ,5),
-- For 'Vanilla Bean Comfort'
(2, 'Sarah Clark', 'This vanilla candle is a game changer. Makes my entire home smell amazing.', 5),
(2, 'Mike Lowell', 'Bought it as a gift, and they loved it! The vanilla scent is just perfect.', 4),
(2, 'Angela Simmons', 'Not too overpowering, just the right amount of vanilla. Will buy again.', 4),

-- For 'Citrus Zest Revival'
(3, 'Carlos Gomez', 'So refreshing! Perfect for summer days.', 5),
(3, 'Fiona Lee', 'The Citrus Zest candle was a total letdown. It smells nothing like citrus and more like a chemical concoction. Gave me a headache within the first ten minutes of burning.', 1),
(3, 'Derek Sun', 'Love the blend of citrus scents, like having an orchard at home.', 4),

-- For 'Earthy Sandalwood Serenity'
(4, 'Heather Morris', 'The sandalwood scent is so grounding. It''s my new favorite.', 5),
(4, 'Raj Patel', 'A very sophisticated scent that fills the room nicely.', 5),
(4, 'Linda Yu', 'Great for evenings, the sandalwood aroma is very relaxing.', 4),

-- For 'Crisp White Linen Breeze'
(5, 'Tom Sawyer', 'Smells like fresh laundry. It’s so light and airy!', 5),
(5, 'Rachel Adams', 'This candle’s scent is clean and refreshing. Love it for the bathroom.', 4),
(5, 'Nathan Brooks', 'A clean, subtle scent that’s not too overwhelming. Perfect for guests.', 4),

-- For 'Refreshing Ocean Mist'
(6, 'Danielle Smith', 'Takes me right back to the beach. The ocean mist scent is spot on.', 5),
(6, 'Brian Connor', 'I use this in my office for a refreshing vibe. Highly recommended.', 5),
(6, 'Sophia Nguyen', 'A light, breezy scent that’s perfect for relaxing after a long day.', 4);
GO


-- Create a view to display product details along with reviews and ratings
CREATE VIEW vw_AllProductDetails AS
SELECT 
    p.ProductID, 
    p.ProductName, 
    p.ProductDescription,
    s.ScentID,
	s.ScentName,
    c.ColorID,
	c.ColorName,
    m.MaterialID,
	m.MaterialName,
    pr.ReviewID,
    pr.CustomerName, 
    pr.ReviewText,
    rs.StarsID, 
    rs.StarImagePath
FROM 
    Products p
JOIN ProductReviews pr ON p.ProductID = pr.ProductID
JOIN RatingSystem rs ON pr.RatingID = rs.RatingID
JOIN ScentMaster s ON p.ScentID = s.ScentID
JOIN ColorMaster c ON p.ColorID = c.ColorID
JOIN MaterialMaster m ON p.MaterialID = m.MaterialID
GO

-- Select from the view to test it
SELECT * FROM vw_AllProductDetails;
GO
