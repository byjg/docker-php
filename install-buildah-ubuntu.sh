#!/bin/bash

set -e

if [[ "$UID" -ne 0 ]]; then
  echo "Need to run as root"
  exit 2
fi

# python3 virtualenv

. /etc/os-release
apt-get update -qq
apt install -qq -y wget gnupg gnupg2 gnupg1
sh -c "echo 'deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/x${ID^}_${VERSION_ID}/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list"
wget -nv https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/x${ID^}_${VERSION_ID}/Release.key -O Release.key
apt-key add - < Release.key
apt-get update -qq
apt-get -qq -y install buildah

#apt-get -qq -y install qemu binfmt-support qemu-user-static
#if [ ! -d /proc/sys/fs/binfmt_misc ]; then
#    echo "No binfmt support in the kernel."
#    exit 1
#fi
#if [ ! -f /proc/sys/fs/binfmt_misc/register ]; then
#    mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc
#fi
#wget https://raw.githubusercontent.com/qemu/qemu/master/scripts/qemu-binfmt-conf.sh -O qemu-binfmt-conf.sh
#chmod a+x qemu-binfmt-conf.sh
#find /proc/sys/fs/binfmt_misc -type f -name 'qemu-*' -exec sh -c 'echo -1 > {}' \;
#./qemu-binfmt-conf.sh --qemu-suffix "-static" --qemu-path "/usr/bin"