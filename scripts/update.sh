#!/usr/bin/env bash
#
# FrontStack environment update script
# @license WTFPL
# 

cwd=`pwd`
download_url='http://sourceforge.net/projects/frontstack/files/releases'
check_url='https://raw.github.com/frontstack/stack/master/VERSION'
download_dir='/tmp'
output="${download_dir}/frontstack.log"
download_status="${download_dir}/frontstack-download"
lastest_version_file="${download_dir}/frontstack-latest"
force=0

get_basepath() {
  local basepath="$( cd "$( dirname "$0" )/../" && pwd )"
  if [ -f "${basepath}/VERSION" ]; then
    echo $basepath
  else
    echo "$( cd "$( dirname "$0" )/../../" && pwd )"
  fi
}

clean_files() {
  rm -rf $output
  rm -rf $lastest_version_file
  rm -rf $download_dir/frontstack-latest.tar.gz
  rm -rf $download_status
}

check_exit() {
  if [ $? -ne 0 ]; then
    clean_files
    while [ -n "$1" ]; do
       echo $ARGS "$1"
       shift
    done
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

is_url() {
  protocol="$(echo $1 | grep :// | sed -e's,^\(.*://\).*,\1,g')"
  if [ -z $protocol ]; then
    echo 1
  else 
    echo 0
  fi
}

get_download_file() {
  if [ ! -f "$1" ]; then
    echo 0
  else
    local file=`head -1 "$1" | awk '{print $2}'`
    if [ `is_url "$file"` -eq 0 ]; then
      echo $file
    else
      echo "${download_url}/${file}/download" 
    fi    
  fi
}

download_status() {
  if [ -f $1 ]; then
    while : ; do
      sleep 1

      local speed=$(echo `cat $1 | grep -oh '\([0-9.]\+[%].*[0-9.][s|m|h|d]\)' | tail -1`)
      echo -n ">> Downloading... $speed"
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

basepath=`get_basepath $0`
version_file="$basepath/VERSION"
version=`get_version $version_file`

# force update without asking
case $2 in
  force|--force|-f)
    force=1
  ;;
esac

if [ -z $version ]; then 
  echo 'Warning: cannot check the local FrontStack version'
  if [ $force -eq 0 ]; then
    read -p 'Do you want to proceed anyway? [y/N]: ' res
    if [ $res != 'y' ] && [ $res != 'Y' ]; then
      echo 'Exiting' && exit 0
    fi
  fi
fi

clean_files

echo -n 'Checking new versions...'
echo -n R | tr 'R' '\r' 
# download the remote manifest file
wget --no-check-certificate $check_url -O $lastest_version_file >> $output 2>&1
check_exit "Cannot check the latest version, are you behind a web proxy?" "Remote version manifest: $check_url" "Output log: $output"
latest_version=`get_version $lastest_version_file`
[ $latest_version == '0' ] && echo "Latest version file don't exists. Check the Internet connectivity" && exit 1

if [ $latest_version == $version ]; then
  echo 'FrontStack is up to date' && exit 0
fi 

echo
echo 'New FrontStack version is available'
echo "* Local: $version"
echo "* Latest: $latest_version"
# show version release notes
tail -n+'2' "/tmp/frontstack-latest"

echo 
echo
if [ $force -eq 0 ]; then
  read -p "Do you want to upgrade to $latest_version? [y/N]: " res
  [ -z $res ]; echo 'Canceled' && exit 0
  [ $res != 'y' ] && [ $res != 'Y' ] && [ $res != 'yes' ]; echo 'Canceled' && exit 0
fi

if [ ! -w $basepath ]; then
  echo "The current user (`whoami`) does not have write permissions. Required" && exit 1
fi

echo 
echo 'IMPORTANT: '
echo 'Be sure you stop all the FrontStack running processes...'
echo
read -p 'Yes, I done, continue with the update... [press enter] '

echo
`wget --no-check-certificate -F "$(get_download_file $lastest_version_file)" -O $download_dir/frontstack-latest.tar.gz > $output 2>&1 && echo $? > $download_status || echo $? > $download_status` &
download_status $output $download_status
check_exit "Error while trying to download FrontStack. See $output"

if [ $force -eq 0 ]; then 
  echo
  echo
  read -p 'Do you want to backup the current installed version? [y/N]: ' res
  if [ ! -z $res ]; then
    if [ $res != 'n' ] && [ $res != 'N' ] && [ $res != 'no' ]; then
      cd $basepath
      backup_file=/tmp/frontstack-$version-backup-`date +%Y%m%d"-"%H%M%S`.tar.gz
      echo 
      echo "Creating backup in: '$backup_file'"
      tar cvzf $backup_file * > $output 2>&1
      check_exit "Error while backing up FrontStack. See $output"
      cd $cwd
    fi
  fi
fi

echo 
echo 'Cleaning old version...'
rm -rf `ls $basepath | grep -v 'packages$'`
check_exit "Cannot remove the old version in $basepath" "Check file permissions and try it again"

echo
echo 'Installing new version...'
[ ! -d $basepath ]; mkdir -p $basepath
tar xvfz $download_dir/frontstack-latest.tar.gz -C $basepath > $output 2>&1
check_exit "Error while extracting files. Be sure you have write permissions. See $output"

clean_files

echo 
echo "FrontStack $latest_version installed successfully!"
