#!/bin/bash

archivoPwd="${ORACLE_HOME}/dbs/orapw${ORACLE_SID}"

echo "Moviendo archivo de passwords para simular perdida"
echo "Creando dir de respaldos"
mkdir -p /home/oracle/backups

echo "Moviendo archivo de passwords"
mvn ${archivoPwd}/home/oracle/backups

echo "Regenerando archivo de passwords"
orapwd \
file='${archivoPwd}' \
format=12.2  \
sys=password

echo "Comprobando la existencia del archivo de passwords"
ls -l ${archivoPwd}