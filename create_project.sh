#!/usr/bin/env bash

CURRENT_DIR=$(realpath "$0")
CURRENT_DIR=$(dirname "${CURRENT_DIR}")
. "${CURRENT_DIR}/common.sh" "$1" "$2" 0

pushd "${DEST_DIR}"
git init . || error_exit "failed to execute 'git init .'" 1
popd

sync_common
sync_create

. "${CURRENT_DIR}/src/scripts/versions.sh"
. "${CURRENT_DIR}/src/scripts/libraries.sh"

create_versions_cmake

process_file .jenkins_builds
process_file .jenkins_macos
process_file .nvimrc
process_file CMakeLists.txt
process_file config.sh
process_file initialize.hpp ${PROJECT_NAME}/lib${PROJECT_NAME}/include
process_file initialize.cpp ${PROJECT_NAME}/lib${PROJECT_NAME}/src
process_file main.cpp ${PROJECT_NAME}/${PROJECT_NAME}
process_file main_test.cpp ${PROJECT_NAME}/${PROJECT_NAME}_test
process_file project.cmake
process_file version.hpp ${PROJECT_NAME}/lib${PROJECT_NAME}/include
process_file version.cpp.in ${PROJECT_NAME}
process_file version.rc.in ${PROJECT_NAME}

update_config
update_cmakelists

echo "" >>"${DEST_DIR}/.cspell/words.txt"
echo lib${PROJECT_NAME} >>"${DEST_DIR}/.cspell/words.txt"

update_util_sources

pushd "${DEST_DIR}"
git lfs track "*.exe"
git lfs track "*.msi"
git lfs track "*.tar.gz"
git lfs track "*.tar.xz"
git lfs track "*.tgz"
git lfs track "*.zip"
git add .gitattributes
git commit -m "Added .gitattributes"
popd
