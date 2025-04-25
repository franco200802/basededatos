create table customers_audit (
    idAudit int auto_increment primary key ,
    operacion char(6),
    user varchar(45),
    Last_date_modified date,
    customerName varchar(45),
    customerNumber int
);

delimiter //
create trigger EJ1 after insert on customers for each row
begin
	insert into customers_audit values(null, "insert", current_user(), current_date(), new.customerName, new.customerNumber);
end//
delimiter ;

delimiter //
create trigger EJ2 before update on customers for each row
begin
	insert into customers_audit values(null, "update", current_user(), current_date(), old.customerName, old.customerNumber);
end//
delimiter ;

insert into customers values('6', "khkh", 'jghjj', 'Carine ', '40.32.2555', '54, rue Royale', NULL, 'Nantes', NULL, '44000', 'France', '1370', '21000.00');
drop trigger EJ2;
update customers set customerNumber = 3 where customerNumber = "3";

