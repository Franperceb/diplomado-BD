#!/bin/bash
##JORGE FRANCISCO PEREDA CEBALLOS
##26-01-2024
##Módulo 05. E-012- Modo Archive.  Generación de directorios donde se almacenaran los archive.

echo "validar ORACLE_SID"
if test "${ORACLE_SID}" == "" 
then
  echo "Variable ORACLE_SID no definida";
  exit 1;
fi;

echo "Creando directorios para Archive Redo Logs";
mkdir -p /unam-diplomado-bd/disk-041/archivelogs/"${ORACLE_SID}"/disk_a
mkdir -p /unam-diplomado-bd/disk-042/archivelogs/"${ORACLE_SID}"/disk_b

cd /unam-diplomado-bd/disk-041
chown -R oracle:oinstall archivelogs
chmod -R 750 archivelogs

cd /unam-diplomado-bd/disk-042
chown -R oracle:oinstall archivelogs
chmod -R 750 archivelogs

echo "Mostrando estructuras de directorios"
tree /unam-diplomado-bd/disk-041 /unam-diplomado-bd/disk-042
ls -l /unam-diplomado-bd/disk-041/archivelogs/"${ORACLE_SID}"/disk_a
ls -l /unam-diplomado-bd/disk-042/archivelogs/"${ORACLE_SID}"/disk_b
