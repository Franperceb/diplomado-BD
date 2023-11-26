--@Autor:           Jorge Rodríguez
--@Fecha creación:  dd/mm/yyyy
--@Descripción:     Validador

--creando procedimientos para validar.
create or replace procedure spv_valida_datos_instancia is
  cursor cur_consulta is
    select instance_name,host_name,version,version_full,
      startup_time,con_id,instance_mode,edition,
      lower(global_name) as global_name
      from v$instance,global_name;
  v_spfile varchar2(4000);
  v_count number;
begin
  for r in cur_consulta loop
    spv_print_ok('host name ....................'||r.host_name);
    spv_print_ok('startup ......................'
      ||to_char(r.startup_time,'dd/mm/yyyy hh24:mi:ss'));
    spv_print_ok('Global name ..................'||r.global_name);
    spv_print_ok('con id .......................'||r.con_id);
    spv_print_ok('instance mode ................'||r.instance_mode);
    spv_print_ok('edition ......................'||r.edition);

  --valida nombre de la instancia
    spv_assert(instr(lower(r.instance_name),'dip02',1,1) > 0,
      '<iniciales>dip02',r.instance_name,'Nombre de instancia inválido');
    spv_print_ok('Instance name ................'||r.instance_name);
  end loop;

  --verifica la existencia del diccionario
  select count(*) into v_count 
  from all_objects 
  where object_name ='DICTIONARY'
  and owner= 'SYS'
  and object_type='VIEW';

  spv_assert(1 = v_count,1,v_count,'No se encontró Al objeto DICTIONARY');
  spv_print_ok('Objeto Dictionary encontrado');

  --verifica si la instancia fue levantada con un spfile
  select value into v_spfile from v$parameter where name ='spfile';
  spv_assert(v_spfile is not null,'${ORACLE_HOME}/dbs/spfile<ORACLE_SID>.ora',
  'null', 'La instancia no fue levantada con un SPFILE. Reiniciar la instancia
    y reintentar');
  spv_print_ok('Instancia iniciada con SPFILE '||v_spfile);

  --verifica la existencia de paquetes básicos
  select count(*) into v_count from dba_procedures
  where object_type ='PACKAGE'
  and object_name = 'STANDARD';
  spv_assert(v_count>0,'> 0',v_count,'Paquete STANDARD no encontrado');
  spv_print_ok('Objetos del paquete STANDARD encontrados: '||v_count);

  select count(*) into v_count from dba_procedures
  where object_type ='PACKAGE'
  and object_name = 'DBMS_APPLICATION_INFO';
  spv_assert(v_count>0,'> 0',v_count,'Paquete DBMS_APPLICATION_INFO no encontrado');
  spv_print_ok('Objetos del paquete DBMS_APPLICATION_INFO encontrados: '||v_count);
  
  --verifica los objetos asignados al usuario system
  select count(*) into v_count from all_tables
  where table_name='SQLPLUS_PRODUCT_PROFILE'
  and owner='SYSTEM';
  spv_assert(1=v_count,1,v_count,'No se encontró la tabla 
    SYSTEM.SQLPLUS_PRODUCT_PROFILE. Asegurarse de haber ejecutado el script 
    pupbld.sql empleando el usuario SYSTEM.');

  spv_print_ok('Tabla system.SQLPLUS_PRODUCT_PROFILE encontrada');

   select count(*) into v_count from all_objects
   where object_name='PRODUCT_PRIVS' and owner = 'SYSTEM';
  
  spv_assert(1=v_count,1,v_count,'No se encontró la vista 
    SYSTEM.PRODUCT_PRIVS. Asegurarse de haber ejecutado el script 
    pupbld.sql empleando el usuario SYSTEM.');

  spv_print_ok('Vista system.PRODUCT_PRIVS encontrada');

end;
/
show errors

create or replace procedure spv_elimina_usuario(p_usuario varchar2) is
  v_query varchar2(100);
  v_count number;
begin
  v_query := 'drop user '||p_usuario||' cascade';
  select count(*) into v_count  from dba_users where username = upper(p_usuario);
  if v_count > 0 then
    execute immediate v_query; 
  end if;
end;
/
show errors


create or replace procedure spv_crea_usuario_prueba(p_usuario varchar2) is
begin
  execute immediate 'create user '
    ||p_usuario
    ||' identified by ' 
    ||p_usuario
    ||' quota unlimited on users';
  
  spv_print_ok('Usuario de prueba '||p_usuario ||' creado con exito');

end;
/
show errors

Prompt realizando limpieza
exec spv_elimina_usuario('&&p_nombre'||'0201');

--inicia validación
set serveroutput on
whenever sqlerror exit rollback
exec spv_print_header
host sha256sum &&p_script_validador

exec spv_valida_datos_instancia

exec spv_crea_usuario_prueba('&&p_nombre'||'0201')

exec spv_elimina_usuario('&&p_nombre'||'0201');

exec spv_print_ok('Usuario de prueba &&p_nombre eliminado');

exec spv_print_ok('Validación concluida')

exec spv_remove_procedures

whenever sqlerror continue none
exit