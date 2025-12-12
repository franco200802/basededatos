/*1. Se desea implementar un procedimiento que permita a los clientes realizar una reserva
con descuento por fidelidad. La promoción es válida sólo si el cliente tiene más de 1000
puntos y la habitación tiene un precio base mayor a $50.000. Si se cumplen ambas
condiciones, se realiza la reserva aplicando un 15% de descuento, se insertan los datos
correspondientes y se envía una notificación con el mensaje "Reserva realizada con
descuento".*//

DELIMITER //
CREATE PROCEDURE reserva_fidelidad (IN idCliente INT, IN idHabitacion INT, IN fechaInicio
DATE, IN fechaFin DATE)
BEGIN
START TRANSACTION;
select puntos into p from clientes where id = idCliente;
select precio_base into preciob from tipos_habitacion join habitacion on idTipo=id where idHabitacion = habitaciones.idHabitacion;
select datediff(fechaFin, fechaInicio) into cant_dias;
insert into reservas values (null, idCliente, idHabitacion, null, null, null,preciob * cant_dias * 0,75 );
if p > 1000 and preciob > 50000 then
commit;
else
rollback;
end if;
END//


/*Triggers
1. Crear un trigger que, al crearse una reserva, verifique que no se superponga con otra
reserva activa en la misma habitación. Si existe otra reserva con fechas que se
superponen, debe lanzar el error:"Error: la habitación ya está reservada en ese
período.¨*/


create trigger before_create_reserva before insert on reservas for each row
begin 
if exists (select * from reservas where idHabitacion= new.idHabitacion and fecha_fin > new.fecha_inicio) then 
signal sqlstate "45000" set message_text = "Error: la habitación ya está reservada en ese
período.";
end if;
end//


/*2. Crear un trigger que, al marcarse una reserva como finalizada, actualice el estado de la
habitación a Disponible. Validar correctamente que la reserva esté finalizada.*/

create trigger after_update_reserva after update on reservas for each row 
begin
if datediff(fecha_fin, current_date() ) >=0 and new.estado = "finalizado" then 
update habitaciones set estado = "Disponible" where new.idHabitacion = habitaciones.id;
end if;
end//



/*3. Crear un trigger que, al actualizarse el precio base de una habitación, incremente un
10% el precio de las reservas futuras (con fecha_inicio posterior a la fecha actual) para
esa habitación.
*/

create trigger after_update_habitacion after update on tipos_habitacion for each row
begin
if old.precio<new.precio then 
update reservas join habitaciones on idHabitacion=habitaciones.id set precio_final =precio_final * 1.1 where idTipo=new.id and datediff(fecha_inicio,current_date())>=0;
end if;
end//
