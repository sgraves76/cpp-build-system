#!/usr/bin/env bash

SCRIPTS_DIR=$(dirname "$0")
SCRIPTS_DIR=$(realpath ${SCRIPTS_DIR})

"${SCRIPTS_DIR}/common.sh" unix "$1" "$2" "$3"
