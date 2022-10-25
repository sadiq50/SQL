/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [My Db].[dbo].[nashville housing]



  select * 
  from [My Db].[dbo].[nashville housing]

  -- standardize date format
  
  select saleDate, CONVERT(Date,SaleDate) 
  from [My Db].[dbo].[nashville housing]

  update dbo.[nashville housing]
  set SaleDate = CONVERT(date,SaleDate)

  alter table dbo.[nashville housing]
  add saleDateConverted Date;

    update dbo.[nashville housing]
  set SaleDateConverted = CONVERT(date,SaleDate)

  select saleDateConverted, CONVERT(Date,SaleDate) 
  from [My Db].[dbo].[nashville housing]

  --- populate property address data

  
  select * 
  from [My Db].[dbo].[nashville housing]
--  where propertyaddress is null
order by ParcelID



  select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
  from [My Db].[dbo].[nashville housing] a
  Join [My Db].[dbo].[nashville housing] b
   on a.ParcelID = b. ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
   where a.PropertyAddress is null

   select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.Propertyaddress)
  from [My Db].[dbo].[nashville housing] a
  Join [My Db].[dbo].[nashville housing] b
   on a.ParcelID = b. ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
   where a.PropertyAddress is null

   update a
   set propertyaddress =  isnull(a.PropertyAddress,b.Propertyaddress)
  from [My Db].[dbo].[nashville housing] a
  Join [My Db].[dbo].[nashville housing] b
   on a.ParcelID = b. ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
   where a.PropertyAddress is null

   ---breaking out address into individual columns (Address, city, State) 


  select PropertyAddress
  from [My Db].[dbo].[nashville housing]
--where propertyAddress is null
--order by parcelid


select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress )) as address

  from [My Db].[dbo].[nashville housing]

  
select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress )) as address,
CHARINDEX(',', PropertyAddress )
  from [My Db].[dbo].[nashville housing]


--elemenating the comma
 
 select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress )-1) as address
---CHARINDEX(',', PropertyAddress )
  from [My Db].[dbo].[nashville housing]

   select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress )-1) as address ,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress )+1, LEN(PropertyAddress)) as address 

  from [My Db].[dbo].[nashville housing]


  alter table [My Db].[dbo].[nashville housing]
  add PropertysplitAddress nvarchar(255);

 update [My Db].[dbo].[nashville housing]
 set PropertysplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress )-1);

  alter table [My Db].[dbo].[nashville housing]
  add Propertysplitcity nvarchar(255);

 update [My Db].[dbo].[nashville housing]
 set Propertysplitcity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)
)


select ownerAddress
from [My Db].[dbo].[nashville housing]


select 
--Parsename(owneraddress,1)
Parsename(Replace(owneraddress,',','.'),2)
--Parsename(Replace(owneraddress,',',','),3)
from [My Db].[dbo].[nashville housing]

select *
from [My Db].[dbo].[nashville housing]

--change Y and N to Yes and No in "Sold as vacant" field

select distinct(Soldasvacant)
from [My Db].[dbo].[nashville housing]


select distinct(SoldAsVacant),count(SoldAsVacant)
from [My Db].[dbo].[nashville housing]
Group by SoldAsVacant
order by SoldAsVacant


select SoldAsVacant,
Case when SoldAsVacant = 'Y' Then 'Yes'
	when SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	End
from [My Db].[dbo].[nashville housing]


update [My Db].[dbo].[nashville housing]
set SoldAsVacant= case  when SoldAsVacant = 'Y' Then 'Yes'
	when SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	End 

---remove duplicate
with RowNumCTE AS(
select *,
	Row_number() over(
	Partition By ParcelID,
			     PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order By
				 UniqueID
				)Row_num

from [My Db].[dbo].[nashville housing]
--order by ParcelID
)
--delete* from RowNumCTE
Select* from RowNumCTE
where row_num > 1
order by PropertyAddress


select *
from [My Db].[dbo].[nashville housing]

--delete unused column 

Alter table [My Db].[dbo].[nashville housing]
drop column owneraddress, taxdistrict, propertyaddress


Alter table [My Db].[dbo].[nashville housing]
drop column SaleDate

select *
from [My Db].[dbo].[nashville housing]





























