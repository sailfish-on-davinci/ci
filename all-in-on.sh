#!/bin/bash
sudo apt-get update
sudo apt-get install -y \
    openjdk-8-jdk android-tools-adb bc bison \
    build-essential curl flex g++-multilib gcc-multilib gnupg gperf \
    imagemagick lib32ncurses-dev qemu-user-static \
    lib32readline-dev lib32z1-dev  liblz4-tool libncurses5-dev libsdl1.2-dev libssl-dev \
    libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc yasm zip zlib1g-dev \
    qemu-user-static qemu-system-arm e2fsprogs simg2img \
    libtinfo5 libncurses5 gzip virtualenv git python2
mkdir -p ~/bin
wget 'https://storage.googleapis.com/git-repo-downloads/repo' -P ~/bin
chmod +x ~/bin/repo
git config --global user.name "BirdZhang"
git config --global user.email "0312birdzhang@gmail.com"

source hadk.env
mkdir -p $ANDROID_ROOT
cd $ANDROID_ROOT
repo init -u https://github.com/mer-hybris/android.git -b hybris-16.0 --depth=1
repo sync -j8 -c --no-clone-bundle --no-tags
git clone https://github.com/sailfish-on-davinci/android_device_xiaomi_davinci.git $ANDROID_ROOT/device/xiaomi/davinci --depth=1 -b lineage-16.0
git clone https://github.com/sailfish-on-davinci/android_device_xiaomi_sm6150-common $ANDROID_ROOT/device/xiaomi/sm6150-common --depth=1 -b lineage-16.0
git clone https://github.com/sailfish-on-davinci/vendor_xiaomi.git $ANDROID_ROOT/vendor/xiaomi --depth=1 -b lineage-16.0
git clone https://github.com/sailfish-on-davinci/android_kernel_xiaomi_sm6150.git $ANDROID_ROOT/kernel/xiaomi/davinci --depth=1 -b master

rm -rf $ANDROID_ROOT/hybris/hybris-boot
git clone https://github.com/sailfish-on-davinci/hybris-boot.git -b davinci-fixup-mountpoints $ANDROID_ROOT/hybris/hybris-boot --depth=1
git clone https://github.com/sailfish-on-davinci/hybris-installer.git $ANDROID_ROOT/hybris/hybris-installer
git clone --recurse-submodules https://github.com/sailfish-on-davinci/droid-hal-davinci.git $ANDROID_ROOT/rpm --depth=1
git clone --recurse-submodules https://github.com/sailfish-on-davinci/droid-config-davinci.git $ANDROID_ROOT/hybris/droid-configs --depth=1
git clone --recurse-submodules https://github.com/sailfish-on-davinci/droid-hal-version-davinci.git $ANDROID_ROOT/hybris/droid-hal-version-davinci --depth=1

chmod +x build-hal.sh
sudo ln -sf /usr/bin/python2.7 /usr/bin/python
bash build-hal.sh