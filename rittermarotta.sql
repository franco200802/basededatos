delimiter //
create function cantordenes (estado varchar(45), fechainc date, fechafin date) returns int deterministic
begin
declare cantOrdenes int default 0;
select count(*) into cantOrdenes from orders where status=estado and orderDate between fechainc and fechafin;
return cantOrdenes;
end//
delimiter ;
select cantOrdenes ("shipped","2001-12-11", "2019-12-15");
delimiter //
create function envionashe (fecha1 date, fecha2 date) returns int deterministic
begin
declare envionashe int default 0;
select count(*) into envionashe from orders where status="shipped" and shippedDate between fecha1 and fecha2;
return envionashe;
end//
delimiter ;	
select envionashe ("2001-12-11", "2019-12-15");

delimiter //
create function devuelveciudad (numcliente int) returns varchar(45) deterministic
begin
declare devuelveciudad varchar(45) default 0;
select offices.city into devuelveciudad from employees join customers on salesRepEmployeeNumber=employeeNumber join offices on offices.officeCode = employees.officeCode where customerNumber = numcliente;
return devuelveciudad;
end//
delimiter ;	
select devuelveciudad(103);
drop function devuelveciudad;
delimiter //
create function cantproductos (gondola varchar(45)) returns int deterministic
begin
declare cantproductos int default 0;
select count(productCode) into cantproductos from products join productlines on productlines.productLine = products.productline where gondola = productlines.productline;
return cantproductos;
end//
delimiter ;	
drop function cantproductos;
select cantproductos("Classic Cars");


delimiter //
create function cantclientes (codigo varchar(45)) returns int deterministic
begin
declare cantclientes int default 0;
select count(employeeNumber) into cantclientes from offices join employees on offices.officeCode = employees.officeCode where codigo = offices.officeCode;
return cantclientes;
end//
delimiter ;	

drop function cantclientes;
select cantclientes("0");

delimiter //
create function cantoficina (codigo varchar(45)) returns int deterministic
begin
    declare cantoficina int default 0;
    select count(orderNumber) into cantoficina from orders 
    join customers on orders.customerNumber = customers.customerNumber 
    join employees on customers.salesRepEmployeeNumber = employees.employeeNumber
    join offices on employees.officeCode = offices.officeCode
    where codigo = offices.officeCode;
    return cantoficina;
end//
delimiter ;	
select cantoficina("1");
drop function cantclientes;
select cantclientes("0");

delimiter //
create function beneficioProducto(orderNum int, prodCode varchar(45)) returns decimal(10,2) deterministic
begin
    declare beneficio decimal(10,2) default 0;
    select (priceEach - buyPrice) into beneficio 
    from orderdetails 
    join products on orderdetails.productCode = products.productCode 
    where orderNumber = orderNum and products.productCode = prodCode;
    return beneficio;
end//
delimiter ;
select beneficioProducto(10100, '');


delimiter //
create function estadoOrdenCancelada(orderNum int) returns int deterministic
begin
    declare resultado int default 0;
    if (select status from orders where orderNumber = orderNum) = 'Cancelled' then
        set resultado = -1;
    else
        set resultado = 0;
    end if;
    return resultado;
end//
delimiter ;
select estadoOrdenCancelada(10100);




