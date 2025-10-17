#!/usr/bin/env bash

CURRENT_DIR=$(realpath "$0")
CURRENT_DIR=$(dirname "${CURRENT_DIR}")
. "${CURRENT_DIR}/common.sh" "$1" "$2" 1

sync_common

. "${CURRENT_DIR}/src/scripts/versions.sh"
. "${CURRENT_DIR}/src/scripts/libraries.sh"

create_versions_cmake

process_file CMakeLists.txt
process_file version.hpp ${PROJECT_NAME}/lib${PROJECT_NAME}/include
process_file version.cpp.in ${PROJECT_NAME}
process_file version.rc.in ${PROJECT_NAME}

update_cmakelists
update_util_sources
