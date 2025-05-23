create procedure productos_mayor_promedio()
begin
    select count(*) into @cantidad
    from products
    where buyprice > (select avg(buyprice) from products);

    select *
    from products
    where buyprice > (select avg(buyprice) from products);

    select @cantidad;
end;


create procedure borrar_orden(in ordnum int, out resultado int)
begin
    declare cantidad int;

    delete from orderdetails where ordernumber = ordnum;
    set cantidad = row_count();

    delete from orders where ordernumber = ordnum;

    if cantidad = 0 then
        set resultado = 0;
    else
        set resultado = cantidad;
    end if;
end;

create procedure borrar_productline(in pline varchar(50), out mensaje varchar(100))
begin
    if exists(select * from products where productline = pline) then
        set mensaje = 'la línea de productos no pudo borrarse porque contiene productos asociados';
    else
        delete from productlines where productline = pline;
        set mensaje = 'la línea de productos fue borrada';
    end if;
end;
create procedure ordenes_por_estado()
begin
    select status, count(*) as cantidad
    from orders
    group by status;
end;
create procedure empleados_con_subordinados()
begin
    select e.employeenumber, count(*) as subordinados
    from employees e
    join employees s on e.employeenumber = s.reportsto
    group by e.employeenumber;
end;
create procedure orden_total()
begin
    select o.ordernumber, sum(od.quantityordered * od.priceeach) as total
    from orders o
    join orderdetails od on o.ordernumber = od.ordernumber
    group by o.ordernumber;
end;
create procedure ordenes_por_cliente()
begin
    select c.customernumber, c.customername, o.ordernumber, sum(od.quantityordered * od.priceeach) as total
    from customers c
    join orders o on c.customernumber = o.customernumber
    join orderdetails od on o.ordernumber = od.ordernumber
    group by c.customernumber, o.ordernumber;
end;
create procedure actualizar_comentario(in ordnum int, in com text, out resultado int)
begin
    update orders set comments = com where ordernumber = ordnum;

    if row_count() = 0 then
        set resultado = 0;
    else
        set resultado = 1;
    end if;
end;

create procedure getciudadesoffices(out ciudades varchar(4000))
begin
    declare done int default 0;
    declare ciudad varchar(50);
    declare cur cursor for select city from offices;
    declare continue handler for not found set done = 1;

    set ciudades = '';
    open cur;

    loop_ciudades: loop
        fetch cur into ciudad;
        if done = 1 then
            leave loop_ciudades;
        end if;
        set ciudades = concat_ws(',', ciudades, ciudad);
    end loop;

    close cur;
end;
