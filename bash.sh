#!/bin/bash
#
# Creates a new bash session with the FrontStack environment variables
#

env_path=$(cd "$( dirname "${BASH_SOURCE[0]}")" && pwd)
version=$(head -1 "$env_path/VERSION" | awk '{print $1}')
version_check_url='https://raw.github.com/frontstack/stack/master/VERSION'
version_file='/tmp/frontstack-version'
output='/tmp/frontstack.log'

exists() {
  type $1 >/dev/null 2>&1;
  if [ $? -eq 0 ]; then
    echo 1
  else
    echo 0
  fi
}

clean_files() {
  rm -rf $output
  rm -rf $lastest_version_file
  rm -rf $version_file
}

get_version() {
  if [ ! -f "$1" ]; then
    echo 0
  else
    head -1 "$1" | awk '{print $1}'
  fi
}

echo "Welcome to FrontStack $version"

if [ `exists wget` -eq 1 ]; then
  wget $version_check_url -O $version_file > $output 2>&1
  if [ $? -eq 0 ]; then
    latest_version=`get_version $version_file` 
    if [ $latest_version != $version ]; then
      
      cat <<EOF

New FrontStack version available:
* Local: $version
* Latest: $latest_version

To upgrade your environment, simply run:
$ $env_path/scripts/update.sh

EOF

    fi
  fi
  clean_files
fi

. "${env_path}/scripts/setenv.sh"

export PS1="\e[00;36m\u@frontstack-$version:\W \e[00m\$ "

exec /bin/bash --noprofile --norc
