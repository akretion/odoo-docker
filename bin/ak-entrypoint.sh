#!/bin/bash

USER_ID=${LOCAL_USER_ID:-999}


# When using docky open the entrypoint is not run
# this mean we do not have the variable mapping from odoo db variable => postgres variable
# as we need to have the postgres always set we use it in docker-compose file and map them to odoo variable

export DB_HOST=${PGHOST}
export DB_PORT=${PGPORT:-5432}
export DB_USER=${PGUSER}
export DB_PASSWORD=${PGPASSWORD}
export DB_NAME=${PGDATABASE}


if [ -z "$(pip list --format=columns | grep "/odoo/src")" ]; then
  # The build runs 'pip install -e' on the odoo/src directory, which creates an
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

# Do not block the entrypoint if pip install fails (only local case)
# so we only exit in case of a failure after pip install
set -Eeuo pipefail
/usr/local/bin/entrypoint.sh "$@"
