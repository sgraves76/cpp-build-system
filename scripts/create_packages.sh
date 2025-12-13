#!/usr/bin/env bash

SCRIPTS_DIR=$(dirname "$0")
SCRIPTS_DIR=$(realpath ${SCRIPTS_DIR})

CURRENT_DIR=${SCRIPTS_DIR}/..
CURRENT_DIR=$(realpath "${CURRENT_DIR}")

. "${CURRENT_DIR}/src/scripts/versions.sh"
. "${CURRENT_DIR}/src/scripts/libraries.sh"

function check_should_update() {
  local NAME=$1
  local ITEM_LIST=(${PROJECT_DOWNLOADS[${NAME}]//;/ })
  if [ ! -f "${CURRENT_DIR}/support/${ITEM_LIST[2]}/${ITEM_LIST[1]}" ] ||
    [ ! -f "${CURRENT_DIR}/support/${ITEM_LIST[2]}/${ITEM_LIST[1]}.sha256" ]; then
    return 0
  fi

  return 1
}

function download_and_update_hash() {
  local NAME=$1
  local ITEM_LIST=(${PROJECT_DOWNLOADS[${NAME}]//;/ })
  if [ ! -f "${CURRENT_DIR}/support/${ITEM_LIST[2]}/${ITEM_LIST[1]}" ] ||
    [ ! -f "${CURRENT_DIR}/support/${ITEM_LIST[2]}/${ITEM_LIST[1]}.sha256" ]; then
    local CLEANUP_LIST=(${PROJECT_CLEANUP[${NAME}]//:/ })
    if [ "${NAME}" == "GTEST" ]; then
      CLEANUP_LIST=(${PROJECT_CLEANUP["TESTING"]//:/ })
    fi

    if [ "${NAME}" != "BOOST" ] && [ "${NAME}" != "BOOST2" ] && [ "${CLEANUP_LIST[0]}" != "" ]; then
      rm -r ${CURRENT_DIR}/support/${CLEANUP_LIST[0]}
    fi

    rm -f "${CURRENT_DIR}/support/${ITEM_LIST[2]}/${ITEM_LIST[1]}"
    rm -f "${CURRENT_DIR}/support/${ITEM_LIST[2]}/${ITEM_LIST[1]}.sha256"

    if ! wget ${ITEM_LIST[0]} -O "${CURRENT_DIR}/support/${ITEM_LIST[2]}/${ITEM_LIST[1]}"; then
      echo "failed $NAME"
      rm -f "${CURRENT_DIR}/support/${ITEM_LIST[2]}/${ITEM_LIST[1]}"
      exit 1
    fi
    pushd "${CURRENT_DIR}/support/${ITEM_LIST[2]}"
    sha256sum ${ITEM_LIST[1]} >${ITEM_LIST[1]}.sha256
    popd
  fi

  local HASH=$(cat support/${ITEM_LIST[2]}/${ITEM_LIST[1]}.sha256 | awk '{print $1}')
  HASH_LIST+=("set(${NAME}_HASH ${HASH})")
}

function create_hashes_cmake() {
  for NAME in "${!PROJECT_DOWNLOADS[@]}"; do
    if [ "${NAME}" != "BOOST" ] && [ "${NAME}" != "BOOST2" ]; then
      download_and_update_hash $NAME
    fi
  done
}

pushd "${CURRENT_DIR}"
HASH_LIST=()
create_hashes_cmake

if check_should_update BOOST || check_should_update BOOST2; then
  rm -f support/3rd_party/boost_*
fi

download_and_update_hash BOOST
download_and_update_hash BOOST2

(printf "%s\n" "${HASH_LIST[@]}" | sort) >${CURRENT_DIR}/cmake/hashes.cmake
popd
