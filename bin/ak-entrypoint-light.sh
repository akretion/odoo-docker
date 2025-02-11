#!/bin/bash
set -Eeuo pipefail

# When using docky open the bedrock entrypoint is not run
# and so the PG variable are not initialized with the odoo variable
# to have a working postgresql-client working without setting odoo and PG variable
# it simplier to use native PG variable and map them to odoo
# So in docker-compose.yml only set the PG variable and it will work

export DB_HOST=${PGHOST}
export DB_PORT=${PGPORT:-5432}
export DB_USER=${PGUSER}
export DB_PASSWORD=${PGPASSWORD}
export DB_NAME=${PGDATABASE}

/usr/local/bin/entrypoint.sh "$@"
