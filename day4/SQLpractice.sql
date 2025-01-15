select fullName=concat (firstname,lastname ) from  Person.Person over(); 

select JobTitle from HumanResources.Employee

select Rate from HumanResources.EmployeePayHistory

select AverageRate= avg(Rate) from HumanResources.EmployeePayHistory

select firstname,lastname,JobTitle,eph.Rate,AverageRate= avg(eph.Rate) over()
from  Person.Person pp inner join HumanResources.Employee he on
pp.BusinessEntityID = he.BusinessEntityID inner join HumanResources.EmployeePayHistory eph on eph.BusinessEntityID = pp.BusinessEntityID inner join 
HumanResources.EmployeePayHistory ph on ph.BusinessEntityID = he.BusinessEntityID group by firstname,lastname,JobTitle,eph.Rate
 

 select avg(Rate) from HumanResources.EmployeePayHistory;


 select ProductName=pp.name ,
pp.ListPrice ,
 ProductSubcategoryName =  psb.Name ,
 ProductCategoryName= pc.name ,
 AvgPriceByCategory = avg(pp.ListPrice) over(partition by pc.Name),
 AvgPriceByCategoryAndSubcategory = avg(ListPrice ) over(partition by pc.Name,psb.Name),
 ProductVsCategoryDelta = pp.ListPrice - avg(pp.ListPrice) over(partition by pc.Name)
 from Production.Product pp inner join 
 Production.ProductSubcategory  psb on psb.ProductSubcategoryID = pp.ProductSubcategoryID inner join Production.ProductCategory pc 
 on pc.ProductCategoryID = psb.ProductCategoryID;


SELECT 
  ProductName = A.Name,
  A.ListPrice,
  ProductSubcategory = B.Name,
  ProductCategory = C.Name,
  AvgPriceByCategory = AVG(A.ListPrice) OVER(PARTITION BY C.Name),
  AvgPriceByCategoryAndSubcategory = AVG(A.ListPrice) OVER(PARTITION BY C.Name, B.Name),
  ProductVsCategoryDelta = A.ListPrice - AVG(A.ListPrice) OVER(PARTITION BY C.Name)

FROM Production.Product A
  JOIN Production.ProductSubcategory B
    ON A.ProductSubcategoryID = B.ProductSubcategoryID
  JOIN Production.ProductCategory C
    ON B.ProductCategoryID = C.ProductCategoryID;

	-- rownumber


	select ProductName = pp.Name,pp.ListPrice , ProductSubcategoryName=psb.Name  , ProductCategoryNAme = pcb.Name ,
	PriceRank = ROW_NUMBER() OVER( order by pp.ListPrice  desc )  ,
	CategoryPriceRank = ROW_NUMBER() OVER(PARTITION BY pcb.name order by pp.ListPrice desc),
	Top5PriceInCategory =
	case 
	when  ROW_NUMBER() OVER(partition by pcb.name order by pp.ListPrice desc ) < = 5 then 'yes'
	else 'NO'
	end
	from Production.Product  pp inner join 
	 Production.ProductSubcategory psb on psb.ProductSubcategoryID = pp.ProductSubcategoryID inner join Production.ProductCategory pcb on 
	 pcb.ProductCategoryID = psb.ProductCategoryID ;


	 -- rank and dense rank
	 	select ProductName = pp.Name,pp.ListPrice , ProductSubcategoryName=psb.Name  , ProductCategoryNAme = pcb.Name ,
	PriceRank = ROW_NUMBER() OVER( order by pp.ListPrice  desc )  ,
	CategoryPriceRank = ROW_NUMBER() OVER(PARTITION BY pcb.name order by pp.ListPrice desc),
	CategoryPriceRankWithRank =  rank() OVER(PARTITION BY pcb.name order by pp.ListPrice desc),
	CategoryPriceRankWithdenseRank =  dense_rank() OVER(PARTITION BY pcb.name order by pp.ListPrice desc)
 	from Production.Product  pp inner join 
	 Production.ProductSubcategory psb on psb.ProductSubcategoryID = pp.ProductSubcategoryID inner join Production.ProductCategory pcb on 
	 pcb.ProductCategoryID = psb.ProductCategoryID ;


	 --sub queries

	 select  PurchaseOrderID,VendorID,OrderDate,TaxAmt,Freight,TotalDue from (
	 select  PurchaseOrderID,VendorID,OrderDate,TaxAmt,Freight,TotalDue , 
	 rank = ROW_NUMBER() OVER(PARTITION BY VendorID ORDER BY TotalDue DESC) 
	 from Purchasing.PurchaseOrderHeader ) a
	 
	 where rank <= 3 
	 ;

	  select  PurchaseOrderID,VendorID,OrderDate,TaxAmt,Freight,TotalDue from (
	 select  PurchaseOrderID,VendorID,OrderDate,TaxAmt,Freight,TotalDue , 
	 rank = dense_rank() OVER(PARTITION BY VendorID ORDER BY TotalDue DESC) 
	 from Purchasing.PurchaseOrderHeader ) a
	 
	 where rank <= 3 
	 ;


	 --rows between and
	 select OrderMonth,OrderYear,SubTotal,
	 Rolling3MonthTotal = sum(SubTotal) over( order by OrderYear,ordermonth rows between 2 preceding  and current row ),
	 MovingAvg6Month = AVG(SubTotal) over (order by orderyear , ordermonth rows between 6  preceding and  1 preceding),
	 MovingAvgNext2Months = AVG(subtotal) over(order by orderyear, ordermonth rows between current row and 2 following )
	 from (
	 select OrderMonth =  Month(orderDate) ,
	 OrderYear =year(orderDate) ,
	 SubTotal = sum(subtotal) 
	 from Purchasing.PurchaseOrderHeader group by Month(orderDate) ,year(orderDate)) a ;


	 --scalar subqueries


	 select BusinessEntityID,JobTitle,VacationHours,
	 MaxVacationHours = max(VacationHours)
	 from
	 HumanResources.Employee group by BusinessEntityID,JobTitle,VacationHours order by JobTitle;

	 SELECT
	   BusinessEntityID
      ,JobTitle
      ,VacationHours
	  ,MaxVacationHours = (SELECT MAX(VacationHours) FROM HumanResources.Employee)

FROM HumanResources.Employee;

SELECT
	   BusinessEntityID
      ,JobTitle
      ,VacationHours,
	   MaxVacationHours = (SELECT MAX(VacationHours) FROM HumanResources.Employee),
percent_individual_employees = ((VacationHours*1.0) / (SELECT MAX(VacationHours) FROM HumanResources.Employee) ) from
HumanResources.Employee where   ((VacationHours*1.0) / (SELECT MAX(VacationHours) FROM HumanResources.Employee) ) <= 0.8 ;

--correlate sub queries

	select PurchaseOrderID,VendorID,OrderDate,TotalDue,
	NonRejectedItems = (select count(*) from Purchasing.PurchaseOrderDetail b where 
	b.PurchaseOrderID = a.PurchaseOrderID and b.RejectedQty=0)
	from Purchasing.PurchaseOrderHeader a ;

	select PurchaseOrderID,VendorID,OrderDate,TotalDue,
	NonRejectedItems = (select count(*) from Purchasing.PurchaseOrderDetail b where 
	b.PurchaseOrderID = a.PurchaseOrderID and b.RejectedQty=0),
	MostExpensiveItem = (
	select max(c.UnitPrice) from Purchasing.PurchaseOrderDetail c where c.PurchaseOrderID = a.PurchaseOrderID  
	)
	from Purchasing.PurchaseOrderHeader a ;

	select * from Purchasing.PurchaseOrderDetail;



	--exist and not exist

	select * from Purchasing.PurchaseOrderDetail;

	select * from Purchasing.PurchaseOrderHeader A 

	where Exists(
	select 1
	from
	Purchasing.PurchaseOrderDetail B where B.OrderQty > 500 and B.UnitPrice > 50 and B.PurchaseOrderDetailID = A.PurchaseOrderID
	)
	order by 1 desc
	

	select * from Purchasing.PurchaseOrderHeader A 
	where Not Exists(
	select 1
	from
	Purchasing.PurchaseOrderDetail B where  B.RejectedQty > 0 and 
	B.PurchaseOrderDetailID = A.PurchaseOrderID
	)
	order by 1 desc


	select * from Purchasing.PurchaseOrderDetail where PurchaseOrderID = 4012



	-------------------------------------------------------------
	--pivot table -----------------
	--Pivot function  helps to transpose rows values into column which will give the detailed summarised report
	--Using PIVOT, write a query against the HumanResources.Employee table

	--that summarizes the average amount of vacation time for Sales Representatives, Buyers, and Janitors.
--	pivot syntax
	--select <columns> from
	--(
	--	<source_query>	
--	)
--	pivot(
--	<aggr_function><aggr_column> for <spreading_column> in (<spreading_elements>)
--	)
	----------------------------------------------------------------


	select * from (select JobTitle,
VacationHours from HumanResources.Employee ) A pivot (avg(vacationHours) for JobTitle in 
	([Sales Representative],[Buyer],[Janitor])) B


	--Modify your query from Exercise 1 such that the results are broken out by Gender. Alias the Gender field as "Employee Gender" in your output.


		select Employee_gender = gender ,
		[Sales Representative],
		[Buyer],
		[Janitor]
		from (select JobTitle,
VacationHours,gender from HumanResources.Employee ) A pivot (avg(vacationHours) for JobTitle in 
	([Sales Representative],[Buyer],[Janitor])) B


	---------------------------------------------------------------------------------------

	--sub query problem and will solve this problem in cte's

	
	 ---------------------------------------------------------------------------------------


	 select * from sales.SalesOrderHeader;


	-- Select the order month and the top 10 total sales amount for that month from subquery A
-- Also select the top 10 total sales amount for the previous month from subquery B
select 
    A.ordermonth, -- Current month
    A.top10total, -- Total sales of top 10 orders in the current month
    previous_month_total = B.top10total -- Total sales of top 10 orders in the previous month
from
    (
        -- Subquery A: Calculate the top 10 total sales for each month
        select 
            ordermonth,
            top10total = sum(TotalDue) -- Sum of TotalDue for top 10 orders
        from
            (
                -- Select the order date, total due, and calculate the month for each order
                -- Also, rank the orders within each month based on TotalDue in descending order
                select 
                    orderDate,
                    TotalDue,
                    ordermonth = DATEFROMPARTS(YEAR(orderDate), month(orderDate), 1), -- Get the year and month
                    orderRank = ROW_NUMBER() over (partition by DATEFROMPARTS(YEAR(orderDate), month(orderDate), 1) order by TotalDue desc) -- Rank orders by TotalDue
                from 
                    sales.SalesOrderHeader
            ) x
        where orderRank <= 10 -- Filter to keep only top 10 orders per month
        group by ordermonth
    ) A
left join
    (
        -- Subquery B: Calculate the top 10 total sales for each month (previous month calculation)
        select 
            ordermonth,
            top10total = sum(TotalDue) -- Sum of TotalDue for top 10 orders
        from
            (
                -- Select the order date, total due, and calculate the month for each order
                -- Also, rank the orders within each month based on TotalDue in descending order
                select 
                    orderDate,
                    TotalDue,
                    ordermonth = DATEFROMPARTS(YEAR(orderDate), month(orderDate), 1), -- Get the year and month
                    orderRank = ROW_NUMBER() over (partition by DATEFROMPARTS(YEAR(orderDate), month(orderDate), 1) order by TotalDue desc) -- Rank orders by TotalDue
                from 
                    sales.SalesOrderHeader
            ) x
        where orderRank <= 10 -- Filter to keep only top 10 orders per month
        group by ordermonth
    ) B 
on A.ordermonth = DATEADD(MONTH, 1, B.ordermonth) -- Join current month with the previous month
order by 1 -- Order the result by month


----------------------------------------------------------------------------------------------------------------------------------------------------

-- CTE code for above sql solution

--------------------------------------------------------------------------------------------------------------------------------------------------


with sales as (

 select 
                    orderDate,
                    TotalDue,
                    ordermonth = DATEFROMPARTS(YEAR(orderDate), month(orderDate), 1), -- Get the year and month
                    orderRank = ROW_NUMBER() over (partition by DATEFROMPARTS(YEAR(orderDate), month(orderDate), 1) order by TotalDue desc) -- Rank orders by TotalDue
                from 
                    sales.SalesOrderHeader
),

top10 as (
 select 
            ordermonth,
            top10total = sum(TotalDue) -- Sum of TotalDue for top 10 orders
        from
           sales
        where orderRank <= 10 -- Filter to keep only top 10 orders per month
        group by ordermonth
)

select  
	A.ordermonth, -- Current month
    A.top10total, -- Total sales of top 10 orders in the current month
    previous_month_total = B.top10total -- Total sales of top 10 orders in the previous month

	from top10 A left join top10 B on A.ordermonth = DATEADD(month,1,B.ordermonth)

	order by 1



	-------------------------------------------------------------------------------------------------------------------------------

	--Recursive CTEs

--	Exercise 1


--Use a recursive CTE to generate a list of all odd numbers between 1 and 100.

--Hint: You should be able to do this with just a couple slight tweaks to the code from our first example in the video.


with NumberSeries as (
	select 1 as myNumber 

	UNION all

	select myNumber+2 from 
	NumberSeries where myNumber<99
)

select myNumber from NumberSeries


--Exercise 2


--Use a recursive CTE to generate a date series of all FIRST days of the month (1/1/2021, 2/1/2021, etc.) from 1/1/2020 to 12/1/2029.

--Hints:

--Use the DATEADD function strategically in your recursive member.

--You may also have to modify MAXRECURSION.



with dateSeries as (

select cast('1/1/2021' as date) as mydate

UNION all

select DATEADD(month,1,mydate) from dateSeries where mydate < cast('12/1/2029' as date)
)

select mydate from dateSeries option(MAXRECURSION 120)