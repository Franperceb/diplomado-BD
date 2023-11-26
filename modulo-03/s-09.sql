Prompt conectando como usuario userJava 
connect userJava/userJava

Prompt creando procedimiento almacenado

create or replace procedure sp_resizeImage(
  p_filePath varchar2, p_width number, p_height number
  ) as 
  language java
  name 'mx.edu.unam.fi.dipbd.ResizeImage.resizeImage(java.lang.String, int,int)';
/

show errors

prompt invocando el procedimiento
exec sp_resizeImage('/tmp/paisaje.png',734,283);

prompt mostrando el contenido de la carpeta /tmp
!ls -lh /tmp/paisaje.png
!ls -lh /tmp/output-paisaje.png

Prompt Mostrando operaciones de ajuste de memoria para el java pool
connect sys/system2 as sysdba 

col component format a15
col parameter format a15

alter session set nls_date_format='dd/mm/yyyy hh24:mi:ss';

select component,oper_type,
  trunc(initial_size/1024/1024,2) initial_size_mb,
  trunc(target_size/1024/1024,2) target_size_mb,
  trunc(final_size/1024/1024,2) final_size_mb,
  start_time,parameter
from v$sga_resize_ops 
where component='java pool'
order by start_time;

Prompt realizando limpieza
connect sys/system2 as sysdba 

drop user userJava cascade;
