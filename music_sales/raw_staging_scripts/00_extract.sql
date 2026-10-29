-- =====================================================================
-- 00_extract.sql
-- Run in: VS Code (MSSQL extension), connected to the school SQL Server
--         externalworld.cent-su.org,11433 , database Chinook
-- What it does: nine SELECT queries, one per Chinook table.
--
-- How to use it:
--   Run ONE query at a time: highlight it, press Ctrl+Shift+E
--   (Mac: Cmd+Shift+E), then save that result grid as the CSV
--   named in its comment, inside Documents\chinook_extract.
--
-- CONVERT(varchar(23), <date>, 121) writes dates as 2009-01-01 00:00:00.000
-- whatever your VS Code display settings are. It changes the format,
-- not the value.
-- =====================================================================


-- ---------------------------------------------------------------------
-- 1 of 9  ->  album.csv  (347 rows)
-- ---------------------------------------------------------------------
SELECT AlbumId, Title, ArtistId
FROM Chinook.dbo.Album
ORDER BY AlbumId;


-- ---------------------------------------------------------------------
-- 2 of 9  ->  artist.csv  (275 rows)
-- ---------------------------------------------------------------------
SELECT ArtistId, Name
FROM Chinook.dbo.Artist
ORDER BY ArtistId;


-- ---------------------------------------------------------------------
-- 3 of 9  ->  customer.csv  (59 rows)
-- ---------------------------------------------------------------------
SELECT CustomerId, FirstName, LastName, Company, Address, City, State,
       Country, PostalCode, Phone, Fax, Email, SupportRepId
FROM Chinook.dbo.Customer
ORDER BY CustomerId;


-- ---------------------------------------------------------------------
-- 4 of 9  ->  employee.csv  (8 rows)
-- ---------------------------------------------------------------------
SELECT EmployeeId, LastName, FirstName, Title, ReportsTo,
       CONVERT(varchar(23), BirthDate, 121) AS BirthDate,
       CONVERT(varchar(23), HireDate, 121) AS HireDate,
       Address, City, State, Country, PostalCode, Phone, Fax, Email
FROM Chinook.dbo.Employee
ORDER BY EmployeeId;


-- ---------------------------------------------------------------------
-- 5 of 9  ->  genre.csv  (25 rows)
-- ---------------------------------------------------------------------
SELECT GenreId, Name
FROM Chinook.dbo.Genre
ORDER BY GenreId;


-- ---------------------------------------------------------------------
-- 6 of 9  ->  invoice.csv  (412 rows)
-- ---------------------------------------------------------------------
SELECT InvoiceId, CustomerId,
       CONVERT(varchar(23), InvoiceDate, 121) AS InvoiceDate,
       BillingAddress, BillingCity, BillingState, BillingCountry,
       BillingPostalCode, Total
FROM Chinook.dbo.Invoice
ORDER BY InvoiceId;


-- ---------------------------------------------------------------------
-- 7 of 9  ->  invoiceline.csv  (2240 rows)
-- ---------------------------------------------------------------------
SELECT InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity
FROM Chinook.dbo.InvoiceLine
ORDER BY InvoiceLineId;


-- ---------------------------------------------------------------------
-- 8 of 9  ->  mediatype.csv  (5 rows)
-- ---------------------------------------------------------------------
SELECT MediaTypeId, Name
FROM Chinook.dbo.MediaType
ORDER BY MediaTypeId;


-- ---------------------------------------------------------------------
-- 9 of 9  ->  track.csv  (3503 rows)
-- ---------------------------------------------------------------------
SELECT TrackId, Name, AlbumId, MediaTypeId, GenreId, Composer,
       Milliseconds, Bytes, UnitPrice
FROM Chinook.dbo.Track
ORDER BY TrackId;
