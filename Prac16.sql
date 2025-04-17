delimiter &
create trigger before_delete_customers
before delete on market.customers
for each row
begin
	delete from compound
    where OrderId in(
    select OrderId from orders
    where CustomerId = old.CustomerId);
	
    delete from orders
    where CustomerId = old.CustomerId;
    end&
    
delimiter &
create trigger before_insert_books
before insert on market.books
for each row
begin
	if new.price > 5000 then
    set new.price = 5000;
    end if;
end&

delimiter &
create trigger before_insert_orders
before insert on market.orders
for each row
begin
	set new.DateTime = current_date();
end&

alter table market.books
add column Amount int default 100;

update market.books set Amount = 50;
select * from books;

delimiter &
create trigger before_insert_compound
before insert on market.compound
for each row
begin
	declare current_stock int;
    select Amount into current_stock
    from market.books
    where BookId = NEW.BookId;
    if current_stock < new.Amount then
		signal sqlstate '45000'
        set message_text = 'Недостаточно товара на складе';
	end if;
    update market.books
    set Amount = Amount - new.Amount
    where BookId = new.BookId;
    end &