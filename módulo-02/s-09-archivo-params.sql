--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 23/11/2023
--@Descripción: Ejercicio 09 -módulo 02 . Archivo de parámetros.
prompt Conectando como sysdba
connect sys/system1 as sysdba

prompt Creando pfile a partir del spfile
create pfile='/tmp/pfile-spfile.ora' from spfile;

prompt Creando pfile sobre valores configurados en la instancia
create pfile='/tmp/pfile-memory.ora' from memory;

prompt Cambiando permisos a pfile-memory.ora
!chmod 777 /tmp/pfile-memory.ora

prompt Consultando valor de undo_retention
show parameter undo_retention

prompt Anexando a pfile-memory.ora  nuevo valor de undo_retention
!echo "undo_retention=1000" >> /tmp/pfile-memory.ora

pause reiniciando BD, [ Enter ] para continuar...
shutdown immediate
startup pfile='/tmp/pfile-memory.ora'

prompt Conectando como sysdba
connect sys/system1 as sysdba
show parameter undo_retention

prompt alterando parámetro a nivel spfile undo_retention
alter system undo_retention=1500 scope=spfile;

--no será exitosa ya que anda iniciado sobre el pfile y no el spfile.
accept v_result prompt '¿Que pasó al ejecutar la instrucción?'
prompt  Respuesta: &v_result 


