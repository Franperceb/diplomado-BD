#!/bin/bash

mkdir -p /dip/u02
chown root:root /dip
chmod 744 /dip

chown oracle:oracle /dip/u02
chmod 640

echo "db_name=dev" > /dip/u02/initdev.ora
echo "memory_target=3G" >> /dip/u02/initdev.ora
chown oracle:oinstall /dip/u02/initdev.ora
chmod 640 /dip/u02/initdev.ora

su - oracle

sqlplus / as sysdba 
startup nomount pfile='/dip/u02/initdev.ora';
