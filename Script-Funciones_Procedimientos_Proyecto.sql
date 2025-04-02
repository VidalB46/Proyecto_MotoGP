
-- Funcion 1:

delimiter &&

create function NumeroCarrerasGanadasEnAño(p_id_piloto INT, p_año INT)
returns INT
deterministic
begin
    declare victorias INT;
    
    select COUNT(*) into victorias
    from Resultados_Carreras r inner join Carreras ca 
    on r.fecha = ca.fecha
    where r.id_piloto = p_id_piloto and YEAR(ca.fecha) = p_año and r.posicion_final = 1;
    
    if victorias is null then
        set victorias = 0;
    end if;
    
    return victorias;
end &&

delimiter ;

select NumeroCarrerasGanadasEnAño(6, 2018) as victorias;

-- Nueva Función 2: NumeroPodiosEnAño
-- Descripción: Calcula el número total de podios (posiciones 1, 2 o 3) que un piloto ha conseguido en un año específico..

delimiter &&

create function NumeroPodiosEnAño(p_id_piloto INT, p_año INT)
returns INT
deterministic
begin
    declare podios INT;
    
    select COUNT(*) into podios
    FROM Resultados_Carreras r inner join Carreras ca 
    on DATE(r.fecha) = DATE(ca.fecha)
    where r.id_piloto = p_id_piloto
    and YEAR(ca.fecha) = p_año
    and r.posicion_final in (1, 2, 3);
    
    if podios is null then
        SET podios = 0;
    end if;
    
    return podios;
end &&

delimiter ;

select NumeroPodiosEnAño(1, 2012) as podios;


-- Procedimiento 1: ResultadosCarrerasPilotoEnAño
-- Descripción: Este procedimiento mostrará un reporte de todas las carreras en las que un piloto participó en un año específico, 
-- incluyendo la fecha de la carrera, el nombre del circuito, la posición final y los puntos obtenidos

delimiter &&

create procedure ResultadosCarrerasPilotoEnAño(in p_id_piloto INT, in p_año INT)
begin
    select r.fecha AS fecha_carrera,ci.nombre_circuito as nombre_circuito, r.posicion_final, r.puntos_obtenidos
    from Resultados_Carreras r inner join Carreras ca 
         on DATE(r.fecha) = DATE(ca.fecha) inner join Circuitos ci 
         on r.id_circuito = ci.id_circuito
    where r.id_piloto = p_id_piloto and YEAR(ca.fecha) = p_año
    order by r.fecha;
end &&

delimiter ;

CALL ResultadosCarrerasPilotoEnAño(1, 2012);

-- Procedimiento 2: InsertarResultadoCarrera

delimiter &&

create procedure InsertarResultadoCarrera(in p_id_piloto INT, in p_fecha DATE, in p_id_circuito INT, in p_posicion_final INT,
                                          in p_puntos_obtenidos INT)
begin
    insert into Resultados_Carreras (id_piloto, fecha, id_circuito, posicion_final, puntos_obtenidos)
    values (p_id_piloto, p_fecha, p_id_circuito, p_posicion_final, p_puntos_obtenidos);
end &&

delimiter ;

CALL InsertarResultadoCarrera(1, '2012-04-08', 1, 1, 25);
select * from Resultados_Carreras where id_piloto = 1 and fecha = '2012-04-08';


-- Procedimiento 3: 

delimiter &&

create procedure CompararPilotosEnAño(in p_id_piloto1 INT, in p_id_piloto2 INT, in p_año INT)
begin
    select p1.nombre as nombre_piloto_1, NumeroCarrerasGanadasEnAño(p_id_piloto1, p_año) as victorias_piloto_1,
        NumeroPodiosEnAño(p_id_piloto1, p_año) as podios_piloto_1, p2.nombre as nombre_piloto_2,
        NumeroCarrerasGanadasEnAño(p_id_piloto2, p_año) as victorias_piloto_2,
        NumeroPodiosEnAño(p_id_piloto2, p_año) as podios_piloto_2
    from Pilotos p1, Pilotos p2
    where p1.id_piloto = p_id_piloto1 and p2.id_piloto = p_id_piloto2;
END &&

delimiter ;

call CompararPilotosEnAño(1, 2, 2012);








