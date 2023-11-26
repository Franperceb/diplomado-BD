-- @Autor Jorge Francisco Pereda Ceballos
-- @Fecha 24/11/2023
-- @Descripcion Creación de los archivos del diccionario de datos a la base

prompt Creando archivos correspondientes a SYS
connect sys/system2 as sysdba

@?/rdbms/admin/catalog.sql
@?/rdbms/admin/catproc.sql
@?/rdbms/admin/utlrp.sql

prompt Creando archivos correspondientes a SYSTEM
connect system/system2
@?/sqlplus/admin/pupbld.sql
