#!/bin/bash

set -x

source /home/mersdk/work/ci/ci/hadk.env
export ANDROID_ROOT=/home/mersdk/work/ci/ci/hadk_16.0

# sudo chown -R mersdk:mersdk $ANDROID_ROOT
sudo chown -R $(whoami):$(whoami) /home/mersdk/work/ci/ci
cd $ANDROID_ROOT

cd ~/.scratchbox2
cp -R SailfishOS-*-$PORT_ARCH $VENDOR-$DEVICE-$PORT_ARCH
cd $VENDOR-$DEVICE-$PORT_ARCH
sed -i "s/SailfishOS-$SAILFISH_VERSION/$VENDOR-$DEVICE/g" sb2.config
sudo ln -s /srv/mer/targets/SailfishOS-$SAILFISH_VERSION-$PORT_ARCH /srv/mer/targets/$VENDOR-$DEVICE-$PORT_ARCH
sudo ln -s /srv/mer/toolings/SailfishOS-$SAILFISH_VERSION /srv/mer/toolings/$VENDOR-$DEVICE

# 3.3.0.16 hack
sb2 -t $VENDOR-$DEVICE-$PORT_ARCH -m sdk-install -R chmod 777 /boot

sdk-assistant list

cd $ANDROID_ROOT
sed -i '/CONFIG_NETFILTER_XT_MATCH_QTAGUID/d' hybris/mer-kernel-check/mer_verify_kernel_config

sb2 -t $VENDOR-$DEVICE-$PORT_ARCH -m sdk-install -R zypper in -y ccache python
sudo zypper in -y python #dhd a374978b04ac60f1c3088715ec42e4fd02de224a removed python

# dhd hack
cd $ANDROID_ROOT
cp /home/mersdk/work/ci/ci/helpers/*.sh rpm/dhd/helpers/
chmod +x rpm/dhd/helpers/*.sh
git config --global user.email "ci@github.com"
git config --global user.name "Github Actions"
git config --global --add safe.directory /home/mersdk/work/ci/ci
git am --signoff < /home/mersdk/work/ci/ci/0001-Install-files-from-vendor.patch

cd $ANDROID_ROOT
sudo mkdir -p /proc/sys/fs/binfmt_misc/
sudo mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc

rpm/dhd/helpers/build_packages.sh

if [ "$?" -ne 0 ];then
  # if failed, retry once
  rpm/dhd/helpers/build_packages.sh
  # cat $ANDROID_ROOT/droid-hal-$DEVICE.log
fi