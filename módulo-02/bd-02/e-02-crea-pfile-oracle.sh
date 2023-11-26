#!/bin/bash
# @Autor Jorge Francisco Pereda Ceballos
# @Fecha 24/11/2023
# @Descripcion Creación del PFILE

echo "1. Creando un archivo de parámetros básico"
export ORACLE_SID=jpcdip02
pfile=$ORACLE_HOME/dbs/init${ORACLE_SID}.ora

if [ -f "${pfile}" ]; then
read -p "El archivo ${pfile} ya existe, [enter] para sobrescribir"
fi;
echo \
"db_name='${ORACLE_SID}' \
memory_target=768M \
control_files=(/unam-diplomado-bd/disk-01/app/oracle/oradata/${ORACLE_SID^^}/control01.ctl, \
    /unam-diplomado-bd/disk-02/app/oracle/oradata/${ORACLE_SID^^}/control02.ctl, \
    /unam-diplomado-bd/disk-03/app/oracle/oradata/${ORACLE_SID^^}/control03.ctl) \
" >$pfile 

echo "Listo"
echo "Comprobando la existencia y contenido del PFILE"
echo ""
cat ${pfile}