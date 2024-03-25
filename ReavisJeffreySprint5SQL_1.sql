use AdventureWorks2012 
go

-- Drop tables in reverse order due to dependency
DROP TABLE IF EXISTS ProductReviewRatings;
DROP TABLE IF EXISTS ProductReviews;
DROP TABLE IF EXISTS RatingSystem;
DROP TABLE IF EXISTS ProductAttributes;
DROP TABLE IF EXISTS Products;
DROP VIEW IF EXISTS vw_AllProductDetails;
go

-- Create ProductAttributes Table
CREATE TABLE ProductAttributes (
    AttributeID INT IDENTITY(1,1) not null CONSTRAINT PK_ProductAttributes PRIMARY KEY (AttributeID),
    AttributeName VARCHAR(255) NOT NULL,
    AttributeValue VARCHAR(255) NOT NULL,
    
);
go

-- Create Products Table
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) not null CONSTRAINT PK_Products PRIMARY KEY (ProductID),
    Name VARCHAR(255) NOT NULL,
    Description TEXT NOT NULL,
    
);
go

-- Create RatingSystem Table
CREATE TABLE RatingSystem (
    RatingID INT IDENTITY(1,1) not null CONSTRAINT PK_RatingSystem PRIMARY KEY (RatingID),
    Stars INT CHECK (Stars BETWEEN 1 AND 5),
    StarImagePath VARCHAR(255) NOT NULL,
    
);
go

-- Create ProductReviews Table
CREATE TABLE ProductReviews (
    ReviewID INT IDENTITY(1,1),
    ProductID INT NOT NULL,
    CustomerName VARCHAR(255) NOT NULL,
    ReviewText TEXT NOT NULL,
    RatingID INT NOT NULL,
    CONSTRAINT PK_ProductReviews PRIMARY KEY (ReviewID),
    CONSTRAINT FK_ProductReviews_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    CONSTRAINT FK_ProductReviews_RatingSystem FOREIGN KEY (RatingID) REFERENCES RatingSystem(RatingID)
);
go

-- Create ProductReviewRatings Bridge Table
CREATE TABLE ProductReviewRatings (
    ProductReviewRatingID INT IDENTITY(1,1),
    ProductID INT NOT NULL,
    ReviewID INT NOT NULL,
    CONSTRAINT PK_ProductReviewRatings PRIMARY KEY (ProductReviewRatingID),
    CONSTRAINT FK_ProductReviewRatings_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    CONSTRAINT FK_ProductReviewRatings_ProductReviews FOREIGN KEY (ReviewID) REFERENCES ProductReviews(ReviewID)
);
go





-- Insert candles from each collection
-- Classic Soy Collection
INSERT INTO Products (Name, Description) VALUES
('Tranquil Lavender Meadows', 'Our Classic Soy Collection features calming lavender for serenity. Made with premium soy wax.'),
('Vanilla Bean Comfort', 'Elegant vanilla bean scent offering a warm, comforting atmosphere. Part of our Classic Soy Collection.'),
('Citrus Zest Revival', 'Refreshing and invigorating citrus blend. A highlight of our Classic Soy Collection.')
go

-- Seasonal Favorites
INSERT INTO Products (Name, Description) VALUES
('Winter Frost Elegance', 'Crisp notes of peppermint and icy pine from our Seasonal Favorites. Perfect for winter ambiance.'),
('Spring Blossom Bouquet', 'Harmonious blend of cherry blossoms and lilac. Celebrate spring with our Seasonal Favorites.'),
('Sun-Kissed Summer Citrus', 'Zesty citrus fruits to capture the essence of summer. A treasure in our Seasonal Favorites.')
go

-- Natural Simplicity Line
INSERT INTO Products (Name, Description) VALUES
('Unscented Pure Soy Glow', 'Experience the natural warmth of soy wax without added fragrance. Our Natural Simplicity Line.'),
('Cotton Blossom Tranquility', 'Clean, fresh aroma of cotton blossoms. Part of our Natural Simplicity Line.'),
('Bamboo Forest Retreat', 'The subtle, earthy fragrance of bamboo for peace. Discover tranquility with our Natural Simplicity Line.')
go


INSERT INTO RatingSystem (Stars, StarImagePath) VALUES
(1, '/images/ratings/1_star.png'),
(2, '/images/ratings/2_stars.png'),
(3, '/images/ratings/3_stars.png'),
(4, '/images/ratings/4_stars.png'),
(5, '/images/ratings/5_stars.png');
go

-- Insert Scent Attributes
INSERT INTO ProductAttributes (AttributeName, AttributeValue) VALUES
('Scent', 'Lavender'),
('Scent', 'Vanilla'),
('Scent', 'Citrus'),
('Scent', 'Sandalwood'),
('Scent', 'Linen'),
('Scent', 'Coconut'),
('Scent', 'Apple'),
('Scent', 'Ocean Breeze'),
('Scent', 'Peppermint'),
('Scent', 'Floral'),
('Scent', 'Clove'),
('Scent', 'Evergreen'),
('Scent', 'Bamboo'),
('Scent', 'White Tea');
go


-- Insert Color Attributes
INSERT INTO ProductAttributes (AttributeName, AttributeValue) VALUES
('Color', 'Purple'),
('Color', 'Ivory'),
('Color', 'Yellow'),
('Color', 'Brown'),
('Color', 'White'),
('Color', 'Blue'),
('Color', 'Green'),
('Color', 'Red');
go

-- Insert Material Attributes
INSERT INTO ProductAttributes (AttributeName, AttributeValue) VALUES
('Material', 'Soy Wax'),
('Material', 'Beeswax');
go

INSERT INTO ProductReviews (ProductID, CustomerName, ReviewText, RatingID) VALUES
(1, 'Jane Doe', 'Absolutely love this candle. The scent is calming and lasts for a long time.', 5),
(2, 'John Smith', 'The vanilla scent is strong but not overpowering. Perfect for my living room.', 4),
(3, 'Alex Johnson', 'The citrus scent is refreshing and energizing. Great for the kitchen.', 5);
go

---- Create a view that is the join of all your parent and child tables. The view must include all the
--unique columns (i.e., no need to repeat the foreign key in the SELECT list if you are
--including the primary key of the parent table)

CREATE VIEW vw_AllProductDetails AS
SELECT 
    p.ProductID, 
    p.Name AS ProductName, 
    p.Description AS ProductDescription,
    pr.ReviewID,
    pr.CustomerName AS ReviewerName, 
    pr.ReviewText AS ReviewText,
    rs.Stars AS RatingStars, 
    rs.StarImagePath AS RatingImagePath
FROM 
    Products p
LEFT JOIN ProductReviews pr ON p.ProductID = pr.ProductID
LEFT JOIN RatingSystem rs ON pr.RatingID = rs.RatingID;
go

select * from vw_AllProductDetails
go