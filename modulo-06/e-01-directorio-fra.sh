#!/bin/bash
##@Autor: Jorge Francisco Pereda Ceballos
##@Fecha creación: 26/01/2024
##@Descripción: Ejercicio 01 -01- Módulo 06. Creacion de directorios para el Fast Recovery Area.


echo "1.- Creando directorio para la FRA"
mkdir -p /unam-diplomado-bd/fast-recovery-area

echo "2.- Cambiando permidos al directorio creado"
chown oracle:oinstall /unam-diplomado-bd/fast-recovery-area
chmod 777 /unam-diplomado-bd/fast-recovery-area

echo "3.- Mostrando estructura de directorios"
tree /unam-diplomado-bd/fast-recovery-area