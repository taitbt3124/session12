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
values ('iphone 15', 5), ('macbook m3', 2);

create or replace function check_stock_before_sale()
returns trigger as $$
begin
    if (select stock from products where product_id = new.product_id) < new.quantity then
        raise exception 'số lượng tồn kho không đủ để thực hiện giao dịch này';
    end if;
    
    update products 
    set stock = stock - new.quantity 
    where product_id = new.product_id;
    
    return new;
end;
$$ language plpgsql;

create trigger trg_before_insert_sales
before insert on sales
for each row
execute function check_stock_before_sale();

-- thử nghiệm 1: bán thành công (số lượng 3 < tồn kho 5)
insert into sales (product_id, quantity) values (1, 3);
select * from products;

-- thử nghiệm 2: bán thất bại (số lượng 10 > tồn kho hiện tại)
-- lệnh này sẽ bắn ra lỗi exception đã định nghĩa ở trên
insert into sales (product_id, quantity) values (1, 10);

-- kiểm tra lại: tồn kho sản phẩm 1 phải còn 2, sản phẩm 2 vẫn còn 2
select * from products;
select * from sales;
