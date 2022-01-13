
-- Cleaning Data in SQL Queries


select *
From DataCleaning.dbo.NashvilleHousing


--Standarized Sale Date Format

select SaleDateNew, CONVERT(date, SaleDate)
From DataCleaning.dbo.NashvilleHousing

ALTER TABLE DataCleaning.dbo.NashvilleHousing
Add SaleDateNew Date;

Update DataCleaning.dbo.NashvilleHousing
SET SaleDateNew = CONVERT(Date,SaleDate)


--Populate Property Address data


select *
From DataCleaning.dbo.NashvilleHousing
where PropertyAddress is null
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
From DataCleaning.dbo.NashvilleHousing a
join DataCleaning.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
From DataCleaning.dbo.NashvilleHousing a
join DataCleaning.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From DataCleaning.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1
, LEN(PropertyAddress)) as Address

From DataCleaning.dbo.NashvilleHousing

ALTER TABLE DataCleaning.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update DataCleaning.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE DataCleaning.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update DataCleaning.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))


select *
From DataCleaning.dbo.NashvilleHousing



select OwnerAddress
From DataCleaning.dbo.NashvilleHousing

select
PARSENAME(replace(OwnerAddress, ',','.'), 3)
,PARSENAME(replace(OwnerAddress, ',','.'), 2)
,PARSENAME(replace(OwnerAddress, ',','.'), 1)
From DataCleaning.dbo.NashvilleHousing


ALTER TABLE DataCleaning.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update DataCleaning.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(replace(OwnerAddress, ',','.'), 3)

ALTER TABLE DataCleaning.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update DataCleaning.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',','.'), 2)

ALTER TABLE DataCleaning.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update DataCleaning.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(replace(OwnerAddress, ',','.'), 1)


select *
From DataCleaning.dbo.NashvilleHousing



-- Change Y and N to Yes and No in "Sold as Vacant" field



select distinct(SoldAsVacant), COUNT(SoldAsVacant)
From DataCleaning.dbo.NashvilleHousing
group by SoldAsVacant
order by 2



select SoldAsVacant,
	CASE when SoldAsVacant = 'Y' THEN 'Yes'
		 when SoldAsVacant = 'N' THEN 'No'
		 Else SoldAsVacant
		 END
From DataCleaning.dbo.NashvilleHousing


update DataCleaning.dbo.NashvilleHousing
set SoldAsVacant = 	CASE when SoldAsVacant = 'Y' THEN 'Yes'
		 when SoldAsVacant = 'N' THEN 'No'
		 Else SoldAsVacant
		 END


select SoldAsVacant
From DataCleaning.dbo.NashvilleHousing



--Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From DataCleaning.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


Select *
from DataCleaning.dbo.NashvilleHousing



-- Delete Unused Columns



Select *
From DataCleaning.dbo.NashvilleHousing


ALTER TABLE DataCleaning.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate














