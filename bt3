create table products (
    product_id serial primary key,
    name varchar(50),
    stock int
);

create table sales (
    sale_id serial primary key,
    product_id int references products(product_id),
    quantity int
);

insert into products (name, stock) 
values ('iphone 15', 10), ('macbook m3', 5);

create or replace function update_stock_after_sale()
returns trigger as $$
begin
    update products 
    set stock = stock - new.quantity 
    where product_id = new.product_id;
    return new;
end;
$$ language plpgsql;

create trigger trg_after_insert_sales
after insert on sales
for each row
execute function update_stock_after_sale();

insert into sales (product_id, quantity) values (1, 2);
insert into sales (product_id, quantity) values (2, 1);

select * from products;
select * from sales;
