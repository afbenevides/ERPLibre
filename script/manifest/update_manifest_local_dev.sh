#!/usr/bin/env bash

. ./env_var.sh

cp ${EL_MANIFEST_DEV} ./manifest/version_asked.dev.xml
if [ "$#" -ge 1 ]; then
  # There is a first argument so we want another version of odoo then the default 12
  ERPLIBRE_ODOO_VERSION=${1-12} # Set a default value of 12 if no parameter is passed
  echo "ERPLIBRE_ODOO_VERSION est : ${ERPLIBRE_ODOO_VERSION}"
  if [[ "$(uname)" == "Darwin" ]]; then
    # macOS
    echo "In darwin !!!"
    sed -i.bak 's/\(revision="[^"]*\)12\([^"]*"\)/\1'"${ERPLIBRE_ODOO_VERSION}"'\2/g' ./manifest/version_asked.dev.xml
  else
    # Linux
    sed -i "s/\(revision=\"[^\".]*\.\)\(12\)\([^\".]*\"\)/\1${ERPLIBRE_ODOO_VERSION}\3/g" "./manifest/version_asked.dev.xml"
  fi
  read -p "Press Enter to continue..." # wait for user input
  git status
  git add -A
  echo "AFTER ADD"
  git status

  read -p "Press Enter to continue..." # wait for user input
  git commit -m "modified for odoo version wanted : ${ERPLIBRE_ODOO_VERSION} "
  git status
  git rev-parse --verify HEAD
  read -p "Press Enter to continue..." # wait for user input

fi

#TODO add a commit here after modificaiton, if not it wont be taken in account by repo checkout step

#TODO add the part that go make available all the versions of odoo other then the default one... one do it in a manual step before that.

source .venv/bin/activate
#EL_MANIFEST_PROD="./default.xml"
#EL_MANIFEST_DEV="./manifest/default.dev.xml"

# Update git-repo
git daemon --base-path=. --export-all --reuseaddr --informative-errors --verbose &
DAEMON_PID=$!
echo "Execution de COMMANDE   git ls-remote git://127.0.0.1:9418/"


git ls-remote git://127.0.0.1:9418/

  echo "Execution de repo"
./.venv/repo init -u git://127.0.0.1:9418/ -b $(git rev-parse --verify HEAD) -m ./manifest/version_asked.dev.xml
  echo "Synch de repo"

./.venv/repo sync -v --force-sync -m "./manifest/version_asked.dev.xml"

kill ${DAEMON_PID}
