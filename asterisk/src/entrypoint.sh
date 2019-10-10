#!/bin/bash
set -x

if [ -z $(ls /etc/asterisk) ]; then
  tar -xvzf /default_config.tar.gz -C /etc/asterisk
  chown -R asterisk:asterisk /etc/asterisk
else
  echo "Next configuration files is already exists:"
  for i in $(ls /etc/asterisk); do
    echo "$i\n"
  done
fi

set +x

exec "$@"
