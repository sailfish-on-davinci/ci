#!/bin/bash
set -x

source hadk.env
cd $ANDROID_ROOT
source build/envsetup.sh 2>&1
breakfast $DEVICE

# jdk
# /usr/lib/jvm/java-8-openjdk-amd64/
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar




# hack for droidmedia
cd external/droidmedia
git checkout 0.20230605.1
cd $ANDROID_ROOT
# echo 'DROIDMEDIA_32 := true' >> external/droidmedia/env.mk
# echo 'FORCE_HAL:=1' >> external/droidmedia/env.mk
echo 'MINIMEDIA_AUDIOPOLICYSERVICE_ENABLE := 1' >> external/droidmedia/env.mk
echo 'AUDIOPOLICYSERVICE_ENABLE := 1' >> external/droidmedia/env.mk

cd $ANDROID_ROOT/external
git clone --recurse-submodules https://github.com/mer-hybris/libhybris.git
# hybris-patches
cd $ANDROID_ROOT
hybris-patches/apply-patches.sh --mb

make -j$(nproc --all) hybris-hal droidmedia