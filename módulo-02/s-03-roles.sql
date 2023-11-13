--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 13/11/2023
--@Descripción: Ejercicio 03 -módulo 02 .Administración de roles.
prompt conectando como sysdba
connect sys/system1 as sysdba

prompt 2. creando  los roles web_admin y web_root
create role web_admin_role;
create role web_root_role;

prompt 3. asignando roles
grant create session, create table, create sequence to web_admin_role;

prompt 4. asociar rol web_admin_role para adquirir todos los privs a webo_root_role 
grant web_admin_role to  web_root_role;

prompt 5. Creando j_admin
create user j_admin identified by j_admin quota unlimited on users;

prompt asignando rol web_admin_role a j_admin
grant web_admin_role to j_admin with admin option;

prompt 6. comprobando privilegios para j_admin
connect j_admin/j_admin
accept v_accept prompt '¿Fue posible entrar a sesion con j_admin?'

prompt Respuesta obtenida: &v_accept

prompt 7. Creando usuario j_os_admin
conn sys/system1 as sysdba
create user j_os_admin identified by j_os_admin;

prompt 8. Conectando como j_admin y validar que puede otorgar privilegios (whit admin option)
conn j_admin/j_admin
grant web_admin_role to j_os_admin;

accept v_accept2 prompt '¿Fue posible otorgar el privilegio desde j_admin?'
prompt Respuesta obtenida: &v_accept2

prompt 9. Comprobando que j_os_admin puede crear sesiones
conn j_os_admin/j_os_admin
accept v_accept3 prompt '¿Fue posible entrar a sesion con j_os_admin?'

prompt Respuesta obtenida: &v_accept3

pause  Actividades de limpieza [Enter] para continuar
conn sys/system1 as sysdba
drop user j_admin cascade;
drop user j_os_admin cascade;
drop role web_admin_role;
drop role web_root_role;
prompt Listo!