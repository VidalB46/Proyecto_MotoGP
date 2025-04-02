-- Consulta 1:Media de puntos por piloto en circuitos de más de 5 km, 
-- considerando solo los pilotos que han corrido en al menos 5 carreras. 
-- Mostrar también el nombre del piloto, ordenado por puntos descendente.

select p.nombre, ROUND(avg(rc.puntos_obtenidos))  as media_puntos
from Pilotos p inner join Pilotos_Equipos pe 
    on p.id_piloto = pe.id_piloto inner join Equipos e 
    on pe.id_equipo = e.id_equipo inner join Resultados_Carreras rc 
    on p.id_piloto = rc.id_piloto inner join Circuitos c 
    on rc.id_circuito = c.id_circuito
where c.longitud > 5 and p.id_piloto in 
       (select id_piloto 
        from Resultados_Carreras rc 
        group by id_piloto 
        having count(*) >= 5)
group by p.id_piloto, p.nombre
order by media_puntos desc;

    
-- Consulta 2: Mostrar los 5 pilotos con la mejor posición de media en carreras celebradas en circuitos de España, 
-- considerando solo los pilotos cuyos equipos tienen patrocinadores con una inversión mayor a 10 millones. 
-- Incluir el nombre del piloto, el nombre del equipo, el patrocinador y la posición media, 
-- ordenado por posición media ascendente.
   
select p.nombre as nombre_piloto, e.nombre_equipo, pat.nombre_patrocinador, ROUND(AVG(r.posicion_final)) as posicion_media
from Pilotos p inner join Pilotos_Equipos pe 
    on p.id_piloto = pe.id_piloto inner join Equipos e 
    on pe.id_equipo = e.id_equipo inner join Patrocinios patr 
    on e.id_equipo = patr.id_equipo inner join Patrocinadores pat 
    on patr.id_patrocinador = pat.id_patrocinador inner join Resultados_Carreras r 
    on p.id_piloto = r.id_piloto inner join Circuitos c 
    on r.id_circuito = c.id_circuito
where  c.pais = 'España' and pat.presupuesto > 10000000
group by p.id_piloto, p.nombre, e.nombre_equipo, pat.nombre_patrocinador
order by posicion_media ASC
limit 5;


-- Consulta 3: Obtener los equipos que han corrido en circuitos de más de 4 km,
-- junto con la cantidad de carreras ganadas en esos circuitos. 
-- Solo se mostrarán los equipos que han ganado al menos 3 carreras. 
-- Mostrar el nombre del equipo, la cantidad de victorias y el nombre del circuito.

select e.nombre_equipo, c.nombre_circuito, COUNT(r.posicion_final) AS victorias
from Equipos e inner join Pilotos_Equipos pe 
     on e.id_equipo = pe.id_equipo inner join Resultados_Carreras r 
     on pe.id_piloto = r.id_piloto inner join Circuitos c 
     on r.id_circuito = c.id_circuito
where c.longitud > 4 and r.posicion_final = 1
group by e.id_equipo, c.id_circuito, e.nombre_equipo, c.nombre_circuito
having COUNT(r.posicion_final) >= 3
order by victorias desc;



   -- Consulta 4: Obtener los patrocinadores que han patrocinado equipos que han competido en circuitos de más de 5 km,
   -- junto con el total invertido en esos equipos. 
   -- Solo se mostrarán los patrocinadores cuyo total de inversión supere los 600 millones. 
   -- Los resultados deben ordenarse por la inversión total en orden descendente.

select pat.nombre_patrocinador, SUM(pat.presupuesto) as total_inversion
from Patrocinadores pat inner join Patrocinios patr 
     on pat.id_patrocinador = patr.id_patrocinador inner join Equipos e 
     on patr.id_equipo = e.id_equipo inner join Pilotos_Equipos pe 
     on e.id_equipo = pe.id_equipo inner join Resultados_Carreras r 
     on pe.id_piloto = r.id_piloto inner join Circuitos c 
     on r.id_circuito = c.id_circuito
where c.longitud > 5
group by pat.id_patrocinador, pat.nombre_patrocinador
having SUM(pat.presupuesto) > 600000000
order by total_inversion desc;
   
   -- Consulta 5: Obtener los pilotos que han logrado más podios (posiciones 1, 2 o 3) en carreras del año 2022, 
   -- agrupados por categoría del equipo (Moto3, Moto2, MotoGP). Mostrar el nombre del piloto, el nombre del equipo, 
   -- la categoría del equipo y el número de podios, ordenado por categoría ascendente (Moto3, Moto2, MotoGP) 
   -- y dentro de cada categoría por número de podios descendente. Solo se mostrarán los pilotos con al menos 3 podios.
   
select p.nombre as nombre_piloto, e.nombre_equipo, e.categoria, COUNT(*) as numero_podios
from Pilotos p inner join Pilotos_Equipos pe 
     on p.id_piloto = pe.id_piloto inner join Equipos e 
     on pe.id_equipo = e.id_equipo inner join Resultados_Carreras r 
     on p.id_piloto = r.id_piloto inner join Carreras ca 
     on r.fecha = ca.fecha
where YEAR(ca.fecha) = 2022 and r.posicion_final in (1, 2, 3) and pe.fecha_inicio = (
        select MAX(pe2.fecha_inicio)
        from Pilotos_Equipos pe2
        where pe2.id_piloto = p.id_piloto and pe2.fecha_inicio <= ca.fecha )
group by p.id_piloto, p.nombre, e.nombre_equipo, e.categoria
having COUNT(*) >= 3
order by e.categoria asc, numero_podios desc;






