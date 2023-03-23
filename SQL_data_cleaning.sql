SELECT * FROM NashvilleHouse

-- Convert SaleDate datetime to Date format
SELECT CONVERT(date, SaleDate) from NashvilleHouse  

ALTER TABLE NashvilleHouse
ADD sale_date_converted  DATE

UPDATE NashvilleHouse
SET sale_date_converted = CONVERT(date, SaleDate)

--- fill null PropertyAdress
SELECT a.ParcelID, a.PropertyAddress , b.ParcelID,b.PropertyAddress , ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHouse a JOIN NashvilleHouse b ON a.ParcelID=b.ParcelID AND a.[UniqueID ]!=b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHouse a JOIN NashvilleHouse b ON a.ParcelID=b.ParcelID AND a.[UniqueID ]!=b.[UniqueID ]
WHERE a.PropertyAddress is null

--Separate Address from PropertyAddress
SELECT PropertyAddress,
SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1) as Adress,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as City
FROM NashvilleHouse

ALTER TABLE NashvilleHouse
ADD Property_split_address  Nvarchar(255)

UPDATE NashvilleHouse
SET Property_split_address = SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHouse
ADD city  Nvarchar(255)

UPDATE NashvilleHouse
SET city =SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

SELECT * FROM NashvilleHouse

--PARSE from OwnerAddress

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',','.'),3),
PARSENAME(REPLACE(OwnerAddress, ',','.'),2),
PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
FROM NashvilleHouse

ALTER TABLE NashvilleHouse
ADD Owner_split_address  Nvarchar(255)

UPDATE NashvilleHouse
SET Owner_split_address = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

ALTER TABLE NashvilleHouse
ADD Owner_city  Nvarchar(255)

UPDATE NashvilleHouse
SET Owner_city =PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

ALTER TABLE NashvilleHouse
ADD Owner_state  Nvarchar(255)

UPDATE NashvilleHouse
SET Owner_state =PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

SELECT * FROM NashvilleHouse

--Format SoldAsVacant

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant='Y' THEN 'Yes'
 WHEN SoldAsVacant='N' THEN 'No'
 ELSE SoldAsVacant
END
FROM NashvilleHouse

UPDATE NashvilleHouse
SET SoldAsVacant= CASE WHEN SoldAsVacant='Y' THEN 'Yes'
						WHEN SoldAsVacant='N' THEN 'No'
						ELSE SoldAsVacant
						END

SELECT DISTINCT(SoldAsVacant)
FROM NashvilleHouse


-- DROP duplicates

WITH CTE AS (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY ParcelID, PropertyAddress,SaleDate,SalePrice,LegalReference ORDER BY UniqueID) row_num
FROM NashvilleHouse) 
DELETE
from CTE
WHERE row_num>1

WITH CTE AS (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY ParcelID, PropertyAddress,SaleDate,SalePrice,LegalReference ORDER BY UniqueID) row_num
FROM NashvilleHouse) 
SELECT *
from CTE
WHERE row_num>1


-- Drop unused columns
ALTER TABLE NashvilleHouse
DROP COLUMN PropertyAddress,OwnerAddress,TaxDistrict

SELECT *
FROM NashvilleHouse

ALTER TABLE NashvilleHouse
DROP COLUMN SaleDate

SELECT *
FROM NashvilleHouse
