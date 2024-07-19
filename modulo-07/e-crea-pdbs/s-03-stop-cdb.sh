#!/bin/bash

# Script encargado de detener una cdb. Recibe 2 parámetros: 
# - nombre de la CDB (db_name)
# - password  (No hacer esto en un sistema real)
# Se realiza una conexión local

#parámetro 1
cdb="${1}"

if [ -z "${cdb}" ]; then
  echo "ERROR: indicar el CDB name (db_name) a detener:  ./s030-stop-cdb.sh <db_name> <pwd>"
  exit 1;
fi;

#parámetro 2
pwd="${2}"

if [ -z "${pwd}" ]; then
  echo "ERROR: indicar password de SYS: ./s030-stop-cdb.sh <db_name> <pwd>"
  exit 1;
fi;


echo "Deteniendo CDB ${cdb}"
export ORACLE_SID="${cdb}"
sqlplus sys/${pwd} as sysdba <<EOF
 shutdown immediate
 exit;
EOF