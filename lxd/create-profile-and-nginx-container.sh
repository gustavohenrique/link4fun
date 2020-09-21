#!/bin/sh

container=${1:-nginx}
name=nginx
workspace=`realpath $PWD/..`
lxc profile create ${name}
cat ${name}.profile | sed -e "s,\$WORKSPACE,$workspace,g" | lxc profile edit ${name}
lxc profile add ${container} ${name} 
