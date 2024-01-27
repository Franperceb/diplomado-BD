Prompt conectando como usuario &p_user/&p_user, creando objetos 
connect &p_user/&p_user 

--tabla que contiene datos aleatorios
create table random_data(
  id number generated always as identity constraint random_data_pk primary key,
  c1_number number(38,0),
  c2_alpha varchar2(1024),
  c3_printable_char varchar2(1024)
) nologging;

--tabla empleada para almacenar conteos por registro
create table data_results(
  id number generated always as identity,
  c1_pattern varchar2(1), 
  c1_count number,
  c2_pattern varchar2(1),
  c2_count number,
  c3_pattern varchar2(1),
  c3_count number
);

--tabla  para almacenar resultados finales
create table  total_results(
  pattern char(1),
  total_count number,
  total_rows number
);

--procedimiento empleado para poblar la tabla de datos
create or replace procedure sp_generate_data is
  v_query varchar2(1000);
  v_c1_number number(38,0);
  v_c2_alpha varchar2(1024);
  v_c3_printable_char varchar2(1024);
begin
  v_query := 'insert /*+ append */ into random_data s(
    c1_number,c2_alpha,c3_printable_char)
    values(:ph1,:ph2,:ph3)
  ';
  for i in 1..1000*50 loop
    v_c1_number:=dbms_random.value(0,99999999999999999999999999999999999999);
    v_c2_alpha:=dbms_random.string('A',1024);
    v_c3_printable_char:=dbms_random.string('P',1024);
    execute immediate v_query using v_c1_number,v_c2_alpha,v_c3_printable_char;
  end loop;
end;
/
show errors

--procedimiento empleado para analizar resultados
create or replace procedure sp_process_data is  
  v_c1_pattern number(1,0);
  v_c2_pattern varchar2(1);
  v_c3_pattern varchar2(1);    
  v_c1_count number;
  v_c2_count number;
  v_c3_count number;
  cursor cur_data is
    select id,c1_number,c2_alpha,c3_printable_char
    from random_data;
  v_query varchar2(1000) := '
    insert into data_results(
      c1_pattern,c1_count,
      c2_pattern,c2_count,
      c3_pattern,c3_count)
    values(:ph1,:ph2,:ph3,:ph4,:ph5,:ph6)
  ';
begin
  v_c1_pattern:=trunc(dbms_random.value(0,10));
  v_c2_pattern:=dbms_random.string('A',1);
  v_c3_pattern:=dbms_random.string('P',1);  
  for r in cur_data loop
    v_c1_count := regexp_count(r.c1_number,v_c1_pattern);
    v_c2_count := regexp_count(r.c2_alpha,v_c2_pattern);
    v_c3_count := regexp_count(r.c3_printable_char,v_c3_pattern);
    execute immediate v_query using 
      v_c1_pattern,v_c1_count,
      v_c2_pattern,v_c2_count,
      v_c3_pattern,v_c3_count;
  end loop;

  --insertando resultados finales
  insert into total_results
    select c1_pattern, sum(c1_count), count(*) from data_results
    group by c1_pattern
    union 
    select c2_pattern, sum(c2_count), count(*) from data_results
    group by c2_pattern
    union
    select c3_pattern, sum(c3_count), count(*) from data_results
    group by c3_pattern;
end;
/
show errors
