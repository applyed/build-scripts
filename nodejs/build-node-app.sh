#!/bin/bash
project_path=$1
docker_registry=$2
cd "$project_path"

project_name=`cat package.json | jq -r .name`
project_version=`cat package.json | jq -r .version`

docker build -t $project_name:$project_version .
docker tag $project_name:$project_version $project_name

if [ "$docker_registry" != "" ]
then
    docker tag $project_name $docker_registry/$project_name
    docker push $docker_registry/$project_name
    echo "will tag and push"
else
    echo "no docker registry provided"
fi
