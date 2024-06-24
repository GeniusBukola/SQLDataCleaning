/*
Cleaning Data in sql
*/

Select *
from PortfolioProject.dbo.HousingData

----Standardizing Date Format

Select SaleDate
from PortfolioProject.dbo.HousingData

Select SaleDate, Convert(Date,SaleDate)
from PortfolioProject.dbo.HousingData

--Method 1
Update HousingData
Set SaleDateUpdated = Convert(Date,SaleDate)

Select SaleDateUpdated
from PortfolioProject.dbo.HousingData

--Method 2

Alter Table HousingData
Add SaledateConverted Date;

Update HousingData
Set SaledateConverted = Convert(Date,SaleDate)

Select SaleDateConverted, Convert(Date,SaleDate)
from PortfolioProject.dbo.HousingData

----Property Address Data

Select PropertyAddress
from PortfolioProject.dbo.HousingData

Select PropertyAddress
from PortfolioProject.dbo.HousingData
where PropertyAddress is Null

Select *
from PortfolioProject.dbo.HousingData
where PropertyAddress is Null

Select *
from PortfolioProject.dbo.HousingData
Order by ParcelID

Select *
from PortfolioProject.dbo.HousingData a
Join PortfolioProject.dbo.HousingData b
	On a.ParcelID = b.ParcelID
	
Select *
from PortfolioProject.dbo.HousingData a
Join PortfolioProject.dbo.HousingData b
	On a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from PortfolioProject.dbo.HousingData a
Join PortfolioProject.dbo.HousingData b
	On a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from PortfolioProject.dbo.HousingData a
Join PortfolioProject.dbo.HousingData b
	On a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,Isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.HousingData a
Join PortfolioProject.dbo.HousingData b
	On a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
set PropertyAddress = Isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.HousingData a
Join PortfolioProject.dbo.HousingData b
	On a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Select *
from PortfolioProject.dbo.HousingData


--Breaking down Address into different column (Address, city, state)

Select PropertyAddress
from PortfolioProject.dbo.HousingData

----Method 1
Select
Substring(PropertyAddress, 1,charindex(',',PropertyAddress)-1) as Address,
Substring(PropertyAddress,charindex(',',PropertyAddress)+1, Len(PropertyAddress)) as Address
from PortfolioProject.dbo.HousingData

Alter Table HousingData
Add PropertySplitAddress NVarchar(255);

Update HousingData
Set  PropertySplitAddress = Substring(PropertyAddress, 1,charindex(',',PropertyAddress)-1) 

Alter Table HousingData
Add PropertySplitCity NVarchar(255);

Update HousingData
Set  PropertySplitCity = Substring(PropertyAddress,charindex(',',PropertyAddress)+1, Len(PropertyAddress)) 

Select *
from PortfolioProject.dbo.HousingData

----Method 2

Select OwnerAddress
from PortfolioProject.dbo.HousingData

Select 
ParseName(Replace(OwnerAddress,',','.'),1),
ParseName(Replace(OwnerAddress,',','.'),2),
ParseName(Replace(OwnerAddress,',','.'),3)
from PortfolioProject.dbo.HousingData

Select 
ParseName(Replace(OwnerAddress,',','.'),3),
ParseName(Replace(OwnerAddress,',','.'),2),
ParseName(Replace(OwnerAddress,',','.'),1)
from PortfolioProject.dbo.HousingData

Alter Table HousingData
Add OwnerSplitAddress NVarchar(255);

Update HousingData
Set  OwnerSplitAddress = ParseName(Replace(OwnerAddress,',','.'),3)

Alter Table HousingData
Add OwnerSplitCity NVarchar(255);

Update HousingData
Set  OwnerSplitCity = ParseName(Replace(OwnerAddress,',','.'),2)

Alter Table HousingData
Add OwnerSplitState NVarchar(255);

Update HousingData
Set  OwnerSplitState = ParseName(Replace(OwnerAddress,',','.'),1)

Select *
from PortfolioProject.dbo.HousingData

----Changing Y and N to Yes and No in Sold as Vacant field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)as SoldAsVacantCount
from PortfolioProject.dbo.HousingData
Group by SoldAsVacant
Order by SoldAsVacant

Select Distinct(SoldAsVacant), Count(SoldAsVacant)as SoldAsVacantCount
from PortfolioProject.dbo.HousingData
Group by SoldAsVacant
Order by 2

Select SoldAsVacant,
(Case When SoldAsVacant = 'Y' then 'Yes'
	When SoldAsVacant = 'N' then 'No'
	Else SoldAsVacant
	End)
From Portfolioproject.dbo.HousingData

Update HousingData
Set SoldAsVacant = (Case When SoldAsVacant = 'Y' then 'Yes'
	When SoldAsVacant = 'N' then 'No'
	Else SoldAsVacant
	End)
From Portfolioproject.dbo.HousingData

Select Distinct(SoldAsVacant), Count(SoldAsVacant)as SoldAsVacantCount
from PortfolioProject.dbo.HousingData
Group by SoldAsVacant
Order by 2

----Remove Duplicate

Select *,
	ROW_NUMBER() Over(
	Partition By 
		ParcelID,
		PropertyAddress,
		SaleDate,
		SalePrice,
		LegalReference
		Order by
			UniqueID) Row_Num
from PortfolioProject.dbo.HousingData
Order By ParcelID

With RowNumCTE as(
Select *,
	ROW_NUMBER() Over(
	Partition By 
		ParcelID,
		PropertyAddress,
		SaleDate,
		SalePrice,
		LegalReference
		Order by
			UniqueID) Row_Num
from PortfolioProject.dbo.HousingData
)
--Order By ParcelID
select *
from  RowNumCTE


With RowNumCTE as(
Select *,
	ROW_NUMBER() Over(
	Partition By 
		ParcelID,
		PropertyAddress,
		SaleDate,
		SalePrice,
		LegalReference
		Order by
			UniqueID) Row_Num
from PortfolioProject.dbo.HousingData
)
--Order By ParcelID
select *
from  RowNumCTE
where Row_Num > 1
Order By PropertyAddress

With RowNumCTE as(
Select *,
	ROW_NUMBER() Over(
	Partition By 
		ParcelID,
		PropertyAddress,
		SaleDate,
		SalePrice,
		LegalReference
		Order by
			UniqueID) Row_Num
from PortfolioProject.dbo.HousingData
)
Delete
from  RowNumCTE
where Row_Num > 1


----Deleting Unued Column

Select *
from PortfolioProject.dbo.HousingData

Alter table PortfolioProject.dbo.HousingData
Drop Column OwnerAddress, TaxDistrict, PropertyAddress


Alter table PortfolioProject.dbo.HousingData
Drop Column SaleDate












