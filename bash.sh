#!/bin/bash
#
# Creates a new bash session with the FrontStack environment variables
#

env_path=$(cd "$( dirname "$0")" && pwd)
version=$(head -1 "$env_path/VERSION" | awk '{print $1}')

. "${env_path}/scripts/setenv.sh"

echo "Welcome to FrontStack $version"

export PS1="\e[00;36m\u@frontstack-$version:\W \e[00m\$ "

exec /bin/bash --noprofile