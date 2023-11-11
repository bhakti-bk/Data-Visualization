use classicmodels;
show tables from classicmodels;


select * from customers;
describe customers;
select * from employees;
select * from offices;
select * from orders;
select * from  products;
select * from productlines;
select * from orderdetails;
select * from payments;

select count(customerName) as totl_customer , country from customers
group by country order by totl_customer desc;

# Highest customer from USA, Germany

select count(b.customerNumber) as totl_customer, year(orderDate) as years from 
 orders a join customers b on
a.customerNumber= b.customerNumber group by years;


select sum(quantityOrdered) from orderdetails group by productCode;

# around 1000 order for each productCode, above 100k


select  year(orderDate) as years, sum(quantityOrdered) as totl_order, country 
from orderdetails a join orders b on a.orderNumber= b.orderNumber
join customers c on b.customerNumber= c.customerNumber
group by country, years order by years, totl_order desc;


select  year(orderDate) as years, sum(quantityOrdered) as totl_order
from orderdetails a join orders b on a.orderNumber= b.orderNumber
group by years;

 # order Numbers and sales by years(how many orders came and how much sales)
 
 select year(orderDate) as years, sum(quantityOrdered) as totl_sell, status from orders a 
 join orderdetails b on a.orderNumber= b.orderNumber
 where status = 'shipped' group by years;
 
 # We can find out the % of ordered without shipped and ordered with shipped


select orderNumber from orders where  shippedDate is not null and shippedDate > requiredDate;

# only one order is there 

select orderNumber from orders where  shippedDate is not null and shippedDate < requiredDate;

 # 303 records are there with all null column so totl 304 records but what about 8 records
 # thats not issue of delivering, all orders are delivered at time
 
 # find out top selling product from total 110 products
# 122 customer, 110 product, 312 orders
 

 
select sum(quantityOrdered) as totl_sell, dense_rank() over(order by sum(a.quantityOrdered) desc) as sell_rank,  
 a.productCode,b.productline, b.productName, b.quantityInstock from 
orderdetails a join products b on a.productCode= b.productCode
group by productCode;
 
 
select sum(quantityOrdered) as totl_sell, dense_rank() over(order by sum(b.quantityOrdered) desc) as sell_rank,  
 b.productCode,a.productline, a.productName, a.quantityInstock , year(orderDate) as years from
products a join orderdetails b on a.productCode= b.productCode join orders c on 
b.orderNumber= c.orderNumber group by productCode, years order by years, sell_rank;
 


select d.productName, d.sale2004, d.sale2005,round((d.sale2005-d.sale2004)*100/d.sale2005,2) 
as 'sale_growth(%)',CASE WHEN (d.sale2005 - d.sale2004) > 0 THEN 'Positive Growth' 
WHEN (d.sale2005 - d.sale2004) < 0 THEN 'Negative Growth' ELSE 'No Growth' END AS 'growth_status'
from(select productName, sum(if (year(orderDate)= 2004, QuantityOrdered,0)) as sale2004,
sum(if (year(orderDate)= 2005, QuantityOrdered,0)) as sale2005 
from orders a join orderdetails b on a.orderNumber= b.orderNumber
join products c on b.productCode= c.productCode
group by productName)d;

# lets analyse employees and offices column now. 

select count(distinct(customerName)) as totl_customer, country 
from customers group by country order by totl_customer desc;


select count(distinct(a.customerName)) as totl_customer, a.country as customer_country,
a.city as customer_city , ifnull(c.country, 'no_office') as office_country ,
ifnull(c.city, 'no_office') as office_city from customers a
 join employees b on a.salesRepEmployeeNumber= b.EmployeeNumber join offices c on
 b.officeCode= c.officeCode group by customer_country, customer_city order by totl_customer desc;



select b.firstName as emp_name , a.country,a.city, b.jobTitle,
 count(c.customerName) as totl_customer
from offices a join employees b on
a.officeCode = b.officeCode join customers c 
on b.employeeNumber= c.salesRepEmployeeNumber
group by emp_name order by totl_customer desc;

# USA(3), UK(1), France(1), Japan(1), Australia(1) =7 (total offices)
# From 122 customers, we highest sales from USA and other parts of countries where we 
# dont have offices so we provide them product through shipment but they receive damaged products 
# so we need to do necessary steps.


 # customer has increased from 2003-2004 but decreased in 2005

select  year(orderDate) as years, count(orderNumber) as totl_cancel_order, city, country, 
a.status, a.comments
from orders a join customers b on a.customerNumber= b.customerNumber
where shippedDate is null or status <> 'shipped' and 'Resolved' group by years, country
order by years;


# total orders till now is 326 and from that 14 hold or canceled so left with 304
# In 2005, there are highest cancelled order in USA, one of the reason of decreasing sales 
# which was our largest customer

 
 select productLine, count(distinct(productName)) as totl_product from products a
 join productLine b on a.;
 
 select   productLine, MSRP, priceEach, 
 avg(round((MSRP - priceEach)*100/MSRP,2)) as Discount, year(orderDate) as years from 
 products a join orderdetails b on a.productCode = b.productCode
 join orders c on b.orderNumber = c.orderNumber  
 group by productLine, years order by years;
 
# 38 items

select sum(quantityOrdered*priceEach) as sales from orderdetails;

select sum(quantityOrdered*priceEach) as sales, year(shippedDate) as years
 from orders b join orderdetails a on a.orderNumber= b.orderNumber 
 group by   years;
 
 # Finally the gap is 475294.17 rs(around 4 lakh 75 thousand)
 

select sum(quantityOrdered*priceEach) as sales, year(orderDate) as years, productLine,
b.status from orders b join orderdetails a on a.orderNumber= b.orderNumber join 
 products c on a.productCode= c.productCode
 group by  productLine, years having status= 'shipped';
 
 
select sum(quantityOrdered*priceEach) as sales, year(orderDate) as years, productLine,
b.status from orders b join orderdetails a on a.orderNumber= b.orderNumber join 
 products c on a.productCode= c.productCode
 group by  productLine, years having status= 'shipped' and years= 2005 and 
 productLine = 'Vintage Cars';
 
 # which is Null
 

select max(quantityOrdered*priceEach) as sales, 
year(shippedDate) as years from orders a join orderdetails b 
on a.orderNumber = b.orderNumber group by years;

# count of customer by country yearwise

select distinct(count(a.customerNumber)) as totl_customer, country, year(orderDate) as years 
from customers a join orders b on a.customerNumber= b.customerNumber
group by country, years