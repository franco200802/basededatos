create table customers_audit (
    idaudit int auto_increment primary key,
    operacion char(6),
    usuario varchar(100),
    last_date_modified datetime,
    customernumber int,
    customername varchar(50),
    contactlastname varchar(50),
    contactfirstname varchar(50),
    phone varchar(50),
    city varchar(50),
    country varchar(50),
    creditlimit decimal(10,2)
);

delimiter //

create trigger trg_customers_insert
after insert on customers
for each row
begin
    insert into customers_audit (operacion, usuario, last_date_modified, customernumber, customername, contactlastname, contactfirstname, phone, city, country, creditlimit)
    values ('insert', user(), now(), new.customernumber, new.customername, new.contactlastname, new.contactfirstname, new.phone, new.city, new.country, new.creditlimit);
end;
//

delimiter //

create trigger trg_customers_update
before update on customers
for each row
begin
    insert into customers_audit (operacion, usuario, last_date_modified, customernumber, customername, contactlastname, contactfirstname, phone, city, country, creditlimit)
    values ('update', user(), now(), old.customernumber, old.customername, old.contactlastname, old.contactfirstname, old.phone, old.city, old.country, old.creditlimit);
end;
//

delimiter //

create trigger trg_customers_delete
before delete on customers
for each row
begin
    insert into customers_audit (operacion, usuario, last_date_modified, customernumber, customername, contactlastname, contactfirstname, phone, city, country, creditlimit)
    values ('delete', user(), now(), old.customernumber, old.customername, old.contactlastname, old.contactfirstname, old.phone, old.city, old.country, old.creditlimit);
end;
//

delimiter ;

create table employees_audit (
    idaudit int auto_increment primary key,
    operacion char(6),
    usuario varchar(100),
    last_date_modified datetime,
    employeenumber int,
    lastname varchar(50),
    firstname varchar(50),
    extension varchar(10),
    email varchar(100),
    officecode varchar(10),
    reportsto int,
    jobtitle varchar(50)
);

delimiter //

create trigger trg_employees_insert
after insert on employees
for each row
begin
    insert into employees_audit (operacion, usuario, last_date_modified, employeenumber, lastname, firstname, extension, email, officecode, reportsto, jobtitle)
    values ('insert', user(), now(), new.employeenumber, new.lastname, new.firstname, new.extension, new.email, new.officecode, new.reportsto, new.jobtitle);
end;
//

delimiter //

create trigger trg_employees_update
before update on employees
for each row
begin
    insert into employees_audit (operacion, usuario, last_date_modified, employeenumber, lastname, firstname, extension, email, officecode, reportsto, jobtitle)
    values ('update', user(), now(), old.employeenumber, old.lastname, old.firstname, old.extension, old.email, old.officecode, old.reportsto, old.jobtitle);
end;
//

delimiter //

create trigger trg_employees_delete
before delete on employees
for each row
begin
    insert into employees_audit (operacion, usuario, last_date_modified, employeenumber, lastname, firstname, extension, email, officecode, reportsto, jobtitle)
    values ('delete', user(), now(), old.employeenumber, old.lastname, old.firstname, old.extension, old.email, old.officecode, old.reportsto, old.jobtitle);
end;
//

delimiter //

create trigger trg_prevent_delete_product_with_orders
before delete on products
for each row
begin
    if exists (
        select 1
        from orderdetails, orders
        where orderdetails.ordernumber = orders.ordernumber
        and orderdetails.productcode = old.productcode
        and orders.orderdate >= curdate() - interval 2 month
    ) then
        signal sqlstate '45000' set message_text = 'error, tiene órdenes asociadas';
    end if;
end;
//

delimiter ;
