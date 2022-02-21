create table users
(users_id int primary key identity(1,1),
fullname varchar(100),
loginname varchar (100),
email varchar(50),
phone varchar(12),
address varchar(50)
)
alter table users add password varchar(200)
create table products(
products_id int primary key identity(1,1),
name varchar(100),
code varchar(20),
category_id int foreign key references category(id),
purchase_price decimal(10,2),
sales_price decimal(10,2),
descriptions varchar(500),
created_user_id int foreign key references users(users_id),
modified_user_id int foreign key references users(users_id),
created_date datetime ,
modified_date date,
)
create table category(
id int primary key identity(1,1),
code varchar(10),
name varchar(50)
)
create  table salesmaster(
id int primary key identity(1,1),
date date,
totaL_AMOUNT decimal(18,2),
discount_amt decimal(18,2),
vat_amt decimal(18,2),
description varchar(500),
created_user_id int foreign key references users(users_id),
modified_user_id int foreign key references users(users_id),
created_date datetime ,
modified_date date
invoice_no int
)
alter table salesmaster add invoice_no int
create table salesdetails(
id int primary key identity(1,1),
master_id int foreign key references salesmaster(id),
product_id int foreign key references products(products_id),
quantity int,
amount decimal(18,2),
discount_amt decimal(18,2),
description varchar(500)
)
select * from users

-- Create the data type
create  type typesalesdetail as Table
(
	id int ,
	master_id int ,
	product_id int,
	quantity int,
	amount decimal(18,2),
	discount_amt decimal(18,2),
	description varchar(500)
	)
GO


 create procedure spaddupdateusers(
 @users_id int ,
@fullname varchar(100),
@loginname varchar (100),
@email varchar(50),
@phone varchar(12),
@address varchar(50),
@password varchar(20)
 )
 as
 begin
 -- for insert operation only insert into users values(@fullname,@logisnname,@email,@phone,address,password)
 --for insert update
 if (@users_id<=0) -- id less than 0 insert else update
begin
 insert into users(fullname,loginname,email,phone,address,password)
 values(@fullname,@loginname,@email,@phone,@address,@password)
 end
 else
 begin
 update users set fullname=@fullname,email=@email,phone=@phone,address=@address,password=@password 
 where users_id=@users_id
 -- not login name because we dont give user to chANGE LOGIN name.
 end
 end
 create procedure spinsertupdatesales
@id int ,
@date date,
@totaL_AMOUNT decimal (18,2),
@discount_amt decimal(18,2),
@vat_amt decimal(18,2),
@description varchar(500),
@created_user_id int,
@modified_user_id int,
@created_date datetime ,
@modified_date date,
@salesdetails as typedetail 
as begin
if(@id<=0)
begin transaction
insert into salesmaster(date,totaL_AMOUNT, discount_amt, vat_amt,description,created_user_id,created_date,invoice_no)
values(@date,@totaL_AMOUNT,@discount_amt, @vat_amt,@description ,@created_user_id,@created_date,@invoice_no)
end
else
begin
set @id=SCOPE_IDENTITY();
insert into salesdetails(master_id,product_id,quantity,amount,discount_amt,description)
select @id,product_id,quantity,amount,discount_amt,description from @salesdetails
end
Else 
begin
update salesmaster(totaL_AMOUNT=@totaL_AMOUNT, discount_amt=@discount_amt, vat_amt=@vat_amt,description=@description,modified_user_id=@modified_user_id,modified_date=@modified_date)
values(@totaL_amount,@discount_amt, @vat_amt,@description ,@modified_user,@modified_date,@invoice_no)
where id=@id
end
end
