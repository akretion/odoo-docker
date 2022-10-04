#!/bin/bash

USER_ID=${LOCAL_USER_ID:-999}

if [ -z "$(pip list --format=columns | grep "/odoo/src")" ]; then
  # The build runs 'pip install -e' on the odoo src, which creates an
  # odoo.egg-info directory *inside /odoo/src*. So when we run a container
  # with a volume shared with the host, we don't have this .egg-info (at least
  # the first time).
  # When it happens, we reinstall the odoo python package. We don't want to run
  # the install everytime because it would slow the start of the containers
  echo '/odoo/src/odoo.egg-info is missing, probably because the directory is a volume.'
  echo 'Running pip install -e /odoo/src to restore odoo.egg-info'
  pip install -e /odoo/src
  # As we write in a volume, ensure it has the same user.
  # So when the src is a host volume and we set the LOCAL_USER_ID to be the
  # host user, the files are owned by the host user
  chown -R $USER_ID:$USER_ID /odoo/src/*.egg-info
fi

# Do not block the entrypoint if the pip install fail (only local case)
# so we only exist if fail after the pip install
set -Eeuo pipefail
/usr/local/bin/entrypoint.sh "$@"
