#!/bin/bash
#@Autor: Jorge Francisco Pereda Ceballos
#@Fecha creación: 24/11/2023
#@Descripción: Ejercicio 07 -módulo 02 .Archivo de passwords.Ejecutar como oracle, simula perdida del orapwd y se genera uno nuevo
# en la correspondiente ruta.

archivoPwd='${ORACLE_HOME}/dbs/orapw${ORACLE_SID}'

echo "Moviendo archivo de passwords para simular perdida"
echo "Creando dir de respaldos"
mkdir -p /home/oracle/backups

echo "Moviendo archivo de passwords"
mv ${archivoPwd} /home/oracle/backups

echo "Regenerando archivo de passwords"
orapwd \
file=${archivoPwd} \
format=12.2  \
sys=password

echo "Comprobando la existencia del archivo de passwords"
ls -l "${ORACLE_HOME}/dbs/"