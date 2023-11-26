-- @Autor Jorge Francisco Pereda Ceballos
-- @Fecha 24/11/2023
-- @Descripcion Creación del SPFILE

prompt Autenticando como sys
connect sys/Hola1234* as sysdba

create spfile from pfile;

prompt validando existencia de spfile
!ls ${ORACLE_HOME}/dbs/spfilejpcdip02.ora

