#9
delimiter //

create procedure dameprovincia(out ciudades text)
begin
    declare hayfilas int default 1;
    declare ciudad varchar(45);
    declare cursor1 cursor for select city from offices; 
	declare continue handler for not found set hayfilas = 0;
	set ciudades=""; 


    open cursor1;
    
    bucle: loop
        fetch cursor1 into ciudad;
        if hayfilas = 0 then
            leave bucle;
        end if;
        
        if ciudades = '' then
            set ciudades = ciudad;
        else
            set ciudades = concat(ciudades, ',', ciudad);
        end if;
    end loop bucle;

    close cursor1;

end //

delimiter ;
drop procedure dameprovincia;
call dameprovincia(@listado);
select @listado;

#10
create table CancelledOrders(ordernumber int primary key, orderdate date,shippeddate date);

delimiter //
create procedure insert_cancelled_orders(out resultado text)
begin
    declare hayfilas int default 1;
    declare orden int;
    declare contador int default 0;
    declare cursor1 cursor for select ordernumber from orders where status = 'cancelled';
    declare continue handler for not found set hayfilas = 0;

    open cursor1;
    bucle: loop
        fetch cursor1 into orden;
        if hayfilas = 0 then
            leave bucle;
        end if;
        insert into cancelledorders select * from orders where ordernumber = orden;
        set contador = contador + 1;
    end loop;
    close cursor1;
    set resultado = concat('se insertaron ', contador, ' órdenes canceladas');
end //	
delimiter ;

drop procedure insert_cancelled_orders;
call insert_cancelled_orders(@listado1);
select @listado1;

#11
	delimiter //
create procedure alter_comment_order(in cliente int, out resultado text)
begin
    declare hayfilas int default 1;
    declare orden int;
    declare total float;
    declare cursor1 cursor for 
        select ordernumber from orders 
        where customernumber = cliente and (comments is null or comments = '');
    declare continue handler for not found set hayfilas = 0;

    set resultado = '';
    open cursor1;
    bucle: loop
        fetch cursor1 into orden;
        if hayfilas = 0 then
            leave bucle;
        end if;
        select sum(quantityordered * priceeach) into total from orderdetails where ordernumber = orden;
   
    end loop;
    close cursor1;
end //





