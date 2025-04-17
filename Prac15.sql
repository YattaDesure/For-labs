create table deletedCustomers
(
	CustomerId INT,
    Login VARCHAR(20),
    SecondName VARCHAR(50),
    Name VARCHAR(50),
    Address VARCHAR(50),
    Telephone VARCHAR(20),
    DeleteDate DATETIME DEFAULT current_timestamp
    );
    
delimiter &
create trigger after_delete_customers
after delete on market.customers
for each row
begin
	insert into market.deletedCustomers (CustomerId, Login, SecondName, Name, Address, Telephone)
    values (OLD.CustomerId, OLD.Login, OLD.SecondName, OLD.Name, OLD.Adsress, OLD.Telephone);
end &

create table Logs(
	TableName varchar(50) not null,
    Operation varchar(10) not null,
    DateTime DATETIME DEFAULT current_timestamp,
    CurrentUser varchar(100)
    );

delimiter &
create trigger after_insert_books
after insert on market.books
for each row
begin
	insert into Logs (TableName,  Operation)
    values('books', 'INSERT');
    end&
    
delimiter &
create trigger after_update_books
after update on market.books
for each row
begin
	insert into Logs (TableName,  Operation)
    values('books', 'UPDATE');
    end&
    
delimiter &
create trigger after_delete_books
after delete on market.books
for each row
begin
	insert into Logs (TableName,  Operation)
    values('books', 'DELETE');
    end&
    
delimiter &
create trigger after_insert_orders
after insert on market.orders
for each row
begin
	insert into Logs (TableName,  Operation)
    values('orders', 'INSERT');
    end&
    
delimiter &
create trigger after_update_orders
after update on market.orders
for each row
begin
	insert into Logs (TableName,  Operation)
    values('orders', 'UPDATE');
    end&
  /*  
delimiter &
create trigger after_delete_orders
after delete on market.orders
for each row
begin
	insert into Logs (TableName,  Operation)
    values('orders', 'DELETE');
    end&
  */  
drop trigger after_delete_orders;

delimiter &
create trigger after_delete_orders
after delete on market.orders
for each row
begin
	insert into Logs (TableName,  Operation)
    values('orders', 'DELETE');
    
    delete from customers
    where CustomerId not in(select distinct CustomerId
    from market.orders);
    end&
    
set @orderCost = 1;

delimiter &
create trigger after_insert_compound
after insert on market.compound
for each row
begin
	select sum(books.price * compound.amount)
		into @orderCost
        from market.compound
        join market.books on compound.BookId = books.BookId
        join market.orders on compound.OrderId = orders.OrderId
        where compound.OrderId = new.OrderId;
    end&