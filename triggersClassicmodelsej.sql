create table auditoria_clientes (
    id_auditoria int auto_increment primary key,
    operacion char(6),
    usuario varchar(100),
    fecha_modificacion datetime,
    numero_cliente int,
    nombre_cliente varchar(50),
    apellido_contacto varchar(50),
    nombre_contacto varchar(50),
    telefono varchar(50),
    ciudad varchar(50),
    pais varchar(50),
    limite_credito decimal(10,2)
);

delimiter //

create trigger insertar_cliente_auditoria
after insert on customers
for each row
begin
    insert into auditoria_clientes (operacion, usuario, fecha_modificacion, numero_cliente, nombre_cliente, apellido_contacto, nombre_contacto, telefono, ciudad, pais, limite_credito)
    values ('insert', user(), now(), new.customernumber, new.customername, new.contactlastname, new.contactfirstname, new.phone, new.city, new.country, new.creditlimit);
end;
//

delimiter //

create trigger actualizar_cliente_auditoria
before update on customers
for each row
begin
    insert into auditoria_clientes (operacion, usuario, fecha_modificacion, numero_cliente, nombre_cliente, apellido_contacto, nombre_contacto, telefono, ciudad, pais, limite_credito)
    values ('update', user(), now(), old.customernumber, old.customername, old.contactlastname, old.contactfirstname, old.phone, old.city, old.country, old.creditlimit);
end;
//

delimiter //

create trigger eliminar_cliente_auditoria
before delete on customers
for each row
begin
    insert into auditoria_clientes (operacion, usuario, fecha_modificacion, numero_cliente, nombre_cliente, apellido_contacto, nombre_contacto, telefono, ciudad, pais, limite_credito)
    values ('delete', user(), now(), old.customernumber, old.customername, old.contactlastname, old.contactfirstname, old.phone, old.city, old.country, old.creditlimit);
end;
//

delimiter ;

create table auditoria_empleados (
    id_auditoria int auto_increment primary key,
    operacion char(6),
    usuario varchar(100),
    fecha_modificacion datetime,
    numero_empleado int,
    apellido varchar(50),
    nombre varchar(50),
    interno varchar(10),
    correo varchar(100),
    codigo_oficina varchar(10),
    jefe int,
    puesto varchar(50)
);

delimiter //

create trigger insertar_empleado_auditoria
after insert on employees
for each row
begin
    insert into auditoria_empleados (operacion, usuario, fecha_modificacion, numero_empleado, apellido, nombre, interno, correo, codigo_oficina, jefe, puesto)
    values ('insert', user(), now(), new.employeenumber, new.lastname, new.firstname, new.extension, new.email, new.officecode, new.reportsto, new.jobtitle);
end;
//

delimiter //

create trigger actualizar_empleado_auditoria
before update on employees
for each row
begin
    insert into auditoria_empleados (operacion, usuario, fecha_modificacion, numero_empleado, apellido, nombre, interno, correo, codigo_oficina, jefe, puesto)
    values ('update', user(), now(), old.employeenumber, old.lastname, old.firstname, old.extension, old.email, old.officecode, old.reportsto, old.jobtitle);
end;
//

delimiter //

create trigger eliminar_empleado_auditoria
before delete on employees
for each row
begin
    insert into auditoria_empleados (operacion, usuario, fecha_modificacion, numero_empleado, apellido, nombre, interno, correo, codigo_oficina, jefe, puesto)
    values ('delete', user(), now(), old.employeenumber, old.lastname, old.firstname, old.extension, old.email, old.officecode, old.reportsto, old.jobtitle);
end;
//

delimiter //

create trigger evitar_borrado_producto_con_ordenes
before delete on products
for each row
begin
    if exists (
        select 1
        from orderdetails, orders
        where orderdetails.ordernumber = orders.ordernumber
        and orderdetails.productcode = old.productcode
    ) then
        signal sqlstate '45000' set message_text = 'error, tiene órdenes asociadas';
    end if;
end;
//

delimiter ;
