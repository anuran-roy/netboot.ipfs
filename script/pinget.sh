#!/bin/bash

MODE="ipfs"
CUR="ipfs"

while getopts "hwic" opt; do
  case $opt in
    h)
      echo "./pinlist [-hwi]" >&2
      echo "    -h  This help"
      echo "    -w  Download from WWW"
      echo "    -i  Interactive"
      echo "    -c  Check hashes"
      exit 0
      ;;
    w)
      MODE="www"
      CUR="www"
      ;;
    c)
      MODE="check"
      CUR="check"
      ;;
    i)
      MODE="interactive"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

log() {
	echo -e "\e[32m> " $@ "\e[39m" 
}

logerr() {
    echo -e "\e[31m> " $@ "\e[39m" 
}

pinbegin() {
	log "Begin processing $1"
	mkdir -p dltmp/$1
    case $MODE in
        interactive)
            IOPTS=("skip" "ipfs" "www" "check")
            select opt in "${IOPTS[@]}"; do case $opt in
                "skip")
                    CUR="skip"
                    break
                    ;;
                "ipfs")
                    CUR="ipfs"
                    break
                    ;;
                "www")
                    CUR="www"
                    break
                    ;;
                "check")
                    CUR="check"
                    break
                    ;;
                *) echo "invalid option";;
            esac; done
            ;;
    esac
}

pinget() {
    case $CUR in
        www)
            log "Getting $1/$3"
            cd dltmp
            mkdir -p $(dirname $1/$3)
            wget -c $2 -O $1/$3
            # log "Pinning $1/$3"
            # HASH=$(ipfs add -q "$1/$3")
            # log "$1/$3 IS $HASH"
            cd ..
            ;;
        ipfs)
            ;;
    esac	
}

pinroot() {
	
    case $CUR in
        www)
            log "Pin $1 root"
            HASH=$(ipfs add -qr "dltmp/$1" | tr ' ' '\n' | tail -1)
            log "$1 IS $HASH"
            ;;
        ipfs)
            log "Pin $1 from $2"
            ipfs pin add $2
            ;;
        check)
            HASH=$(ipfs add -nqr "dltmp/$1" | tr ' ' '\n' | tail -1)
            if [ "$HASH" == "$2" ]; then
                log "OK: $1 is $2"
            else
                logerr "!! $1 changed to $HASH"
            fi
            ;;
    esac
}

antergos_version=17.1

pinbegin "antergos"
pinget "antergos" "http://antergos.x86innovations.com/iso/release/antergos-minimal-${antergos_version}-x86_64.iso" "x86_64.iso"
pinget "antergos" "http://antergos.x86innovations.com/iso/release/antergos-minimal-${antergos_version}-x86_64.iso.sig" "x86_64.iso.sig"
pinroot "antergos" "QmcdEKcFC76iu3gpJNA4LkZigDvkXLCXfHRWFthiXaCKeY"

pinbegin "architect"
pinget "architect" "https://sourceforge.net/projects/architect-linux/files/latest/download" "architect.iso"
pinroot "architect" "QmSNkGZVi3B5dcZNgAbsjY2Me9H9m4M9KXWpwH3Vw5rYMi"

pinbegin "archlinux"
ARCH_MIRROR="mirror.rackspace.com"
ARCH_VERSIONS=("2016.11.01" "2016.12.01" "2017.01.01")
for v in "${ARCH_VERSIONS[@]}"; do
    pinget "archlinux" "https://${ARCH_MIRROR}/archlinux/iso/${v}/arch/boot/i686/vmlinuz"                   "${v}/arch/boot/i686/vmlinuz"
    pinget "archlinux" "https://${ARCH_MIRROR}/archlinux/iso/${v}/arch/boot/i686/vmlinuz.ipxe.sig"          "${v}/arch/boot/i686/vmlinuz.ipke.sig"
    pinget "archlinux" "https://${ARCH_MIRROR}/archlinux/iso/${v}/arch/boot/i686/archiso.img"               "${v}/arch/boot/i686/archiso.img"
    pinget "archlinux" "https://${ARCH_MIRROR}/archlinux/iso/${v}/arch/boot/i686/archiso.img.ipxe.sig"      "${v}/arch/boot/i686/archiso.img.ipxe.sig"
    pinget "archlinux" "https://${ARCH_MIRROR}/archlinux/iso/${v}/arch/boot/x86_64/vmlinuz"                 "${v}/arch/boot/x86_64/vmlinuz"
    pinget "archlinux" "https://${ARCH_MIRROR}/archlinux/iso/${v}/arch/boot/x86_64/vmlinuz"                 "${v}/arch/boot/x86_64/vmlinuz.ipxe.sig"
    pinget "archlinux" "https://${ARCH_MIRROR}/archlinux/iso/${v}/arch/boot/x86_64/archiso.img"             "${v}/arch/boot/x86_64/archiso.img"
    pinget "archlinux" "https://${ARCH_MIRROR}/archlinux/iso/${v}/arch/boot/x86_64/archiso.img.ipxe.sig"    "${v}/arch/boot/x86_64/archiso.img.ipxe.sig"

    pinget "archlinux" "https://${ARCH_MIRROR}/archlinux/iso/${v}/arch/x86_64/airootfs.sfs"             "${v}/arch/x86_64/airootfs.sfs"
    pinget "archlinux" "https://${ARCH_MIRROR}/archlinux/iso/${v}/arch/x86_64/airootfs.md5"             "${v}/arch/x86_64/airootfs.md5"
    pinget "archlinux" "https://${ARCH_MIRROR}/archlinux/iso/${v}/arch/x86_64/airootfs.sfs.sig"         "${v}/arch/x86_64/airootfs.sfs.sig"
    pinget "archlinux" "https://${ARCH_MIRROR}/archlinux/iso/${v}/arch/i686/airootfs.sfs"               "${v}/arch/i686/airootfs.sfs"
    pinget "archlinux" "https://${ARCH_MIRROR}/archlinux/iso/${v}/arch/i686/airootfs.md5"               "${v}/arch/i686/airootfs.md5"
    pinget "archlinux" "https://${ARCH_MIRROR}/archlinux/iso/${v}/arch/i686/airootfs.sfs.sig"           "${v}/arch/i686/airootfs.sfs.sig"
done
pinroot "archlinux" "QmaQW2AWCfdYd63wRo6ndotvwQbUXjtLrFcGNRbQ3HEHq8"

blackarch_version=2016.12.29
pinbegin "blackarch"
pinget "blackarch" "https://www.mirrorservice.org/sites/blackarch.org/blackarch/iso/blackarchlinux-netinst-${blackarch_version}-x86_64.iso" "blackarch.iso"
pinroot "blackarch" "QmeqEoYw8tFd2g5uNxa3DrKFrawM5GLXxMFkYX3maNWXsx"

pinbegin "coreos"
pinget "coreos" "https://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe.vmlinuz"        "stable/coreos_production_pxe.vmlinuz"
pinget "coreos" "https://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe_image.cpio.gz"  "stable/coreos_production_pxe_image.cpio.gz"
pinget "coreos" "https://beta.release.core-os.net/amd64-usr/current/coreos_production_pxe.vmlinuz"          "beta/coreos_production_pxe.vmlinuz"
pinget "coreos" "https://beta.release.core-os.net/amd64-usr/current/coreos_production_pxe_image.cpio.gz"    "beta/coreos_production_pxe_image.cpio.gz"
pinget "coreos" "https://alpha.release.core-os.net/amd64-usr/current/coreos_production_pxe.vmlinuz"         "alpha/coreos_production_pxe.vmlinuz"
pinget "coreos" "https://alpha.release.core-os.net/amd64-usr/current/coreos_production_pxe_image.cpio.gz"   "alpha/coreos_production_pxe_image.cpio.gz"
pinroot "coreos" "QmcNTZZMdJmo3xcZesyqovFG2zznznhTeLtiQSb91E4hcq"

pinbegin "debian"
DEBIAN_MIRROR="mirror.rackspace.com"
DEBIAN_VERSIONS=("jessie" "wheezy" "stretch" "sid")
DEBIAN_ARCH=("i386" "amd64")
for v in "${DEBIAN_VERSIONS[@]}"; do
    for a in "${DEBIAN_ARCH[@]}"; do
        pinget "debian" "https://${DEBIAN_MIRROR}/debian/dists/${v}/main/installer-${a}/current/images/netboot/gtk/debian-installer/${a}/initrd.gz" "debian/dists/${v}/main/installer-${a}/current/images/netboot/gtk/debian-installer/${a}/initrd.gz"
        pinget "debian" "https://${DEBIAN_MIRROR}/debian/dists/${v}/main/installer-${a}/current/images/netboot/gtk/debian-installer/${a}/linux"     "debian/dists/${v}/main/installer-${a}/current/images/netboot/gtk/debian-installer/${a}/linux"
        pinget "debian" "https://${DEBIAN_MIRROR}/debian/dists/${v}/main/installer-${a}/current/images/netboot/debian-installer/${a}/initrd.gz"     "debian/dists/${v}/main/installer-${a}/current/images/netboot/debian-installer/${a}/initrd.gz"
        pinget "debian" "https://${DEBIAN_MIRROR}/debian/dists/${v}/main/installer-${a}/current/images/netboot/debian-installer/${a}/linux"         "debian/dists/${v}/main/installer-${a}/current/images/netboot/debian-installer/${a}/linux"
    done
done
pinroot "debian" "QmYiGyZbVYTJfWX4KgVPs16qH8N8oLvBCEk6RQSJNDxSpE"

pinbegin "freebsd"
pinget "freebsd" "http://boot.rackspace.com/distros/freebsd/10.2/FreeBSD-10.2-RELEASE-i386-bootonly-mfsbsd.hd"  "10.2/FreeBSD-10.2-RELEASE-i386-bootonly-mfsbsd.hd"
pinget "freebsd" "http://boot.rackspace.com/distros/freebsd/10.2/FreeBSD-10.2-RELEASE-amd64-bootonly-mfsbsd.hd" "10.2/FreeBSD-10.2-RELEASE-amd64-bootonly-mfsbsd.hd"
pinget "freebsd" "http://boot.rackspace.com/distros/freebsd/10.1/FreeBSD-10.1-RELEASE-i386-bootonly-mfsbsd.hd"  "10.1/FreeBSD-10.1-RELEASE-i386-bootonly-mfsbsd.hd"
pinget "freebsd" "http://boot.rackspace.com/distros/freebsd/10.1/FreeBSD-10.1-RELEASE-amd64-bootonly-mfsbsd.hd" "10.1/FreeBSD-10.1-RELEASE-amd64-bootonly-mfsbsd.hd"
pinget "freebsd" "http://boot.rackspace.com/distros/freebsd/10.0/FreeBSD-10.0-RELEASE-i386-bootonly-mfsbsd.hd"  "10.0/FreeBSD-10.0-RELEASE-i386-bootonly-mfsbsd.hd"
pinget "freebsd" "http://boot.rackspace.com/distros/freebsd/10.0/FreeBSD-10.0-RELEASE-amd64-bootonly-mfsbsd.hd" "10.0/FreeBSD-10.0-RELEASE-amd64-bootonly-mfsbsd.hd"
pinroot "freebsd" "QmRAZoUtQVMP8UWnrGiwbPozA45UygeJTCuzebfn8TpcYJ" #No i386

pinbegin "freedos"
pinget "freedos" "http://www.freedos.org/download/download/fd11src.iso" "fd11src.iso"
pinroot "freedos" "QmZeqm9JyhWEPyXuTcnFEcWH1w8a91HdpF5meVoAeL1Dwy"

pinbegin "gentoo"
pinget "gentoo" "https://sourceforge.net/projects/netboot-xyz/files/distros/gentoo/amd64/20160204/kernel/download" "linux"
pinget "gentoo" "https://sourceforge.net/projects/netboot-xyz/files/distros/gentoo/amd64/20160204/initrd/download" "initrd"
pinroot "gentoo" "QmXb3cSBd9Bpu8WEpD7QstP7tGzEvB1kQdcbnRNCJakf4B"

pinbegin "mirbsd"
pinget "mirbsd" "https://www.mirbsd.org/MirOS/current/bsd4me.com"               "bsd4me.com"
pinget "mirbsd" "https://www.mirbsd.org/MirOS/current/bsd4me.rd"                "bsd4me.rd"
pinget "mirbsd" "https://www.mirbsd.org/MirOS/webstuff/netboot.xyz/boot.cfg"    "boot.cfg"
pinroot "mirbsd" "QmSi5JcpTWoD1sgTJV8rxq9B1KmFGNFnZ3uL3mv5KN79rP"

pinbegin "openbsd"
pinget "openbsd" "http://ftp.openbsd.org/pub/OpenBSD/6.0/i386/cd60.iso"         "6.0/i386/cd60.iso"
pinget "openbsd" "http://ftp.openbsd.org/pub/OpenBSD/6.0/i386/SHA256"           "6.0/i386/SHA256"
pinget "openbsd" "http://ftp.openbsd.org/pub/OpenBSD/6.0/i386/SHA256.sig"       "6.0/i386/SHA256.sig"

pinget "openbsd" "http://ftp.openbsd.org/pub/OpenBSD/6.0/amd64/cd60.iso"        "6.0/amd64/cd60.iso"
pinget "openbsd" "http://ftp.openbsd.org/pub/OpenBSD/6.0/amd64/SHA256"          "6.0/amd64/SHA256"
pinget "openbsd" "http://ftp.openbsd.org/pub/OpenBSD/6.0/amd64/SHA256.sig"      "6.0/amd64/SHA256.sig"

pinget "openbsd" "http://ftp.openbsd.org/pub/OpenBSD/snapshots/i386/cd60.iso"      "snapshots/i386/cd60.iso"
pinget "openbsd" "http://ftp.openbsd.org/pub/OpenBSD/snapshots/i386/SHA256"        "snapshots/i386/SHA256"
pinget "openbsd" "http://ftp.openbsd.org/pub/OpenBSD/snapshots/i386/SHA256.sig"    "snapshots/i386/SHA256.sig"

pinget "openbsd" "http://ftp.openbsd.org/pub/OpenBSD/snapshots/amd64/cd60.iso"      "snapshots/amd64/cd60.iso"
pinget "openbsd" "http://ftp.openbsd.org/pub/OpenBSD/snapshots/amd64/SHA256"        "snapshots/amd64/SHA256"
pinget "openbsd" "http://ftp.openbsd.org/pub/OpenBSD/snapshots/amd64/SHA256.sig"    "snapshots/amd64/SHA256.sig"

pinget "openbsd" "http://ftp.openbsd.org/pub/OpenBSD/5.9/i386/cd59.iso"         "5.9/i386/cd59.iso"
pinget "openbsd" "http://ftp.openbsd.org/pub/OpenBSD/5.9/i386/SHA256"           "5.9/i386/SHA256"
pinget "openbsd" "http://ftp.openbsd.org/pub/OpenBSD/5.9/i386/SHA256.sig"       "5.9/i386/SHA256.sig"

pinget "openbsd" "http://ftp.openbsd.org/pub/OpenBSD/5.9/amd64/cd59.iso"        "5.9/amd64/cd59.iso"
pinget "openbsd" "http://ftp.openbsd.org/pub/OpenBSD/5.9/amd64/SHA256"          "5.9/amd64/SHA256"
pinget "openbsd" "http://ftp.openbsd.org/pub/OpenBSD/5.9/amd64/SHA256.sig"      "5.9/amd64/SHA256.sig"
pinroot "openbsd" "QmURkhDNJi9ZgouwD7HVB1uEn5YXjibCiBdFHkak9M4BAo"

pinbegin "opensuse"
pinget "opensuse" "https://mirror.rackspace.com/opensuse/distribution/12.2/repo/oss/boot/i386/loader/linux"     "12.2/repo/oss/boot/i386/loader/linux"
pinget "opensuse" "https://mirror.rackspace.com/opensuse/distribution/12.2/repo/oss/boot/i386/loader/initrd"    "12.2/repo/oss/boot/i386/loader/initrd"
pinget "opensuse" "https://mirror.rackspace.com/opensuse/distribution/12.2/repo/oss/boot/x86_64/loader/linux"   "12.2/repo/oss/boot/x86_64/loader/linux"
pinget "opensuse" "https://mirror.rackspace.com/opensuse/distribution/12.2/repo/oss/boot/x86_64/loader/initrd"  "12.2/repo/oss/boot/x86_64/loader/initrd"

pinget "opensuse" "https://mirror.rackspace.com/opensuse/distribution/12.3/repo/oss/boot/i386/loader/linux"     "12.3/repo/oss/boot/i386/loader/linux"
pinget "opensuse" "https://mirror.rackspace.com/opensuse/distribution/12.3/repo/oss/boot/i386/loader/initrd"    "12.3/repo/oss/boot/i386/loader/initrd"
pinget "opensuse" "https://mirror.rackspace.com/opensuse/distribution/12.3/repo/oss/boot/x86_64/loader/linux"   "12.3/repo/oss/boot/x86_64/loader/linux"
pinget "opensuse" "https://mirror.rackspace.com/opensuse/distribution/12.3/repo/oss/boot/x86_64/loader/initrd"  "12.3/repo/oss/boot/x86_64/loader/initrd"

pinget "opensuse" "https://mirror.rackspace.com/opensuse/distribution/13.1/repo/oss/boot/i386/loader/linux"     "13.1/repo/oss/boot/i386/loader/linux"
pinget "opensuse" "https://mirror.rackspace.com/opensuse/distribution/13.1/repo/oss/boot/i386/loader/initrd"    "13.1/repo/oss/boot/i386/loader/initrd"
pinget "opensuse" "https://mirror.rackspace.com/opensuse/distribution/13.1/repo/oss/boot/x86_64/loader/linux"   "13.1/repo/oss/boot/x86_64/loader/linux"
pinget "opensuse" "https://mirror.rackspace.com/opensuse/distribution/13.1/repo/oss/boot/x86_64/loader/initrd"  "13.1/repo/oss/boot/x86_64/loader/initrd"

pinget "opensuse" "https://mirror.rackspace.com/opensuse/distribution/13.2/repo/oss/boot/i386/loader/linux"     "13.2/repo/oss/boot/i386/loader/linux"
pinget "opensuse" "https://mirror.rackspace.com/opensuse/distribution/13.2/repo/oss/boot/i386/loader/initrd"    "13.2/repo/oss/boot/i386/loader/initrd"
pinget "opensuse" "https://mirror.rackspace.com/opensuse/distribution/13.2/repo/oss/boot/x86_64/loader/linux"   "13.2/repo/oss/boot/x86_64/loader/linux"
pinget "opensuse" "https://mirror.rackspace.com/opensuse/distribution/13.2/repo/oss/boot/x86_64/loader/initrd"  "13.2/repo/oss/boot/x86_64/loader/initrd"

pinget "opensuse" "https://mirror.rackspace.com/opensuse/distribution/leap/42.1/repo/oss/boot/x86_64/loader/linux"   "42.1/repo/oss/boot/x86_64/loader/linux"
pinget "opensuse" "https://mirror.rackspace.com/opensuse/distribution/leap/42.1/repo/oss/boot/x86_64/loader/initrd"  "42.1/repo/oss/boot/x86_64/loader/initrd"

pinget "opensuse" "https://mirror.rackspace.com/opensuse/distribution/leap/42.2/repo/oss/boot/x86_64/loader/linux"   "42.2/repo/oss/boot/x86_64/loader/linux"
pinget "opensuse" "https://mirror.rackspace.com/opensuse/distribution/leap/42.2/repo/oss/boot/x86_64/loader/initrd"  "42.2/repo/oss/boot/x86_64/loader/initrd"

pinget "opensuse" "http://download.opensuse.org/tumbleweed/repo/oss/boot/x86_64/loader/linux"   "tumbleweed/repo/oss/boot/x86_64/loader/linux"
pinget "opensuse" "http://download.opensuse.org/tumbleweed/repo/oss/boot/x86_64/loader/initrd"  "tumbleweed/repo/oss/boot/x86_64/loader/initrd"
pinroot "opensuse" "QmXc9Bh86vxSEBk1aN7xixbBEPCW8tv5U2dvEanjPSTdQh"

pinbegin "parrotsec"
parrotsec_version=3.4.1
pinget "parrotsec" "http://mirrordirector.archive.parrotsec.org/parrot/pool/iso/3.4.1/Parrot-netboot-${parrotsec_version}_amd64.iso" "Parrot-netboot-${parrotsec_version}_amd64.iso"

pinroot "parrotsec" "QmWMedjnaY8sexzFYRRKf2oq6HR1rsn7UF7DHxPDsKf6C2"

pinbegin "utils"
clonezilla_version=2.4.7-8
sysrcdpath="sourceforge.net/projects/netboot-xyz/files/distros/sysresccd-x86/4.8.1"
pinget "utils" "http://download.avg.com/filedir/inst/avg_arl_cdi_all_120_150814a10442.iso"                              "avg_arl_cdi_all_120_150814a10442.iso"
pinget "utils" "https://sourceforge.net/projects/clonezilla/files/clonezilla_live_stable/${clonezilla_version}/clonezilla-live-${clonezilla_version}-amd64.iso/download" "clonezilla-live-${clonezilla_version}-amd64.iso"
pinget "utils" "https://sourceforge.net/projects/dban/files/dban/dban-2.3.0/dban-2.3.0_i586.iso/download"               "dban-2.3.0_i586.iso"
pinget "utils" "https://sourceforge.net/projects/gparted/files/gparted-live-stable/0.26.0-1/gparted-live-0.26.0-1-amd64.iso/download" "gparted-live-0.26.0-1-amd64.iso"
pinget "utils" "http://mirror.23media.de/grml//devel/grml64-full_20160415_netboot_xyz.iso"                              "grml64-full_20160415_netboot_xyz.iso"
pinget "utils" "http://mirror.23media.de/grml//devel/grml64-small_20160415_netboot_xyz.iso"                             "grml64-small_20160415_netboot_xyz.iso"
pinget "utils" "http://www.hdt-project.org/raw-attachment/wiki/hdt-0.5.0/hdt-0.5.2.iso"                                 "hdt-0.5.2.iso"
pinget "utils" "https://boot.netboot.xyz/utils/memtest86-4.20.bin"                                                      "memtest86-4.20.bin"
pinget "utils" "https://boot.netboot.xyz/utils/memtest86-5.01.bin"                                                      "memtest86-5.01.bin"
pinget "utils" "https://www.partitionwizard.com/download/pwfree91-x64.iso"                                              "pwfree91-x64.iso"
pinget "utils" "https://pogostick.net/~pnh/ntpasswd/cd140201.zip"                                                       "cd140201.zip"
pinget "utils" "https://sourceforge.net/projects/supergrub2/files/2.02s4/super_grub2_disk_hybrid_2.02s4.iso/download"   "super_grub2_disk_hybrid_2.02s4.iso"
pinget "utils" "https://${sysrcdpath}/altker64/download"                                                                "sysrcd/altker64"
pinget "utils" "https://${sysrcdpath}/initram.igz/download"                                                             "sysrcd/initram.igz"
pinget "utils" "https://${sysrcdpath}/sysrcd.dat/download"                                                              "sysrcd/sysrcd.dat"
pinget "utils" "http://mirror.sysadminguide.net/ubcd/ubcd535.iso"                                                       "ubcd535.iso"
pinroot "utils" "QmUSV82U6pnfAimCFQviLUYq43MxDvZkqDBMvTn7Gz1hmN"

pinbegin "xenserver"
pinget "xenserver" "http://downloadns.citrix.com.edgesuite.net/11419/pxe/release/6.5.0/boot/xen"        "boot/xen"
pinget "xenserver" "http://downloadns.citrix.com.edgesuite.net/11419/pxe/release/6.5.0/boot/vmlinuz"    "boot/vmlinuz"
pinget "xenserver" "http://downloadns.citrix.com.edgesuite.net/11419/pxe/release/6.5.0/install.img"     "install.img"
pinroot "xenserver" "Qmenm7Ftf5bDbKUasgs8ErSzC3n5Jz3Mcn1GSgA4A3Cgna"
