#!/bin/bash
FolderPath=$1
cd "$FolderPath"

if [ -f "./package.json" ]
then 
    echo "NODEJS"
elif [ -f "./platformio.ini" ]
then
    echo "PLATFORMIO"
else
    echo "UNKNOWN"
fi
