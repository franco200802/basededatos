Delimiter //
create procedure control_stock_semanal()
	begin
		declare hayfilas boolean default true;
		declare nuevostock int;
		declare id int;
		declare cursorstock cursor for select sum(cantidad), codProducto from producto join ingresostock_producto on Producto_codProducto = codProducto group by codProducto;
		declare continue handler for not found set hayfilas = false;
        open cursorstock;
        bucle : loop
			fetch cursorstock into nuevostock, id;
            if hayfilas=false then leave bucle;
            end if;
				update producto set stock = stock + nuevostock where codProducto = id;
        end loop bucle;
        close cursorstock;
	end//	
delimiter ;
call control_stock_semanal();
select @stock;

delimiter //
	create procedure precio_reducido ()
    begin
		declare hayfilas boolean default true;
		declare nuevo_precio int;
		declare id int;
        declare cant_ventas int default 0;
        declare cursor_reductor cursor for select codProducto from producto;
		declare continue handler for not found set hayfilas = false;
        open cursor_reductor;
        bucle:loop
        fetch cursor_reductor into id; 
         if hayfilas=false then leave bucle;
         end if;
		 select sum(cantidad) into cant_ventas from pedido_producto where Producto_codProducto = id;
         if cant_ventas < 100 then
         update producto set precio = precio - (precio * 0.1) where codProducto = id ;
        end if;
        end loop bucle;
        close cursor_reductor;
        end//        
delimiter ;

call precio_reducido ();


delimiter //
	create procedure sumar_precio()
		begin
			declare hayfilas boolean default true;
            declare id int;
            declare mayor_precio_proveedor decimal(10,2);
            declare cursor_sumador cursor for select codProducto from producto;
			declare continue handler for not found set hayfilas = false;
			open cursor_sumador;
            bucle : loop
			fetch cursor_sumador into id; 
				if hayfilas=false then leave bucle;
				end if;
            select max(precio) into mayor_precio_proveedor from producto_proveedor join producto on codProducto = Producto_codProducto  where codProducto = id ;
            update producto set precio = mayor_precio_proveedor + (mayor_precio_proveedor * 0.1) where codProducto = id ;
			end loop bucle;
			close cursor_sumador;
		end//
delimiter ;

delimiter //
	create procedure nivel()
		declare hayfilas boolean default true;
		declare id int;
		
    
delimiter ;


