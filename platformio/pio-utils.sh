#!/bin/bash
ensure_platformio() {
    if [ -f "$platform_io_bin" ]
    then
        echo "PlatformIO is already installed. Returning."
        return 0
    fi

    temp_dir=$(mktemp -d)
    cd $temp_dir
    curl -fsSL -o get-platformio.py https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py
    python3 get-platformio.py

    cd -
    rm -rf $temp_dir

    if [ -f "$platform_io_bin" ]
    then
        echo "PlatformIO installed"
        return 0
    else
        echo "Unable to install PlatformIO"
        return 1
    fi
}