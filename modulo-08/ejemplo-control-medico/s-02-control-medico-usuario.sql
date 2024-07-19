
prompt creando usuario

begin
  execute immediate 'drop user control_medico cascade';
exception
  when others then
    if sqlcode = -1918 then
      dbms_output.put_line('El usuario no existe, será creado');
    else
      raise;
    end if;
end;
/

create user &&p_usuario identified by &&p_usr_pwd quota unlimited on users;
grant create session, create table to &&p_usuario;



