--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 08/01/2024
--@Descripción: Examen 03 - Módulo 04. Modos de conexión a una instancia:  pruebas.

prompt probando conexiones dedicadas 

prompt conectando con privilegio de administración
conn jorge/jorge@dip_de as sysdba 

prompt conectando sin privilegio de administración
conn jorge/jorge@dip_de

prompt probando conexiones compartidas

prompt conectando con privilegio de administración
conn jorge/jorge@dip_sh as sysdba 

prompt conectando sin privilegio de administración
conn jorge/jorge@dip_sh


prompt probando conexiones pooled 

prompt conectando con privilegio de administración
conn jorge/jorge@dip_pooled as sysdba 
prompt conectando sin privilegio de administración
conn jorge/jorge@dip_pooled

prompt Listo!

