--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 24/11/2023
--@Descripción: Ejercicio 03 -módulo 03 . Modos de shutdown de una instancia. Sesión 2.
connect user01/user01

declare
  v_count number;
begin
  select count(*) into v_count from user_tables where table_name='TEST1';
  if v_count > 0 then
    execute immediate 'drop table test1';
  else
    execute immediate 'create table test1(id number)';
  end if;
end;
/