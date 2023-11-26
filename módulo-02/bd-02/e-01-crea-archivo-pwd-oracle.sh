#!/bin/bash
# @Autor Jorge Francisco Pereda Ceballos
# @Fecha 24/11/2023
# @Descripcion Creación del archivo de passwords.

echo "Creando archivo de passwords"
echo "configurando ORACLE_SID"

export ORACLE_SID="jpcdip02"

echo "Creando orapwdfile, se sobreescribe si existe"

orapwd FORCE=Y \
FILE='${ORACLE_HOME}/dbs/orapwjpcdip02' \
FORMAT=12.2 \
SYS=password

echo "comprobando creación del archivo de passwords"
ls -l ${ORACLE_HOME}/dbs/orapw${ORACLE_SID}


