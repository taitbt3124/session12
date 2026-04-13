create table products (
    product_id serial primary key,
    product_name varchar(100),
    price numeric(10,2)
);

create table orders (
    order_id serial primary key,
    product_id int references products(product_id),
    quantity int,
    total_amount numeric(12,2)
);

insert into products (product_name, price)
values 
    ('laptop', 1500.00),
    ('chuột không dây', 20.00);

create or replace function calculate_total_amount()
returns trigger as $$
declare
    unit_price numeric(10,2);
begin
    select price into unit_price from products where product_id = new.product_id;
    
    new.total_amount := unit_price * new.quantity;
    
    return new;
end;
$$ language plpgsql;

create trigger trg_calculate_total
before insert on orders
for each row
execute function calculate_total_amount();

insert into orders (product_id, quantity) values (1, 2);
insert into orders (product_id, quantity) values (2, 5);

select o.order_id, p.product_name, o.quantity, p.price, o.total_amount 
from orders o
join products p on o.product_id = p.product_id;
