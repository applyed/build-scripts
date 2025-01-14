#!/bin/bash
platform_io_bin="/home/codespace/.platformio/penv/bin/platformio"
build_scripts_dir="$(dirname "$(readlink -f "$0")")"
. $build_scripts_dir/pio-utils.sh

project_path=$(readlink -f "$1")
registry_path=$2
cd $project_path

project_name=$(basename $project_path)
project_version_from_ini=$(awk -F "=" '/SOFTWARE_VERSION/ {print substr($2, 3, length($2) - 4)}' platformio.ini)

echo "Building  $project_name:$project_version_from_ini"

ensure_platformio

if [ "$?" -eq "1" ]
then
    echo "Build failure.."
    exit
fi

$platform_io_bin run

echo "$registry_path/$project_name-ESP12E-$project_version_from_ini.bin"

if [ -f "./.pio/build/nodemcuv2/firmware.bin" ]
then
    echo "ESP12-E build found; Copying..."
    cp ./.pio/build/nodemcuv2/firmware.bin "$registry_path/$project_name-ESP12E-$project_version_from_ini.bin"
else
    echo "***ESP12-E build not found***"
fi
if [ -f "./.pio/build/seeed_xiao_esp32c3/firmware.bin" ]
then
    echo "ESP32-C3 build found; Copying..."
    cp ./.pio/build/seeed_xiao_esp32c3/firmware.bin "$registry_path/$project_name-ESP32C3-$project_version_from_ini.bin"
else
    echo "***ESP32-C3 build not found***"
fi
if [ -f "./.pio/build/seeed_xiao_esp32s3/firmware.bin" ]
then
    echo "ESP32-S3 build found; Copying..."
    cp ./.pio/build/seeed_xiao_esp32s3/firmware.bin "$registry_path/$project_name-ESP32S3-$project_version_from_ini.bin"
else
    echo "***ESP32-S3 build not found***"
fi

