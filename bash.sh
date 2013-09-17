#!/bin/bash
#
# Creates a new bash session with custom environment variables
#

ENV_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

. "${ENV_PATH}/scripts/setenv.sh"

# Env tools
if [ -d "${ENV_PATH}/../tools/" ]; then
  . "${ENV_PATH}/../tools/scripts/setenv.sh"
fi

#if [ ! -d "${ENV_PATH}/../build/" ]; then
#  mkdir "${ENV_PATH}/../build/"
#fi

exec /bin/bash --noprofile --norc
