    #!/bin/bash
#1 OK
echo "------------ Creando directorios para m05_911_ts"

echo "------------ Creando directorios para datafiles"

dirDatafiles="/disk-mod5"

if [ -d "${dirDatafiles}" ]; then
  read -p "El directorio no esta vacío [ENTER] para borrarlos, Ctrl+c para cancelar"
  rm -rf "${dirDatafiles}"/*
fi;

echo "------------ Cambiando dueño y permisos"

mkdir -p "${dirDatafiles}" #El directorio debe estar vacio
chown oracle:oinstall ${dirDatafiles}
chmod 750 "${dirDatafiles}"

echo "------------ Creando directorios para REDO Logs y control files"

pMontaje01="/u21/app/oracle/oradata/JPCDIP02"
pMontaje02="/u22/app/oracle/oradata/JPCDIP02"
pMontaje03="/u23/app/oracle/oradata/JPCDIP02"
pMontaje04="/u24/app/oracle/oradata/JPCDIP02"
pMontaje05="/u25/app/oracle/oradata/JPCDIP02"
pMontaje06="/u31/app/oracle/oradata/JPCDIP02/"


if [[ -d "${dirDatafiles}${pMontaje01}" || -d "${dirDatafiles}${pMontaje02}" || -d "${dirDatafiles}${pMontaje03}" || -d "${dirDatafiles}${pMontaje04}" || -d "${dirDatafiles}${pMontaje05}" ]]; then
  read -p "Se encontraron directorios, [ENTER] para borrar, Ctrl-c para cancelar"
  rm -rf "${dirDatafiles}"/*
fi;

mkdir -p "${dirDatafiles}${pMontaje01}"
mkdir -p "${dirDatafiles}${pMontaje02}"
mkdir -p "${dirDatafiles}${pMontaje03}"
mkdir -p "${dirDatafiles}${pMontaje04}"
mkdir -p "${dirDatafiles}${pMontaje05}"
mkdir -p "${dirDatafiles}${pMontaje06}"


echo "------------ Cambiando dueño y permisos"
chown -R oracle:oinstall "${dirDatafiles}"/*

chmod -R 750 "${dirDatafiles}"/*

echo "------------ Verificando directorios creados"
tree "${dirDatafiles}"

echo "------------ Validando permisos"
ls -la "${dirDatafiles}"


