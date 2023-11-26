#!/bin/bash
# @Autor Jorge Francisco Pereda Ceballos
# @Fecha 24/11/2023
# @Descripcion Creación de directorios donde se van a almacenar Redo logs
#, control files y data files

echo "Creando directorio para datafiles"
export ORACLE_SID=jpcdip02
cd /u01/app/oracle/oradata
mkdir ${ORACLE_SID^^}
chown oracle:oinstall ${ORACLE_SID^^}
chmod 750 ${ORACLE_SID^^}


echo "Creando directorios de Redo Logs y control files"
cd /unam-diplomado-bd
mkdir -p /unam-diplomado-bd/disk-01/app/oracle/oradata/${ORACLE_SID^^}
chown -R oracle:oinstall disk-*
chmod -R 750 disk-*

cd /unam-diplomado-bd
mkdir -p /unam-diplomado-bd/disk-02/app/oracle/oradata/${ORACLE_SID^^}
chown -R oracle:oinstall disk-*
chmod -R 750 disk-*

cd /unam-diplomado-bd
mkdir -p /unam-diplomado-bd/disk-03/app/oracle/oradata/${ORACLE_SID^^}
chown -R oracle:oinstall disk-*
chmod -R 750 disk-*

 echo "Mostrando directorio de data files"
ls -l /u01/app/oracle/oradata
echo "Mostrando directorios para control files y Redo Logs"
ls -l /unam-diplomado-bd/disk-0*/app/oracle/oradata