#!/bin/bash

mkdir -p build/menu

# Prepare menus
cat src/boot.cfg | sed "s/<<tool_hash>>/$(ipfs add -qr src/tool | tail -1)/g" > build/menu/boot.cfg
cp -R src/menu/* build/menu

# Prepare iPXE config
mkdir -p ipxe/disks-gen

for ipxe_config in `ls ipxe/disks/`
do
  cp ipxe/disks/$ipxe_config ipxe/disks-gen/$ipxe_config
  sed -i 's/<<conntype>>/http/g' ipxe/disks-gen/$ipxe_config
  sed -i 's/<<ipfs_gateway>>/ipfs.local:8080\/ipfs/g' ipxe/disks-gen/$ipxe_config
  sed -i "s/<<ipfs_hash>>/$(ipfs add -qr build/menu | tail -1)/g" ipxe/disks-gen/$ipxe_config
done

./script/build_ipxe.sh

# rm -rf ipxe/disks-gen

# generate mkdocs
mkdocs build
