#!/bin/bash
#
# Creates a new Bash session with the FrontStack environment variables
#
# For continous integration and deployment servers usage
# you can load the isolated FrontStack environment:
# ./scripts/setenv.sh
#

# update config (customize it if you need)
version_check_url='https://raw.github.com/frontstack/stack/master/VERSION'
version_file='/tmp/frontstack-version'
# path variables
env_path=$(cd "$( dirname "${BASH_SOURCE[0]}")" && pwd)
version=$(head -1 "$env_path/VERSION" | awk '{print $1}')
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
  wget --timeout=2 $version_check_url -O $version_file > $output 2>&1
  if [ $? -eq 0 ]; then
    latest_version=`get_version $version_file` 
    if [ $latest_version != $version ]; then
      
      cat <<EOF

New version available:
* Local: $version
* Latest: $latest_version

To upgrade your environment, you should run:
$ sudo $env_path/scripts/update.sh

EOF

    fi
  fi
  clean_files
fi

. "${env_path}/scripts/setenv.sh"

export PS1="\e[00;36m\u@fs-$version:\W \e[00m\$ "

exec /bin/bash --noprofile --norc
