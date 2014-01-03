#!/bin/bash

if [ -z "$FRONTSTACK" ]; then

  export FRONTSTACK="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

  if [ ! -d "${env_path}/packages" ]; then
    mkdir "${env_path}/packages"
    mkdir "${env_path}/packages/ruby"
    chmod -R 775 "${env_path}/packages/" > /dev/null
  fi

  #
  # Autodiscover packages for setting environment variables
  #
  IFS=$'\n'

  for dir in `ls "$FRONTSTACK"`
  do
    if [ -d "$FRONTSTACK/$dir" ]; then
      if [ -d "$FRONTSTACK/$dir/bin" ]; then
        PATH="$FRONTSTACK/$dir/bin:$PATH"
      fi
      if [ -f "$FRONTSTACK/$dir/.setenv" ]; then
        [ ! -x "$FRONTSTACK/$dir/.setenv" ] && chmod +x "$FRONTSTACK/$dir/.setenv"
        . "$FRONTSTACK/$dir/.setenv"
      fi
      # installed packages 
      if [ $dir == 'packages' ]; then
        for subdir in `ls "$FRONTSTACK/$dir"`
        do
          if [ $subdir == 'ruby' ]; then
            if [ -d "$FRONTSTACK/$dir/$subdir/1.9.1/bin" ]; then
              PATH="$FRONTSTACK/$dir/$subdir/1.9.1/bin:$PATH"
            fi
          fi
          if [ -d "$FRONTSTACK/$dir/$subdir/bin" ]; then
            PATH="$FRONTSTACK/$dir/$subdir/bin:$PATH"
          fi
          if [ -f "$FRONTSTACK/$dir/$subdir/.setenv" ]; then
            [ ! -x "$FRONTSTACK/$dir/$subdir/.setenv" ] && chmod +x "$FRONTSTACK/$dir/$subdir/.setenv"
            . "$FRONTSTACK/$dir/$subdir/.setenv"
          fi
        done
      fi
    fi
  done

  export PATH

fi