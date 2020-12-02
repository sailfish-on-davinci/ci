#!/bin/bash
source hadk.env
cd $ANDROID_ROOT
source build/envsetup.sh 2>&1
breakfast $DEVICE

echo "clean .repo folder"
rm -rf $ANDROID_ROOT/.repo

# hack for droidmedia
echo 'DROIDMEDIA_32 := true' >> external/droidmedia/env.mk
echo 'FORCE_HAL:=1' >> external/droidmedia/env.mk
echo 'MINIMEDIA_AUDIOPOLICYSERVICE_ENABLE := 1' >> external/droidmedia/env.mk
echo 'AUDIOPOLICYSERVICE_ENABLE := 1' >> external/droidmedia/env.mk

# hybris-patches
./hybris-patches/apply-patches.sh --mb

make -j$(nproc --all) hybris-hal $(external/droidmedia/detect_build_targets.sh $PORT_ARCH $(gettargetarch))