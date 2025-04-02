-- Vista 1. Podios por año y categoría. Esta vista mostrará los pilotos con más
-- podios (posiciones 1, 2 o 3) por año y categoría (Moto3, Moto2, MotoGP). 
-- Incluirá el año, la categoría, el nombre del piloto, el nombre del equipo y el 
-- número de podios, ordenado por año, categoría y número de podios descendente. 
-- Solo se mostrarán los pilotos con al menos 3 podios en un año y categoría 
-- específicos.

create view Vista_Podios_Por_Año as
select YEAR(ca.fecha) as año, e.categoria, p.nombre as nombre_piloto, e.nombre_equipo, COUNT(*) as numero_podios
from Pilotos p inner join Pilotos_Equipos pe 
     on p.id_piloto = pe.id_piloto inner join Equipos e 
     on pe.id_equipo = e.id_equipo inner join Resultados_Carreras r 
     on p.id_piloto = r.id_piloto inner join Carreras ca 
     on r.fecha = ca.fecha
where r.posicion_final in (1, 2, 3) and pe.fecha_inicio = (
        select MAX(pe2.fecha_inicio)
        from Pilotos_Equipos pe2
        where pe2.id_piloto = p.id_piloto and pe2.fecha_inicio <= ca.fecha)
group by YEAR(ca.fecha), e.categoria, p.id_piloto, p.nombre, e.nombre_equipo
having COUNT(*) >= 3
order by año, e.categoria asc, numero_podios desc;
   
   select * from Vista_Podios_Por_Año;
    
-- Vista 2.Puntos por piloto y año. Muestra el total de puntos acumulados por 
-- cada piloto por año, incluyendo la categoría del equipo.
   
create view Vista_Puntos_Por_Piloto_Y_Año as
select YEAR(ca.fecha) as año, e.categoria, p.nombre as nombre_piloto, e.nombre_equipo, SUM(r.puntos_obtenidos) as total_puntos
from Pilotos p inner join Pilotos_Equipos pe 
     on p.id_piloto = pe.id_piloto inner join Equipos e 
     on pe.id_equipo = e.id_equipo inner join Resultados_Carreras r 
     on p.id_piloto = r.id_piloto inner join Carreras ca 
     on r.fecha = ca.fecha
where pe.fecha_inicio = (
        select MAX(pe2.fecha_inicio)
        from Pilotos_Equipos pe2
        where pe2.id_piloto = p.id_piloto and pe2.fecha_inicio <= ca.fecha)
group by YEAR(ca.fecha), e.categoria, p.id_piloto, p.nombre, e.nombre_equipo
order by año, e.categoria, total_puntos desc;
   
   select * from Vista_Puntos_Por_Piloto_Y_Año;
    
   