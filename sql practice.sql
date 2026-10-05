use NovaCartData;
select distinct (count(Customer_ID) ) as Unique_Customers from Customers;

select Customer_Segment,count(*) as typesofCustomers  from Customers
group by Customer_Segment;



SELECT
    Cast(AVG(
        DATEDIFF(HOUR, o.Order_Date, d.Actual_Date) * 1.0
    ) as  decimal(18,0))AS Hours
FROM Orders AS o
JOIN Delivery AS d
    ON o.Order_ID = d.Order_ID;

	select Return_Type, count(*)from Returns
	group by Return_Type ;

	select return_reason,count(*) as total from Returns
	group by Return_Reason
	order by total  desc;

SELECT
    c.Area,
    COUNT(DISTINCT r.Order_ID) AS Total_Refunds
FROM Customers AS c
JOIN Orders AS o
    ON c.Customer_ID = o.Customer_ID
JOIN Returns AS r
    ON o.Order_ID = r.Order_ID
WHERE r.Return_Type = 'Refund'
GROUP BY c.Area
ORDER BY Total_Refunds DESC;












select c.Area,count(Distinct o.Order_ID) as total_Replacement  from Customers as c
join Orders as o
on c.Customer_ID= o.Customer_ID
join Returns as r
on o.Order_ID=r.Order_ID
where r.Return_Type='Replacement'
group by area 
order by total_Replacement

SELECT  
    w.Warehouse_Name, 
    COUNT(DISTINCT o.Order_ID) AS Total_Orders,
    COUNT(DISTINCT CASE 
        WHEN r.Return_Type = 'Refund' THEN r.Order_ID 
    END) AS Total_Returns
FROM Orders AS o
JOIN Warehouses AS w 
    ON o.Warehouse_ID = w.Warehouse_ID
LEFT JOIN Returns AS r
    ON o.Order_ID = r.Order_ID
GROUP BY w.Warehouse_Name
ORDER BY Total_Orders DESC;



select p.Category,p.Sub_Category
,  count(distinct o.order_id) as total  from Orders o
join Products p
on o.Product_ID=p.Product_ID
join  Refunds r
on o.Order_ID=r.Order_ID
group by p.Category,p.Sub_Category
order by total desc; 


select distinct(order_status) from Orders;

select sum(order_value)as total from  orders
where Order_Status='Delivered'


select zone, cast (sum(o.order_value)as decimal(18,2))as total from  orders o
left join Customers c
on o.Customer_ID=c.Customer_ID
where Order_Status='Delivered'
group by zone
order by total desc;










select p.Category,count(distinct o.order_id)as total from Orders  as o
 join Products  as p
 on o.product_id=p.product_id
 group by Category
 order by total desc;

 select *  from Return_Costs;

 SELECT
    p.Category,

    SUM(
        ISNULL(rc.Return_Shipping_Cost, 0)
        + ISNULL(rc.Replacement_Cost, 0)
        + ISNULL(rc.Processing_Cost, 0)
        + ISNULL(rc.Restocking_Cost, 0)
    ) AS Total_Return_Cost,

    SUM(ISNULL(rf.Refund_Amount, 0)) AS Total_Refund_Amount

FROM Orders AS o

JOIN Products AS p
    ON o.Product_ID = p.Product_ID

LEFT JOIN Return_Costs AS rc
    ON o.Order_ID = rc.Order_ID

LEFT JOIN Refunds AS rf
    ON o.Order_ID = rf.Order_ID

GROUP BY p.Category

ORDER BY Total_Return_Cost DESC;

SELECT 
    COUNT(*) AS Zero_Replacement_Rows
FROM Return_Costs
WHERE Replacement_Cost = 0;


select c.zone, count(distinct o.order_id)from Customers c
 join Orders o
on c.Customer_ID=o.Customer_ID
join Returns r
on o.Order_ID=r.Order_ID

group by Zone
	SELECT
    FORMAT(o.Order_Date, 'MMM') AS Month,
    SUM(o.Order_Value) AS Total_Order_Value,
    SUM(ISNULL(rf.Refund_Amount, 0)) AS Total_Refund,
    SUM(ISNULL(rc.Return_Shipping_Cost, 0)) AS Return_Shipping_Cost,
    SUM(ISNULL(rc.Replacement_Cost, 0)) AS Replacement_Cost,
    SUM(ISNULL(rc.Processing_Cost, 0)) AS Processing_Cost,
    SUM(ISNULL(rc.Restocking_Cost, 0)) AS Restocking_Cost,
    SUM(
        o.Order_Value
        - ISNULL(rf.Refund_Amount, 0)
        - ISNULL(rc.Return_Shipping_Cost, 0)
        - ISNULL(rc.Replacement_Cost, 0)
        - ISNULL(rc.Processing_Cost, 0)
        - ISNULL(rc.Restocking_Cost, 0)
    ) AS Net_Revenue
FROM Orders AS o
LEFT JOIN Refunds AS rf
    ON o.Order_ID = rf.Order_ID
LEFT JOIN Return_Costs AS rc
    ON o.Order_ID = rc.Order_ID
WHERE o.Order_Status = 'Delivered'
GROUP BY
    FORMAT(o.Order_Date, 'MM'),
    FORMAT(o.Order_Date, 'MMM')
ORDER BY
    FORMAT(o.Order_Date, 'MM');





	

select c.Zone,SUM(o.Order_Value) AS Total_Order_Value,
    SUM(ISNULL(r.Refund_Amount, 0)) AS Total_Refund,
    SUM(ISNULL(rc.Return_Shipping_Cost, 0)) AS Return_Shipping_Cost,
    SUM(ISNULL(rc.Replacement_Cost, 0)) AS Replacement_Cost,
    SUM(ISNULL(rc.Processing_Cost, 0)) AS Processing_Cost,
    SUM(ISNULL(rc.Restocking_Cost, 0)) AS Restocking_Cost,
	cast (sum(Order_Value-isnull(refund_amount,0)-isnull(Return_Shipping_Cost,0) -isnull(Replacement_Cost,0)-isnull(Processing_Cost,0)-isnull(Restocking_Cost,0))as decimal(18,0))as net_amount from Customers c
join Orders o
on c.Customer_ID=o.Customer_ID
left join Refunds r
on o.Order_ID=r.Order_ID
left join Return_Costs rc
on o.Order_ID=rc.Order_ID
where o.Order_Status='Delivered'
group by Zone
order by  net_amount desc;


select courier, count(*) from Delivery
group by Courier
having count(*)>150000



WITH MonthlyRevenue AS
(
    SELECT
        FORMAT(o.Order_Date, 'MMM') AS Month,
        FORMAT(o.Order_Date, 'MM') AS Month_No,

        SUM(
            o.Order_Value
            - ISNULL(rf.Refund_Amount, 0)
            - ISNULL(rc.Return_Shipping_Cost, 0)
            - ISNULL(rc.Replacement_Cost, 0)
            - ISNULL(rc.Processing_Cost, 0)
            - ISNULL(rc.Restocking_Cost, 0)
        ) AS Net_Revenue

    FROM Orders AS o

    LEFT JOIN Refunds AS rf
        ON o.Order_ID = rf.Order_ID

    LEFT JOIN Return_Costs AS rc
        ON o.Order_ID = rc.Order_ID

    WHERE o.Order_Status = 'Delivered'

    GROUP BY
        FORMAT(o.Order_Date, 'MM'),
        FORMAT(o.Order_Date, 'MMM')
),
RankedMonths AS
(
    SELECT
        Month,
        Net_Revenue,
        DENSE_RANK() OVER(
            ORDER BY Net_Revenue DESC
        ) AS Rank_No
    FROM MonthlyRevenue
)
SELECT
    Month,
    Net_Revenue
FROM RankedMonths
WHERE Rank_No = 2;



SELECT
    Distinct Customer_ID,
    FIRST_VALUE(Order_ID) OVER(
        PARTITION BY Customer_ID
        ORDER BY Order_Date
    ) AS [First Order]
FROM Orders;


with x as (
select order_id,order_value ,dense_rank()over(order by order_value desc)  as rnk
from orders


)select * from x
where rnk=2;

with ctc as(
select   distinct customer_id ,count(order_id) over(partition by customer_id )as total_order from Orders),
highest as (
select Customer_ID ,total_order ,DENSE_RANK()over(order by total_order desc)as highest_total_order from ctc
)
select* from highest
where highest_total_order=1;




with xy as (

select customer_id,order_id ,order_date,lag(order_date) over (partition by customer_id order by order_date)as privious_date from Orders),
pri as(
select datediff(day,privious_date,order_date) as days from xy
 where privious_date is not null
)
select cast(AVG(days*1.0) as decimal(18,1) )as average_orderdays from pri;

 
select Missing_Item_Type , count(*) from Missing_Items
group by Missing_Item_Type;


select r.Return_Type,count(*) as total  from orders as  o
join missing_Items as  m
on o.order_id=m.Order_ID
join Returns as r
on o.Order_ID=r.Order_ID
group by r.Return_Type


SELECT
    m.Missing_Item_Flag,
    COUNT(DISTINCT r.Order_ID) AS Returned_Orders
FROM Missing_Items m
JOIN Returns r
    ON m.Order_ID = r.Order_ID
GROUP BY m.Missing_Item_Flag;

select count(*) from Missing_Items

select *  from Delivery;

select Delivery_Status ,count(*)as total  from Delivery
group by Delivery_Status;


select o.* ,d.* from orders o
join Delivery as d
on o.Order_ID=d.Order_ID
where Delivery_Status='Not Delivered';


with ct as (
select Warehouse_Name,  count(o.order_id)as total_refunds from Orders as  o
join Refunds as r
on o.order_id=r.order_id
 join warehouses w
on o.Warehouse_ID=w.Warehouse_ID
group by Warehouse_Name
),ft as(
select * ,dense_rank()over(order by total_refunds desc) as rnk from ct)
select * from ft
where rnk=2;

select Payment_Method, sum(order_value)total from Orders
group by Payment_Method
order by total desc




SELECT
    p.Category,
    r.Return_Reason,
    COUNT(*) AS Total_Returns,
    CAST(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (PARTITION BY p.Category)
        AS DECIMAL(10,2)
    ) AS Reason_Percentage
FROM Orders o
JOIN Products p
    ON o.Product_ID = p.Product_ID
JOIN Returns r
    ON o.Order_ID = r.Order_ID
GROUP BY
    p.Category,
    r.Return_Reason
ORDER BY
    p.Category,
    Total_Returns DESC;


	SELECT
    d.Delivery_Status,

    COUNT(DISTINCT o.Order_ID) AS Total_Orders,

    COUNT(DISTINCT r.Order_ID) AS Returned_Orders,
    CAST(
        COUNT(DISTINCT r.Order_ID) * 100.0 /
        NULLIF(COUNT(DISTINCT o.Order_ID),0)
        AS DECIMAL(10,2)
    ) AS Return_Rate
FROM Orders o
JOIN Delivery d
    ON o.Order_ID = d.Order_ID
LEFT JOIN Returns r
    ON o.Order_ID = r.Order_ID
GROUP BY d.Delivery_Status
ORDER BY Return_Rate DESC;


SELECT TOP 20
    p.Product_ID,
    p.Product_Name,
    p.Category,

    COUNT(DISTINCT r.Order_ID) AS Returned_Orders,

    CAST(SUM(ISNULL(rf.Refund_Amount,0)) AS DECIMAL(18,2))
        AS Refund_Amount,

    CAST(
        SUM(
            ISNULL(rc.Return_Shipping_Cost,0) +
            ISNULL(rc.Replacement_Cost,0) +
            ISNULL(rc.Processing_Cost,0) +
            ISNULL(rc.Restocking_Cost,0)
        )
        AS DECIMAL(18,2)
    ) AS Return_Cost,

    CAST(SUM(ISNULL(rc.Recoverable_Amount,0)) AS DECIMAL(18,2))
        AS Recoverable_Amount,

    CAST(
        SUM(ISNULL(rf.Refund_Amount,0))
        +
        SUM(
            ISNULL(rc.Return_Shipping_Cost,0) +
            ISNULL(rc.Replacement_Cost,0) +
            ISNULL(rc.Processing_Cost,0) +
            ISNULL(rc.Restocking_Cost,0)
        )
        -
        SUM(ISNULL(rc.Recoverable_Amount,0))
        AS DECIMAL(18,2)
    ) AS Estimated_Business_Loss

FROM Products p
JOIN Orders o
    ON p.Product_ID = o.Product_ID
JOIN Returns r
    ON o.Order_ID = r.Order_ID
LEFT JOIN Refunds rf
    ON o.Order_ID = rf.Order_ID
LEFT JOIN Return_Costs rc
    ON o.Order_ID = rc.Order_ID
GROUP BY
    p.Product_ID,
    p.Product_Name,
    p.Category
ORDER BY Estimated_Business_Loss DESC;


SELECT
    r.Return_Condition,

    COUNT(*) AS Total_Returns,

    CAST(AVG(rc.Recoverable_Amount) AS DECIMAL(18,2))
        AS Avg_Recoverable_Amount,

    CAST(SUM(rc.Recoverable_Amount) AS DECIMAL(18,2))
        AS Total_Recoverable_Amount,

    CAST(AVG(ISNULL(rf.Refund_Amount,0)) AS DECIMAL(18,2))
        AS Avg_Refund_Amount
FROM Returns r
LEFT JOIN Refunds rf
    ON r.Order_ID = rf.Order_ID
JOIN Return_Costs rc
    ON r.Order_ID = rc.Order_ID

GROUP BY r.Return_Condition
ORDER BY Total_Returns DESC;



	 with orderddata as(
	 select Customer_id,Order_ID as previous_Order_id,order_date as previous_order_date,
	 lead(order_id) over(partition by customer_id order by order_date) 
	 as next_order_id,lead(order_date)over(partition by customer_id order by order_date)
	 as next_order_date from orders)
	 select * ,datediff( day,previous_order_date,next_order_date) as Days_between from orderddata
	 where next_order_id is  not null 
	 AND datediff( day,previous_order_date,next_order_date)<=30 
	 order by Days_between desc;

	 with returndata as(
	 select o.Customer_ID as customer_id, o.order_id as perviouorder_id,  
	 lead(o.Order_ID)over(partition by o.customer_id order by r.return_date) as next_order_id ,
	 r.Return_Date as first_return_date,
	 lead(r.Return_Date)over(partition by o.customer_id order by return_date) as Second_return_date from orders o
	 join Returns r
	 on o.Order_ID=r.Order_ID)
	 select *, datediff(day ,first_return_date,Second_return_date) as return_days from returndata
	 where Second_return_date is not null 
	 and datediff(day ,first_return_date,Second_return_date)<=30
	 order by return_days desc;


	 --E-commerce company identify karna chahti hai ki kaunse customers ne consecutive orders return kiye

	 with returndata as (
	 select Customer_ID,o.Order_ID ,Order_Date,r.Return_Status,
	 lag(o.order_id)over(partition by customer_id order by o.order_date )  as previous_orderId ,
	lag(Return_Status)over(partition by customer_id order by o.order_date)as previous_return  from Orders o
	 join Returns r
	 on o.Order_ID=r.Order_ID)
	 select * from returndata
	 where Return_Status ='Returned'
	 and previous_return ='Returned' 

with orderdata as (
	select Customer_ID,order_id, order_value, lag(order_value,1)over(partition by Customer_id order by order_date) as last_order ,
     LAG(Order_Value, 2) OVER( PARTITION BY Customer_ID order by order_date)AS before_last_order,
	 ROW_NUMBER() over(partition by Customer_id order by order_date) as rnk  from orders 
	 ) 
	 select *  from
	orderdata
	where rnk<=3
	AND before_last_order < last_order
  AND last_order < Order_Value;



  with rn as (
  select Customer_id ,order_id ,Order_Value  ,lag(Order_Value,1) over(partition by customer_id  order by order_date) last1_value ,
  lag(Order_Value,2)over(partition by customer_id order by order_date)as last2value ,
   LAG(Order_Value, 3) OVER
        (
            PARTITION BY Customer_ID
            ORDER BY Order_Date
        ) AS last3_value,ROW_NUMBER ()over(partition by customer_id order by order_date ) as rnk
  from Orders)
  select * from  rn
  where rnk>=4
   AND last3_value > last2value
  AND last2value > last1_value
  AND Order_Value > last1_value;








  with sg as (
  select p.Category, Product_Name ,sum(order_value ) as total_value , 
  row_number()over(partition by category order by sum(order_value) desc ) as rnk from Orders o
  join Products p
  on o.Product_ID=p.Product_ID
  GROUP By  p.Category, p.Product_Name)
select  * from sg
 where rnk<= 2;
 

 with g as(
 select Customer_ID ,order_id,
 row_number() over(partition by Customer_id order by order_date desc) as rn from Orders)
 select * from g
 where rn=1;

 with ct as(
 select Category,Product_Name,Product_Price, 
 row_number()over(partition by category order by product_price desc)as rnk from Products)
 select * from ct
 where rnk=1;  


 with ct as(
 select Customer_ID,order_value,
 DENSE_RANK()over(order by order_value desc) as rn from Orders)
 select * from ct
 where rn=2
 
 SELECT MAX(Order_Value), Order_ID
FROM Orders;
 
select c.Customer_ID from  Customers c
left join orders o
on c.Customer_ID=o.Customer_ID
where o.Customer_ID is null;

WITH ct AS (
    SELECT
        o.Customer_ID,
        COUNT(DISTINCT o.Order_ID) AS Total_Orders,
        COUNT(DISTINCT r.Order_ID) AS Returned_Orders
    FROM Orders o
    LEFT JOIN Returns r
        ON o.Order_ID = r.Order_ID
    GROUP BY o.Customer_ID
    HAVING COUNT(DISTINCT o.Order_ID) >= 5
       AND COUNT(DISTINCT r.Order_ID) >= 2
)
SELECT
    Customer_ID,
    Total_Orders,
    Returned_Orders,
    CAST(
        Returned_Orders * 100.0 / NULLIF(Total_Orders, 0)
        AS DECIMAL(10,2)
    ) AS Return_Rate
FROM ct
WHERE Returned_Orders * 100.0 / NULLIF(Total_Orders, 0) > 30
ORDER BY Return_Rate DESC;



with t as(
select Customer_ID, order_id ,row_number()over(partition by customer_id order by order_date) as rnk from Orders)
select customer_id,order_id from t
where rnk=2;


with ab as(
select Customer_ID ,count(distinct o.order_id)as total_order ,
count(distinct r.order_id)as total_refund_orders ,sum(Order_Value)as total_order_value,sum(r.Refund_Amount) as total_refundamount from orders o
left join Refunds r
on o.order_id=r.order_id
group by Customer_ID
having count(o.order_id)>=5
and count(r.Order_ID)>=2
and sum(order_value)>=50000)
select * , cast (total_refundamount*100/nullif(total_order_value,0) 
as decimal(18,2)) as refund_P from ab
where  cast (total_refundamount*100/nullif(total_order_value,0) 
as decimal(18,2))>10




WITH ctc AS (
    SELECT 
        FORMAT(Order_Date, 'MMM') AS months,
        MONTH(Order_Date) AS month_no,
        SUM(Order_Value) AS revenue
    FROM Orders
    GROUP BY 
        FORMAT(Order_Date, 'MMM'),
        MONTH(Order_Date)
),
ctc2 AS (
    SELECT 
        months,
        month_no,
        revenue,
        LAG(revenue) OVER (ORDER BY month_no) AS previous_Revenue
    FROM ctc
)
SELECT 
    months,
    revenue,
    previous_Revenue,
    CAST(
        (revenue - previous_Revenue) * 100.0 /
        NULLIF(previous_Revenue, 0)
        AS DECIMAL(18,2)
    ) AS Growth
FROM ctc2
ORDER BY month_no;




select Delivery_Status,count(*)  from Delivery
group by Delivery_Status

select Courier, count(*) as total ,
count(  case  when Delivery_Status='Delayed' then 1 end ) as deley_delivers from Delivery
group by Courier
order by deley_delivers desc