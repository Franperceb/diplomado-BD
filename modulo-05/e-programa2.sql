--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 12/01/2024
--@Descripción: Ejercicio 07 - Módulo 05. Programa 2


whenever sqlerror exit rollback
Prompt Conectando como jorge05 para  crear tabla con datos.
connect jorge05/jorge05
set serveroutput on

--Programa 2
declare
  
  v_total_blocks number;
  v_total_bytes number;
  v_unused_blocks  number;
  v_unused_blocks_bytes number;
  v_last_used_extent_file_id number;
  v_last_used_extent_block_id number;
  v_last_used_block number;

begin

/**
   Parámetros del procedimiento
    1. Nombre del esquema
    2. Nombre del objeto
    3. Tipo de objeto. Por ejemplo, TABLE.
    4.  (out) Número total de bloques existentes en el segmento
    5.  (out) Número total de bloques existentes en el segmento en bytes
    6.  (out) Número de bloques que no han sido empleados
    7.  (out) Número de bloques que no han sido empleados en bytes
    8.  (out) Identificador del data file que contiene la última extensión
              que contiene datos.
    9.  (out) Identificador del primer bloque de datos que pertenece a la
              última extensión que contiene datos.s
    10. (out) Identificador del último bloque de datos que contiene datos.
    11 y 12 no relevantes para el curso.
 */
  dbms_space.unused_space (
   segment_owner              => 'JORGE05', 
   segment_name               => 'NUMEROS',
   segment_type               => 'TABLE',
   total_blocks               => v_total_blocks,
   total_bytes                => v_total_bytes,
   unused_blocks              => v_unused_blocks,
   unused_bytes               => v_unused_blocks_bytes,
   last_used_extent_file_id   => v_last_used_extent_file_id,
   last_used_extent_block_id  => v_last_used_extent_block_id,
   last_used_block            => v_last_used_block, 
   partition_name             => null);

   dbms_output.put_line('v_total_blocks:                '||v_total_blocks);
   dbms_output.put_line('v_total_bytes:                 '||v_total_bytes);
   dbms_output.put_line('v_unused_blocks:               '||v_unused_blocks);
   dbms_output.put_line('v_unused_blocks_bytes:         '||v_unused_blocks_bytes);
   dbms_output.put_line('v_last_used_extent_file_id:    '||v_last_used_extent_file_id);
   dbms_output.put_line('v_last_used_extent_block_id:   '||v_last_used_extent_block_id);
   dbms_output.put_line('v_last_used_block:             '||v_last_used_block);

end;
/