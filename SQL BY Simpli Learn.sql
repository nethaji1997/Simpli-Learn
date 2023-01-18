SELECT * FROM spring.softtek_login;

create database triggers;
use triggers;
show tables;

#before insert trigeer
create table customers(
cust_id int, age int, name varchar(30));

delimiter //
create trigger age_verify
before insert on customers
for each row
if new.age<0 then set new.age=0;
end if; //

insert into customers values(101,27,"james"),(102,-40,"ammy"),(103,32,"ben"),(104,-39,"angella");

select * from customers;

truncate table customers;

#after insert trigger

create table customers1(
id int auto_increment primary key, name varchar(40) not null,
email varchar(30), birthdate date);

create table message(
id int auto_increment,
messageId int,
message varchar(300) not null,
primary key(id, messageId));

delimiter //
create trigger 
check_null_dob
after insert on customers1
for each row
begin
if new.birthdate is null then insert into message(messageId, message) values(new.id, concat('Hi ', new.name,' please update dob'));
end if;
end //
delimiter ;

insert into customers1(name, email, birthdate)
values("nancy","nancy@abc.com",null),("ronald","ronalid@xyz.com", "1998-11-16"),
("chris","chros@xyz.com","1997-08-20"),
("alice","alice@anc.com",null);

select * from message;

#before update trigger

create table employees
(emp_id int primary key,
emp_name varchar(25), age int , salary float);

insert into employees values(101, "jimmy", 35, 70000),
(102,"shame",30,55000),(103,"marry",28,62000),(104,"dwayne",37,57000),(105,"sara",32,72000);

delimiter //
create trigger upd_trigger
before update on employees for each row
begin
if new.salary=10000 then set new.salary=85000;
elseif new.salary<10000 then set new.salary=72000;
end if;
end //
delimiter ;

update employees set salary=8000 where emp_id in(101,102,103,104,105);

select * from employees;

# before trigger delete
create table salary(
eid int primary key,
validfrom date not null,
amount float not null);

insert into salary values(101,'2005-05-01', 5000),
(102,"2007-08-01",68000),(103,"2006-09-01",75000);

create table salarydel(
id int primary key auto_increment,
eid int, validfrom date not null,
amount float not null,
deleteddat timestamp default now());

drop trigger salary_delete;
delimiter $$
create trigger salary_delete
before delete on salary
for each row 
begin
insert into salary(eid, validfrom, amount)
values(old.eid, old.validfrom, old.amount);
end$$
delimiter 

delete from salary where eid=102;
select * from salary;

#sub queries

use simplilearn;

select emp_name, dept,salary from employees where sal>(select avg(salary) from employees);
select * from customers;

select * from employees where salary>(select salary from employees where emp_name='john');

use classicmodels;
select * from products;
select * from orderdetails;

select productCode, productname, msrp from products
where productcode in(select productcode from orderdetails
where priceeach<100);

#stored procedure

delimiter &&
create procedure top_player()
begin 
select name, country, goals
from players where goals>6;
end &&
delimiter ;

call top_player();

# stored procedure using IN parameter
delimiter //
create procedure sp_sortBySalary(in var int)
begin
select name, age, salary from emp_details
order by salary desc limit var;
end //
delimiter ;

call sp_sortBySalary(3);

delimiter //
create procedure update_salary(in temp_name varchar(20),in new_salary float)
begin 
update emp_details set salary=new_salary where name=temp_name;
end; //

call update_salary('mary',80000);

# stored procedure using OUT paramter
delimiter //
create procedure sp_CountEmplyoees(out total_emp int)
begin 
select count(name) into total_emp from emp_details
where sex='F';
end; //

call sp_CountEmplyoees(@F_emp);
select @F_emp as female_emps;

#Triggers in SQL

use triggers;

create table student
(st_roll int, age int, name varchar(30), marks float);

delimiter //
create trigger marks_verify
before insert on student 
for each row
if new.marks < 0 then set new.marks=50;
end if; //

insert into student values (501, 10, "nethu", 75.0),(502, 12,"mike", -20.5),(503,13,"dave",90),(504, 10,"jacab",-87);
select * from student;

truncate table student;

drop trigger marks_verify;

# Views in SQL

use classicmodels;
select * from customers;

create view cust_details
as
select customerName, phone, city
from customers;

select * from cust_details;

select * from products;
select * from productlines;

create view product_description as
select productName, quantityinstock, msrp, textdescription 
from products as p inner join productlines as pl
on p.productline=pl.productline;

select * from product_description;

#Rename description
rename table product_description to vehicle_descrption;

# Display views
show full tables
where table_type="VIEW";

#delete view
drop view cust_details;

#windows functions
use sql_intro;
select emp_name, age, dept,sum(salary) over (partition by dept) as total_salary
from emplyoees;
#Row Number
select row_number() over (order by salary) as row_num,
emp_name, salary from employees order by salary;

create table demo(st_id int, st_name varchar(20));
insert into demo values(101,"shane"),(102,"bradly"),(103,"hearth"),(103,"hearth"),(105,"nethu");
select * from demo;

select st_id, st_name, row_number() over
(partition by st_id, st_name order by st_id) as roww_num from demo;

create table demo1(var_a int);
insert into demo1 value(101),(102),(103),(104),(105),(105);

select var_a,
rank() over(order by var_a) as test_rank
from demo1;
#First Value()
select emp_name, age , salary, first_value(emp_name)
over (order by salary desc) as highest_salary from employees;








