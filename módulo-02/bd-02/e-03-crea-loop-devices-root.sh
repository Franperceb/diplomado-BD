#!/bin/bash
# @Autor Jorge Francisco Pereda Ceballos
# @Fecha 24/11/2023
# @Descripcion Creación de loop devices y puntos de montajes

echo "Creando dispositivos con loop devices"
mkdir -p /unam-diplomado-bd/loop-devices

cd /unam-diplomado-bd/loop-devices

echo "creando disk*.img"
dd if=/dev/zero of=disk-01.img bs=100M count=10
dd if=/dev/zero of=disk-02.img bs=100M count=10
dd if=/dev/zero of=disk-03.img bs=100M count=10


echo "Mostrando la creación de los archivos"
du -sh disk*.img

echo "asociando los archivos img a loop devices"
losetup -fP disk-01.img
losetup -fP disk-02.img
losetup -fP disk-03.img

echo "comprobando la asociación de los loop devices"
losetup -a

echo "Dando formato ext4 a los 3 archivos img"
mkfs.ext4 disk-01.img
mkfs.ext4 disk-02.img
mkfs.ext4 disk-03.img

echo "Creando directorios (puntos de montaje)"
mkdir /unam-diplomado-bd/disk-01
mkdir /unam-diplomado-bd/disk-02
mkdir /unam-diplomado-bd/disk-03
