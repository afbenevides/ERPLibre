#!/usr/bin/env bash


. ./env_var.sh


cp ${EL_MANIFEST_DEV}  ./manifest/version_asked.dev.xml
if [ "$#" -ge 1 ]; then
  # There is a first argument so we want another version of odoo then the default 12
  ERPLIBRE_ODOO_VERSION=${1} # Set a default value of 12 if no parameter is passed
  sed -i "s/\(revision=\"[^\".]*\.\)\(12\)\([^\".]*\"\)/\1$ERPLIBRE_ODOO_VERSION\3/g" "./manifest/version_asked.dev.xml"
fi


source .venv/bin/activate
#EL_MANIFEST_PROD="./default.xml"
#EL_MANIFEST_DEV="./manifest/default.dev.xml"

# Update git-repo
git daemon --base-path=. --export-all --reuseaddr --informative-errors --verbose &
DAEMON_PID=$!

./.venv/repo init -u git://127.0.0.1:9418/ -b $(git rev-parse --verify HEAD) -m ./manifest/version_asked.dev.xml
./.venv/repo sync -v --force-sync -m ./manifest/version_asked.dev.xml

kill ${DAEMON_PID}
