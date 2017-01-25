#!/bin/bash

function error_check() {
	if [ $? -eq 1 ]
	then
	  echo "Error encountered... failing..."
	  exit 1
	fi
}

# make ipxe directory to store ipxe disks
mkdir -p build/ipxe

# pull down upstream iPXE
git clone --depth 1 https://github.com/ipxe/ipxe.git ipxe_build

# copy iPXE config overrides into source tree
cp ipxe/local/* ipxe_build/src/config/local/

# copy certs into source tree
# cp script/*.crt ipxe_build/src/

# build iPXE disks
cd ipxe_build/src

# get current iPXE hash
IPXE_HASH=`git log -n 1 --pretty=format:"%H"`

# generate generic iPXE disks
make bin/ipxe.dsk bin/ipxe.iso bin/ipxe.lkrn bin/ipxe.usb bin/ipxe.kpxe bin/undionly.kpxe
mv bin/ipxe.dsk ../../build/ipxe/generic-ipxe.dsk
mv bin/ipxe.iso ../../build/ipxe/generic-ipxe.iso
mv bin/ipxe.lkrn ../../build/ipxe/generic-ipxe.lkrn
mv bin/ipxe.usb ../../build/ipxe/generic-ipxe.usb
mv bin/ipxe.kpxe ../../build/ipxe/generic-ipxe.kpxe
mv bin/undionly.kpxe ../../build/ipxe/generic-undionly.kpxe

# generate netboot.xyz iPXE disks
for ipxe_config in `ls ../../ipxe/disks-gen/`
do 
  make bin/ipxe.dsk bin/ipxe.iso bin/ipxe.lkrn bin/ipxe.usb bin/ipxe.kpxe bin/undionly.kpxe \
  EMBED=../../ipxe/disks-gen/$ipxe_config
  error_check
  mv bin/ipxe.dsk ../../build/ipxe/$ipxe_config.dsk
  mv bin/ipxe.iso ../../build/ipxe/$ipxe_config.iso
  mv bin/ipxe.lkrn ../../build/ipxe/$ipxe_config.lkrn
  mv bin/ipxe.usb ../../build/ipxe/$ipxe_config.usb
  mv bin/ipxe.kpxe ../../build/ipxe/$ipxe_config.kpxe
  mv bin/undionly.kpxe ../../build/ipxe/$ipxe_config-undionly.kpxe
done

# generate EFI iPXE disks
for ipxe_config in `ls ../../ipxe/disks-gen/`
do
  cp config/local/general.h.efi config/local/general.h
  make bin-x86_64-efi/ipxe.efi EMBED=../../ipxe/disks-gen/$ipxe_config
  error_check
  mv bin-x86_64-efi/ipxe.efi ../../build/ipxe/$ipxe_config.efi
done

# return to root
cd ../..