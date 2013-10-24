#!/bin/bash
#
# FrontStack environment update script
# @license WTFPL
# 

root="$( cd "$( dirname "$0" )/.." && pwd )"
download_url='http://sourceforge.net/projects/frontstack/files/releases'
check_url='https://raw.github.com/frontstack/stack/master/VERSION'
output='/tmp/frontstack.log'
download_dir='/tmp'
version_file="$root/VERSION"
download_status='/tmp/frontstack-download'
lastest_version_file='/tmp/frontstack-latest'

clean_files() {
  rm -rf $output
  rm -rf $lastest_version_file
  rm -rf $download_dir/frontstack-latest.tar.gz
  rm -rf $download_status
}

check_exit() {
  if [ $? -ne 0 ]; then
    clean_files
    echo $1
    exit 1
  fi
}

get_version() {
	if [ ! -f "$1" ]; then
    echo 0
  else
    head -1 "$1" | awk '{print $1}'
  fi
}

get_download_file() {
  if [ ! -f "$1" ]; then
    echo 0
  else
    head -1 "$1" | awk '{print $2}'
  fi
}

download_status() {
  if [ -f $1 ]; then
    while : ; do
      sleep 1

      local speed=$(echo `cat $1 | grep -oh '\([0-9.]\+[%].*[0-9.][s|m|h|d]\)' | tail -1`)
      echo -n "Downloading... $speed"
      echo -n R | tr 'R' '\r'

      if [ -f $2 ]; then
        sleep 1
        local error=$(echo `cat $2`)
        if [ $error != '0' ]; then
          echo 
          if [ $error == '6' ]; then
            echo "Server authentication error, configure setup.ini properly. See $output"
          else
            echo "Download error, exit code '$error'. See $output"
          fi
          exit $?
        fi
        break
      fi
    done
  fi
}

clean_files

wget http://yahoo.com -O /tmp/test.log > $output 2>&1
check_exit "No Internet HTTP connectivity. Check if you are behind a proxy. See /tmp/test.log"
rm -f /tmp/test.log

version=`get_version $version_file` 
if [ $version == '0' ]; then 
  echo 'Warning: cannot check the local FrontStack version'
  read -p 'Do you want to proceed anyway? [y/N]: ' res
  if [ $res != 'y' ] && [ $res != 'Y' ]; then
    echo 'Exiting' && exit 0
  fi
fi

wget $check_url -O $lastest_version_file >> $output 2>&1
check_exit "Cannot check the latest version. See $output"
latest_version=`get_version $lastest_version_file`
[ $latest_version == '0' ] && echo "Latest version file don't exists. Check the Internet connectivity" && exit 1

if [ $latest_version == $version ]; then
  echo 'Your FrontStack environment is up to date' && exit 0
fi 

echo 'New FrontStack version available:'
echo "* Local: $version"
echo "* Latest: $latest_version"
# show version release notes
tail -n+'2' "/tmp/frontstack-latest"

echo 
echo 
read -p "Do you want to upgrade to $latest_version? [y/N]: " res
if [ $res != 'y' ] && [ $res != 'Y' ]; then
  echo 'Exiting' && exit 0
fi

if [ ! -w $root ]; then
  echo "The current user (`whoami`) does not have write permissions. Required" && exit 1
fi

echo 
echo 'IMPORTANT: '
echo 'Before continue, be sure you kill all the FrontStack running processes...'
read -p 'Yes, I done, continue with the update... ' 

echo
`wget -F "$download_url/$(get_download_file $lastest_version_file)/download" -O $download_dir/frontstack-latest.tar.gz > $output 2>&1 && echo $? > $download_status || echo $? > $download_status` &
download_status $output $download_status
check_exit "Error while trying to download FrontStack. See $output"

cd $root
echo 
echo 
read -p 'Do you want to backup the current FrontStack version? [y/N]: ' res
if [ ! -z $res ]; then
  if [ $res == 'y' ] || [ $res == 'Y' ]; then
    backup_file=/tmp/frontstack-$version-backup-`date +%Y%m%d"-"%H%M%S`.tar.gz
    echo 
    echo "Backing up to '$backup_file'"
    tar cvzf $backup_file * > $output 2>&1
    check_exit "Error while backing up FrontStack. See $output"
  fi
fi

echo 
echo 'Cleaning old version...'
rm -rf `ls $root | grep -v 'packages$'`
check_exit "Cannot remove the old version in $root. Check directories permissions or do it manually"

echo 
echo 'Installing new version...'
echo "tar xvfz $download_dir/frontstack-latest.tar.gz -C $root"
tar xvfz $download_dir/frontstack-latest.tar.gz -C $root > $output 2>&1
check_exit "Error while extracting files. Be sure you have write permissions. See $output"

clean_files

echo 
echo "FrontStack $latest_version installed successfully!"
