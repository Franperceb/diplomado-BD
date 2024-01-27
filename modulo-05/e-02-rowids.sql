--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 12/01/2024
--@Descripción: Ejercicio 02 - Módulo 05. Row ids


connect jorge05/jorge05

Prompt  mostrando los primeros 10 registros y sus rowids.
--subconsulta para ordenar

select row_id,id 
from (
  select rowid as row_id,id
  from t01_id
  order by id
) where rownum <=10;

Prompt mostrando segmentos generados
select substr(rowid,1,6) segmento, 
       count(*) as total_registros
from t01_id
group by substr(rowid,1,6);
Pause [Enter] para continuar

Prompt mostrando data file y registros asignados
select substr(rowid,7,3) data_file, 
       count(*) as total_registros
from t01_id
group by substr(rowid,7,3);
Pause [Enter] para continuar

Prompt mostrando bloque de datos y registros incluidos en el.
select substr(rowid,10,6) bloque, 
       count(*) as total_registros
from t01_id
group by substr(rowid,10,6);
