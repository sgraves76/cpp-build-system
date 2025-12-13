#!/usr/bin/env bash

CURRENT_DIR=$(realpath "$0")
CURRENT_DIR=$(dirname "${CURRENT_DIR}")

. "${CURRENT_DIR}/src/scripts/versions.sh"
. "${CURRENT_DIR}/src/scripts/libraries.sh"

function download_package() {
  local NAME=$1
  local ITEM_LIST=(${PROJECT_DOWNLOADS[${NAME}]//;/ })
  if [ ! -f "${CURRENT_DIR}/support/${ITEM_LIST[2]}/${ITEM_LIST[1]}" ]; then
    rm -f "${CURRENT_DIR}/support/${ITEM_LIST[2]}/${ITEM_LIST[1]}"

    if ! wget ${ITEM_LIST[0]} -O "${CURRENT_DIR}/support/${ITEM_LIST[2]}/${ITEM_LIST[1]}"; then
      echo "failed $NAME"
      rm -f "${CURRENT_DIR}/support/${ITEM_LIST[2]}/${ITEM_LIST[1]}"
      exit 1
    fi

    pushd "${CURRENT_DIR}/support/${ITEM_LIST[2]}/"
    if ! sha256sum -c "${CURRENT_DIR}/support/${ITEM_LIST[2]}/${ITEM_LIST[1]}.sha256"; then
      rm -f "${CURRENT_DIR}/support/${ITEM_LIST[2]}/${ITEM_LIST[1]}"
      echo "failed sha256 validation: $NAME"
      exit 1
    fi
    popd
  fi
}

function download_packages() {
  for NAME in "${!PROJECT_DOWNLOADS[@]}"; do
    download_package $NAME
  done
}

pushd "${CURRENT_DIR}"
download_packages
popd
