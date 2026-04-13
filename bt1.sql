create table customers (
    customer_id serial primary key,
    name varchar(50),
    email varchar(50)
);

create table customer_log (
    log_id serial primary key,
    customer_name varchar(50),
    action_time timestamp
);

create or replace function log_new_customer()
returns trigger as $$
begin
    insert into customer_log (customer_name, action_time)
    values (new.name, now());
    return new;
end;
$$ language plpgsql;

create trigger trg_after_insert_customer
after insert on customers
for each row
execute function log_new_customer();

insert into customers (name, email) values ('nguyen van a', 'a@gmail.com');
insert into customers (name, email) values ('tran thi b', 'b@gmail.com');

select * from customer_log;
