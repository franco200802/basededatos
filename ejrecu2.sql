/*Triggers
1. Crear un trigger que al realizarse un préstamo, verifique que el ejemplar no esté ya
prestado y que el socio no tenga otro préstamo sin devolver. Si sucede alguna de las dos
debe lanzar el error:"Error: el ejemplar ya se encuentra prestado o tiene otro préstamo
activo".*/
delimiter //
create trigger before_insert_prestamo before insert on prestamo for each row
begin
if exists (select * from ejemplar where estado = "Disponible" and idEjemplar = new.idEjemplar ) and 
exists (select * from socio join prestamo on idSocio=socio.idSocio
where datediff(fechafin, current_date()) >= 0 and idSocio= new.idSocio) then
signal sqlstate "45000" set message_text ="Error: el ejemplar ya se encuentra prestado o tiene otro préstamo
activo";
end if;
end//


/*2. Crear un trigger que al devolverse un libro cambie su estado a disponible. Además, si la
devolución ocurre con más de 2 días de retraso se le debe agregar una multa de $1000
pesos.*/
delimiter //
create trigger after_update_prestamo after update on prestamo for each row
begin
if new.estado = "finalizado" then 
  update ejemplar  set estado = "disponible" where idEjemplar=new.idEjemplar;
select datediff(new.fechaFin, current_date()) into diferencia_dias;
if diferencia_dias > 2 then
  insert into multa values (null, new.idPrestamo, 1000, 0);
end if;
end if;
end//



/*3. Crear un trigger que al aumentar el ranking de un libro reduzca la duración del
préstamo en un 10%, si el nuevo ranking es mayor a 8. Validar que el ranking haya
cambiado.*/

create trigger before_insert_libro before insert on libro for each row
  if new.ranking != old.ranking then
 if new.ranking > 8 then
 insert into libro values (null,null,null,null,new.duracionPrestamo = old.duracionPrestamo * 0.9, new.ranking)
end if;
end if;
end//



/*Transacciones
1. Se desea implementar un procedimiento que permita al socio obtener un préstamo
gratuito si tiene más de 1000 puntos y si el libro tiene un ranking mayor a 5. Si se
cumplen las condiciones se debe crear el préstamo, marcar el libro como prestado y
enviarle al socio la notificación:"¡Felicitaciones! Obtuviste un préstamo gratuito"*/


DELIMITER //
CREATE PROCEDURE prestamo_gratis (IN idSocio INT, IN idLibro INT)
BEGIN
START TRANSACTION;
set mesagge = "¡Felicitaciones! Obtuviste un préstamo gratuito";
select puntos into p from socio where idSocio = socio.idSocio;
select ranking into r from libro join ejemplar on idLibro = ejemplar.idLibro where idLibro = ejemplar.idLibro;

insert into prestamo values (null, idsocio, idLibro, current_date(), null);
if p > 1000 and r > 5 then 
commit;
else 
rollback;
end if;
END//
