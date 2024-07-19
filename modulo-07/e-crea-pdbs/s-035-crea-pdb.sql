--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 23/02/2024
--@Descripción: Ejercicio 05 - Módulo 07. E05 Unpluging y Plugging de PDBs

--   EJERCICIO
--   Completar el script en las secciones marcadas con TODO
--
Prompt hacer unplug en jpcdip03_s3  -> plug en jpcdip04_s3

--directorios donde están los datafiles
define unplug_jpcdip03_s3='/u01/app/oracle/oradata/JPCDIP03/jpcdip03_s3'
define plug_jpcdip04_s3='/u01/app/oracle/oradata/JPCDIP04/jpcdip04_s3'

prompt Iniciar jpcdip03
!sh s-030-start-cdb.sh jpcdip03 system3

Prompt Connectar a jpcdip03 a cdb$root
connect sys/system3@jpcdip03 as sysdba

Prompt Crear PDB  jpcdip03_s3  a partir de Seed
--TODO: crear PDB 
create pluggable database jpcdip03_s3
  admin user admin_s3 identified by admin_s3
  file_name_convert=(
    '/u01/app/oracle/oradata/JPCDIP03/pdbseed',
    '&unplug_jpcdip03_s3'
  );


Prompt hacer unplug de  jpcdip03_s3, no se requiere cerrarla ya que no ha sido abierta
--TODO: realizar unplug
alter pluggable database jpcdip03_s3 unplug
  into '&unplug_jpcdip03_s3/jpcdip03_s3.xml';


Prompt Mostrando datos de las PDBs
show pdbs

Prompt  Mostrando datos de las PDBs  (dba_pdbs)
col pdb_name format a30
select pdb_id,pdb_name,status from dba_pdbs;
pause Analizar [enter] para continuar

Prompt mostrando metadatos
!chmod 777 &unplug_jpcdip03_s3/jpcdip_s3.xml
!cat &unplug_jpcdip03_s3/jpcdip03_s3.xml

pause Revisar XML, revisar rutas [enter] para continuar


prompt El siguiente paso es hacer plug en jpcdip04

prompt Iniciar jpcdip04
!sh s-030-start-cdb.sh jpcdip04 system4

prompt  Validar compatibilidad, conectando a jpcdip04
connect sys/system4@jpcdip04 as sysdba 

show con_id
show con_name 
-- TODO: Agregar programa PL/SQL --validar compatibilidad de versiones config
set serveroutput on

declare 
  v_compatible boolean;
begin
  v_compatible := dbms_pdb.check_plug_compatibility(
    pdb_descr_file => '&unplug_jpcdip03_s3/jpcdip03_s3.xml',
    pdb_name => 'jpcdip03_s3'
  );

  if v_compatible then
    dbms_output.put_line('PDB jpcdip03_s3 no es compatible con jpcdip04');
  else
    raise_application_error(-20001,'PDB jpcdip03_s3 NO es compatible con jpcdip04');
  end if;
end;
/

pause Validar resultados [enter] para continuar

prompt agregar la nueva PDB
--TODO: Agregar a la nueva PDB
create pluggable database jpcdip04_s3
  using '&unplug_jpcdip03_s3/jpcdip03_s3.xml'
  file_name_convert=(
    '&unplug_jpcdip03_s3',
    '&plug_jpcdip04_s3'
  );

prompt Revisando datafiles en ubicacion origen
!ls -l &unplug_jpcdip03_s3/

pause Analizar resultados [Enter] para continuar 

prompt mostrando datos de las PDBS

show pdbs

select pdb_id,pdb_name,status from dba_pdbs;
pause Analizar [enter] para continuar

prompt Abriendo jpcdip04_s3
alter pluggable database jpcdip04_s3 open read write;

prompt conectar a jpcdip04_s3
alter session set container=jpcdip04_s3;

prompt mostrando datos de la nueva PDB
show con_id
show con_name

pause Analizar resultado [Enter] para comenzar con Limpieza
-----------------------------------------------------------

Prompt eliminar jpcdip03_s3
connect sys/system3@jpcdip03 as sysdba 
--alter pluggable database jpcdip03_s3 close;
drop pluggable database jpcdip03_s3 including datafiles;



Prompt eliminar jpcdip04_s3
connect sys/system4@jpcdip04 as sysdba 
alter pluggable database jpcdip04_s3 close;
drop pluggable database jpcdip04_s3 including datafiles;
Prompt eliminando archivo XML
!rm &unplug_jpcdip03_s3/jpcdip03_s3.xml