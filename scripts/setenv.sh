#!/usr/bin/env bash

if [ -z "$FRONTSTACK" ]; then

  export FRONTSTACK="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

  if [ ! -d "$FRONTSTACK/packages" ]; then
    mkdir "$FRONTSTACK/packages"
    mkdir "$FRONTSTACK/packages/ruby"
    chmod -R 775 "$FRONTSTACK/packages/" > /dev/null
  fi

  [ ! -x "${FRONTSTACK}/scripts/bin/frontstack" ] && chmod +x "${FRONTSTACK}/scripts/bin/frontstack"
  [ ! -x "${FRONTSTACK}/scripts/setenv.sh" ] && chmod +x "${FRONTSTACK}/scripts/setenv.sh"
  [ ! -x "${FRONTSTACK}/scripts/update.sh" ] && chmod +x "${FRONTSTACK}/scripts/update.sh"

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