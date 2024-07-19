--@Autor:          Jorge A. Rodríguez C
--@Fecha creación:  dd/mm/yyyy
--@Descripción:     script principal

--
-- Configurar las siguientes variables en caso de ser necesario
--

whenever sqlerror exit rollback

--usuario de la práctica
define p_usuario=control_medico

--password de la practica
define p_usr_pwd=control_medico

--nombre de la pdb donde se crearán las tablas
define p_pdb1=jpcdip01

--sys
define p_sys_pwd=system1


Prompt =========================================================
Prompt Creando objetos - Control médico -
Prompt Presionar Enter si los valores configurados son correctos.
Prompt De lo contario editar este archvo 
Prompt O en su defecto proporcionar nuevos valores
Prompt =========================================================

Prompt Datos de Entrada:
accept p_usuario default '&&p_usuario' prompt '1. Proporcionar el nombre de usuario que será creado [&&p_usuario]: '
accept p_usr_pwd default '&&p_usr_pwd' prompt '2. Proporcionar password del usuario &&p_usuario [configurado en script]: '
accept p_sys_pwd default '&&p_sys_pwd' prompt '3. Proporcionar password de sys [configurado en script]: '

accept p_pdb1 default '&&p_pdb1' prompt '3. Nombre de la PDB a emplear. [&&p_pdb1]: '

Prompt creando al usuario
connect sys/&&p_sys_pwd@&&p_pdb1 as sysdba
set serveroutput on
@s-02-control-medico-usuario.sql

Prompt conectando como &&p_usuario
connect &&p_usuario/&&p_usr_pwd@&&p_pdb1
set serveroutput on

Prompt creando objetos
@s-03-control-medico-ddl.sql

Prompt cargando Datos
@s-04-control-medico-dml.sql

Prompt confirmando cambios
commit;

Prompt Listo!

whenever sqlerror continue



