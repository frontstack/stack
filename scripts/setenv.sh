#!/bin/bash

if [ -z "$FRONTSTACK" ]; then

  export FRONTSTACK="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

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
    fi
  done

  export PATH

fi