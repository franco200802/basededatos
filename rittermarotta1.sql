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
    select (priceEach - buyPrice) into beneficio from orderdetails join products on orderdetails.productCode = products.productCode where orderNumber = orderNum and products.productCode = prodCode;
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

delimiter //
create function prim_orden(customerNumber int) returns date deterministic
begin
	declare fecha_prim date;
    select orderDate into fecha_prim from orders join customers on orders.customerNumber = customers.customerNumber group by(orderDate) order by(orderDate) limit 1;
	return fecha_prim;
end//

select prim_orden(1);

delimiter //
create function porcentajedescuento(productcode varchar(15)) returns float deterministic
begin
    declare totalventas int default 0;
    declare ventasdescuento int default 0;
    declare porcentaje float default 0;
    select count(*) into totalventas
    from orderdetails
    where orderdetails.productcode = productcode;
    select count(*) into ventasdescuento
    from orderdetails
    join products on orderdetails.productcode = products.productcode
    where orderdetails.productcode = productcode and orderdetails.priceeach < products.msrp;
    if totalventas > 0 then
        set porcentaje = (ventasdescuento / totalventas) * 100;
    end if;
    return porcentaje;
end //
delimiter ;

select porcentajedescuento('s10_1678');


delimiter //
create function ultimafechapedido(productcode varchar(45)) returns date deterministic
begin
    declare ultimafecha date default null;
    select max(orders.orderdate) into ultimafecha
    from orders
    join orderdetails on orders.ordernumber = orderdetails.ordernumber
    where orderdetails.productcode = productcode;
    
    return ultimafecha;
end //
delimiter ;

select ultimafechapedido('s10_1678');


delimiter //
create function max_price_product(fecha_desde date, fecha_hasta date, prodcode varchar(15))
returns float deterministic
begin
    declare max_precio float default 0;
    select max(priceeach) into max_precio
    from orderdetails
    join orders on orderdetails.ordernumber = orders.ordernumber
    where orderdetails.productcode = prodcode
    and orders.orderdate between fecha_desde and fecha_hasta;
    if max_precio is null then
        set max_precio = 0;
    end if;
    return max_precio;
end//
delimiter ;
select max_price_product('2003-01-01', '2003-12-31', 's10_1678');


delimiter //
create function cant_clientes_empleado(num_empleado int)
returns int deterministic
begin
    declare cantidad int default 0;
    
    select count(customernumber) into cantidad
    from customers
    where salesrepemployeenumber = num_empleado;
    
    return cantidad;
end//

delimiter ;
select cant_clientes_empleado(1002);


delimiter //
create function apellido_jefe(num_empleado int)
returns varchar(50) deterministic
begin
    declare apellido varchar(50) default '';
    
    select lastname into apellido
    from employees
    where employeenumber = (select reportsto from employees where employeenumber = num_empleado);
    
    return apellido;
end//
delimiter ;
select apellido_jefe(1);


delimiter //
create function jerarquia(num_empleado int) returns varchar(45) deterministic 
begin 
	declare nivel varchar(45) default"nivel 1";
    declare cant int;
    select count(reportsTo) into cant from employees where reportsTo=num_empleado;
    if cant > 20 then
    set nivel = "nivel3";
    end if;
    
    if cant < 20 and cant>10 then
    set nivel = "nivel2";
    end if;
    return nivel;
end//
delimiter ;
drop function jerarquia;
select jerarquia(1005);



delimiter //
create procedure listarproductosmayorpromedio(out cantidad int)
begin
    declare precio_promedio float;
    
    select avg(buyprice) into precio_promedio from products;
    
    select productcode, productname, buyprice
    from products
    where buyprice > precio_promedio;
    
    select count(*) into cantidad
    from products
    where buyprice > precio_promedio;
end //
delimiter ;


delimiter //
create function borrarorden(ordernum int) returns int deterministic
begin
    declare cantidad int;
    
    select count(*) into cantidad from orderdetails where ordernumber = ordernum;
    
    if cantidad > 0 then
        delete from orderdetails where ordernumber = ordernum;
        delete from orders where ordernumber = ordernum;
    end if;
    
    return cantidad;
end //
delimiter ;

delimiter //
create function borrarlineaproducto(linea varchar(50)) returns varchar(100) deterministic
begin
    declare cantidad int;
    declare mensaje varchar(100);
    
    select count(*) into cantidad from products where productline = linea;
    
    if cantidad > 0 then
        set mensaje = 'la línea de productos no pudo borrarse porque contiene productos asociados';
    else
        delete from productlines where productline = linea;
        set mensaje = 'la línea de productos fue borrada';
    end if;
    
    return mensaje;
end //
delimiter ;
