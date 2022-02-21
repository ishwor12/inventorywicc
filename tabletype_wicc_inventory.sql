
-- Create the data type
CREATE TYPE typesalesdetails AS TABLE (
	id int primary key identity(1,1),
	master_id int foreign key references salesmaster(id),
	product_id int foreign key references products(products_id),
	quantity int,
	amount decimal(18,2),
	discount_amt decimal(18,2),
	description varchar(500)
	)
GO
