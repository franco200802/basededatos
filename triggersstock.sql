create trigger actualizar_stock_pedido
before insert on pedido_producto
for each row
update ingresostock_producto
set cantidad = cantidad - new.cantidad
where producto_id = new.producto_id;

create trigger borrar_stock_relacionado
before delete on ingresostock
for each row
delete from ingresostock_producto
where ingreso_id = old.ingreso_id;

create trigger actualizar_categoria_cliente
after update on clientes
for each row
begin
  declare total decimal(10,2);
  select sum(monto) into total from pedidos where cliente_id = new.cliente_id;
  if total <= 50000 then
    update clientes set categoria = 'bronce' where cliente_id = new.cliente_id;
  elseif total > 50000 and total <= 100000 then
    update clientes set categoria = 'plata' where cliente_id = new.cliente_id;
  else
    update clientes set categoria = 'oro' where cliente_id = new.cliente_id;
  end if;
end;

create trigger aumentar_stock
after insert on ingresostock_producto
for each row
update productos
set stock = stock + new.cantidad
where producto_id = new.producto_id;

create trigger prevenir_borrado_pedidos
before delete on pedidos
for each row
begin
  if exists (
    select 1 from devoluciones where pedido_id = old.pedido_id
  ) then
    signal sqlstate '45000'
    set message_text = 'error, tiene devoluciones asociadas';
  end if;
end;

create procedure eliminar_clientes_sin_compras ()
begin
  delete from clientes
  where cliente_id not in (
    select distinct cliente_id from pedidos
  );
end;
