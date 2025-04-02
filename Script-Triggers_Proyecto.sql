-- Trigger 1: RegistrarCambioEquipo. Este trigger se activará después de insertar 
-- una nueva relación en la tabla Pilotos_Equipos. Su propósito será registrar un 
-- log de los cambios de equipo de los pilotos en una tabla auxiliar, para 
-- mantener un historial de los movimientos de los pilotos entre equipos.

create table Log_Cambios_Equipo (
    id_log INT AUTO_INCREMENT primary key,
    id_piloto INT,
    id_equipo INT,
    fecha_cambio DATE,
    fecha_registro DATETIME default CURRENT_TIMESTAMP);

delimiter &&

create trigger RegistrarCambioEquipo
after insert on Pilotos_Equipos
for each row
begin
    insert into Log_Cambios_Equipo (id_piloto, id_equipo, fecha_cambio)
    values (new.id_piloto, new.id_equipo, new.fecha_inicio);
end &&

delimiter ;


select * from Log_Cambios_Equipo where id_piloto = 1;



insert into Pilotos_Equipos (id_piloto, id_equipo, fecha_inicio)
values (1, 1, '2012-01-01');

select * from Log_Cambios_Equipo where id_piloto = 1;

-- Trigger 2: EvitarPatrociniosDuplicados. Su propósito será evitar que se 
-- inserten patrocinios duplicados para el mismo equipo y patrocinador en el mismo 
-- año

delimiter &&

create trigger EvitarPatrociniosDuplicados
before insert on Patrocinios
for each row
begin
    declare patrocinio_existente INT;
    
    select COUNT(*) into patrocinio_existente
    from Patrocinios
    where id_equipo = new.id_equipo and id_patrocinador = new.id_patrocinador and YEAR(fecha_inicio) = YEAR(new.fecha_inicio);
    
    if patrocinio_existente > 0 then
        signal SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Ya existe un patrocinio para este equipo y patrocinador en el mismo año.';
    end if;
end &&

delimiter ;


SELECT * FROM Patrocinios WHERE id_equipo = 1 AND YEAR(fecha_inicio) = 2012;


INSERT INTO Patrocinios (id_equipo, id_patrocinador, fecha_inicio)
VALUES (1, 1, '2012-06-01');


