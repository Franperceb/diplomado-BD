--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 24/11/2023
--@Descripción: Ejercicio 10 -módulo 02 .Creación de spfiles, pfile y levantando instancia con
-- nuevos archivos de parámetros generados.

prompt Conectando como sysdba
conn sys/system1 as sysdba

prompt iniciando instancia pfile a través de e-04-pfile.txt
shutdown immediate
startup pfile='e-04-pfile.txt'

set linesize window
prompt verificando que la instancia fue iniciada con PFILE y no spfile
show parameter spfile

accept v_result prompt '¿Que significa ese valor obtenido del parámetro spfile?'
prompt Respuesta: &v_result

prompt Creando nuevo spfile e-05-spfile.ora
create spfile='/unam-diplomado-bd/diplomado-BD/e-05-spfile.ora' from pfile = '/unam-diplomado-bd/diplomado-BD/módulo-02/e-04-pfile.txt';


prompt Creando nuevo pfile para insertar el valor de ruta spfile y poder iniciar la instancia con el spfile
prompt previamente creado
!echo "spfile='/unam-diplomado-bd/diplomado-BD/e-05-spfile.ora'" >> /unam-diplomado-bd/diplomado-BD/e-06-spfile-param.txt

prompt Reiniciando instancia
shutdown immediate 
startup pfile='/unam-diplomado-bd/diplomado-BD/e-06-spfile-param.txt'

prompt Verificando que se inició con spfile
show parameter spfile

accept v_result prompt '¿Que significa ese valor obtenido del parámetro spfile?'
prompt Respuesta: &v_result


