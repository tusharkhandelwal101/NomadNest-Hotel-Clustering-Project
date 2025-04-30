CREATE DATABASE project_traveldb;
USE project_traveldb;
DROP TABLE IF EXISTS travel_stay_data;

CREATE TABLE travel_stay_data (
  CheckInDate DATE,
  CheckOutDate DATE,
  State VARCHAR(100),
  City VARCHAR(100),
  RoomType VARCHAR(50),
  BookingChannel VARCHAR(50),
  OccupancyRate DECIMAL(4,2),
  RevenuePerBed DECIMAL(10,2),
  CustomerAcquisitionCost DECIMAL(10,2),
  FeedbackRating INT
);

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Travel_Stay_Data.csv'
INTO TABLE travel_stay_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
  @CheckInDate,
  @CheckOutDate,
  @State,
  @City,
  @RoomType,
  @BookingChannel,
  @OccupancyRate,
  @RevenuePerBed,
  @CustomerAcquisitionCost,
  @FeedbackRating
)
SET
  CheckInDate = STR_TO_DATE(NULLIF(@CheckInDate, ''), '%d-%m-%Y'),
  CheckOutDate = STR_TO_DATE(NULLIF(@CheckOutDate, ''), '%d-%m-%Y'),
  State = NULLIF(@State, ''),
  City = NULLIF(@City, ''),
  RoomType = NULLIF(@RoomType, ''),
  BookingChannel = NULLIF(@BookingChannel, ''),
  OccupancyRate = NULLIF(@OccupancyRate, ''),
  RevenuePerBed = NULLIF(@RevenuePerBed, ''),
  CustomerAcquisitionCost = NULLIF(@CustomerAcquisitionCost, ''),
  FeedbackRating = NULLIF(@FeedbackRating, '');

-- SELECT COUNT(*) FROM travel_stay_data;
-- SELECT * FROM travel_stay_data LIMIT 5;

-- SELECT State, COUNT(*) AS BookingCount
-- FROM travel_stay_data
-- GROUP BY State
-- ORDER BY BookingCount DESC;

-- SELECT RoomType,
--        ROUND(AVG(OccupancyRate), 2) AS AvgOccupancy,
--        ROUND(AVG(RevenuePerBed), 2) AS AvgRevenue
-- FROM travel_stay_data
-- GROUP BY RoomType;

-- SELECT BookingChannel, COUNT(*) AS TotalBookings
-- FROM travel_stay_data
-- GROUP BY BookingChannel
-- ORDER BY TotalBookings DESC;

-- SELECT ROUND(AVG(RevenuePerBed), 2) AS AvgRevenue,
--        ROUND(AVG(CustomerAcquisitionCost), 2) AS AvgCAC
-- FROM travel_stay_data;

--  -- 1. Revenue per State-City Combination
--  SELECT 
--   State, 
--   City, 
--   COUNT(*) AS TotalBookings,
--   ROUND(SUM(RevenuePerBed), 2) AS TotalRevenue,
--   ROUND(AVG(RevenuePerBed), 2) AS AvgRevenuePerBooking
-- FROM travel_stay_data
-- GROUP BY State, City
-- ORDER BY TotalRevenue DESC;

-- -- 2. Room Type Performance by Booking Channel
-- SELECT 
--   RoomType,
--   BookingChannel,
--   COUNT(*) AS Bookings,
--   ROUND(AVG(OccupancyRate), 2) AS AvgOccupancy,
--   ROUND(AVG(RevenuePerBed), 2) AS AvgRevenue
-- FROM travel_stay_data
-- GROUP BY RoomType, BookingChannel
-- ORDER BY AvgRevenue DESC;

-- -- 3. Customer Acquisition Cost vs Feedback Rating
-- SELECT 
--   FeedbackRating,
--   COUNT(*) AS TotalReviews,
--   ROUND(AVG(CustomerAcquisitionCost), 2) AS AvgCAC,
--   ROUND(AVG(RevenuePerBed), 2) AS AvgRevenue
-- FROM travel_stay_data
-- GROUP BY FeedbackRating
-- ORDER BY FeedbackRating DESC;

-- -- 4. Average Stay Duration + Revenue Per Stay
-- SELECT 
--   ROUND(AVG(DATEDIFF(CheckOutDate, CheckInDate)), 1) AS AvgStayDays,
--   ROUND(AVG(RevenuePerBed * OccupancyRate * DATEDIFF(CheckOutDate, CheckInDate)), 2) AS AvgRevenuePerStay
-- FROM travel_stay_data;

-- -- 5. Best Performing Cities (High Occupancy & Revenue)
-- SELECT 
--   City,
--   ROUND(AVG(OccupancyRate), 2) AS AvgOccupancy,
--   ROUND(AVG(RevenuePerBed), 2) AS AvgRevenue
-- FROM travel_stay_data
-- GROUP BY City
-- HAVING AvgOccupancy > 0.70 AND AvgRevenue > 700
-- ORDER BY AvgRevenue DESC;

-- -- 6. Booking Trends Over Time (Monthly)
-- SELECT 
--   DATE_FORMAT(CheckInDate, '%Y-%m') AS Month,
--   COUNT(*) AS TotalBookings,
--   ROUND(AVG(RevenuePerBed), 2) AS AvgRevenue
-- FROM travel_stay_data
-- GROUP BY Month
-- ORDER BY Month;


-- SELECT 
--   City,
--   RoomType,
--   BookingChannel,
--   ROUND(AVG(OccupancyRate), 2) AS AvgOccupancy,
--   ROUND(AVG(RevenuePerBed), 2) AS AvgRevenue,
--   ROUND(AVG(CustomerAcquisitionCost), 2) AS AvgCAC,
--   ROUND(AVG(FeedbackRating), 2) AS AvgRating
-- FROM travel_stay_data
-- GROUP BY City, RoomType, BookingChannel;

SELECT * FROM travel_stay_data LIMIT 3;

-- Null value check  
SELECT 
  SUM(CASE WHEN CheckInDate IS NULL THEN 1 ELSE 0 END) AS Null_CheckInDate,
  SUM(CASE WHEN CheckOutDate IS NULL THEN 1 ELSE 0 END) AS Null_CheckOutDate,
  SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END) AS Null_State,
  SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS Null_City,
  SUM(CASE WHEN RoomType IS NULL THEN 1 ELSE 0 END) AS Null_RoomType,
  SUM(CASE WHEN BookingChannel IS NULL THEN 1 ELSE 0 END) AS Null_BookingChannel,
  SUM(CASE WHEN OccupancyRate IS NULL THEN 1 ELSE 0 END) AS Null_OccupancyRate,
  SUM(CASE WHEN RevenuePerBed IS NULL THEN 1 ELSE 0 END) AS Null_RevenuePerBed,
  SUM(CASE WHEN CustomerAcquisitionCost IS NULL THEN 1 ELSE 0 END) AS Null_CustomerAcquisitionCost,
  SUM(CASE WHEN FeedbackRating IS NULL THEN 1 ELSE 0 END) AS Null_FeedbackRating
FROM travel_stay_data;

-- Descriptive Stats 
SELECT 
  MIN(OccupancyRate) AS Min_Occupancy,
  MAX(OccupancyRate) AS Max_Occupancy,
  AVG(OccupancyRate) AS Avg_Occupancy,
  
  MIN(RevenuePerBed) AS Min_RevPerBed,
  MAX(RevenuePerBed) AS Max_RevPerBed,
  AVG(RevenuePerBed) AS Avg_RevPerBed,
  
  MIN(CustomerAcquisitionCost) AS Min_CAC,
  MAX(CustomerAcquisitionCost) AS Max_CAC,
  AVG(CustomerAcquisitionCost) AS Avg_CAC,
  
  MIN(FeedbackRating) AS Min_Rating,
  MAX(FeedbackRating) AS Max_Rating,
  AVG(FeedbackRating) AS Avg_Rating
FROM travel_stay_data;

-- Duration of Stay
SELECT 
  CheckInDate, CheckOutDate,
  DATEDIFF(STR_TO_DATE(CheckOutDate, '%Y-%m-%d'), STR_TO_DATE(CheckInDate, '%Y-%m-%d')) AS StayDuration
FROM travel_stay_data
LIMIT 4;
 
--  -- Handling Null Values -- --

-- SELECT 
--   COALESCE(BookingChannel, 'Unknown') AS CleanedChannel
-- FROM travel_stay_data;

UPDATE travel_stay_data
SET BookingChannel = 'Unknown'
WHERE BookingChannel IS NULL;

UPDATE travel_stay_data
SET RevenuePerBed = 750.19
WHERE RevenuePerBed IS NULL;

UPDATE travel_stay_data
SET OccupancyRate = 0.702
WHERE OccupancyRate IS NULL;

UPDATE travel_stay_data
SET CustomerAcquisitionCost = 176.53
WHERE CustomerAcquisitionCost IS NULL;

-- Adding Stay Duration

ALTER TABLE travel_stay_data ADD COLUMN StayDuration INT;

UPDATE travel_stay_data
SET StayDuration = DATEDIFF(
	STR_TO_DATE(CheckOutDate, '%Y-%m-%d'),
    STR_TO_DATE(CheckInDate, '%Y-%m-%d')
);

-- Clean Data View 
CREATE VIEW vw_clean_travel_data AS
SELECT 
  *,
  DATEDIFF(STR_TO_DATE(CheckOutDate, '%Y-%m-%d'), STR_TO_DATE(CheckInDate, '%Y-%m-%d')) AS StayDuration,
  COALESCE(BookingChannel, 'Unknown') AS CleanedBookingChannel
FROM travel_stay_data
WHERE OccupancyRate IS NOT NULL
  AND RevenuePerBed IS NOT NULL
  AND CustomerAcquisitionCost IS NOT NULL;
