#!/bin/bash
build_scripts_dir="$(dirname "$(readlink -f "$0")")"

repo=$1
registry_path=$2

# Create a temp dir for this build
build_temp_dir=$(mktemp -d)
echo "Building in $build_temp_dir"
cd $build_temp_dir


cleanup() {
    if [ "$SKIP_CLEANUP" != "" ]
    then
        echo "Skipping cleanup because SKIP_CLEANUP is set"
        return 0
    fi
    cd /tmp
    rm -rf $build_temp_dir
}

# Clone the repo first
git clone $repo
for i in `ls`; do [ -d "$i" ] && cd "$i"; done

platform=$($build_scripts_dir/get-build-platform.sh ./)
echo "platform is $platform"

if [[ "$platform" == "NODEJS" ]]
then
    $build_scripts_dir/nodejs/build-node-app.sh ./ $registry_path
elif [[ "$platform" == "PLATFORMIO" ]]
then
    $build_scripts_dir/platformio/build-pio-bin.sh ./ $registry_path
fi

cleanup
echo "Done!"