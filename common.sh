#!/usr/bin/env bash

PROJECT_NAME=$1
DEST_DIR=$2
IS_UPDATE=$3
PROJECT_NAME_UPPER=$(echo ${PROJECT_NAME} | tr "[:lower:]" "[:upper:]")

if [ "$(uname -s)" == "Darwin" ]; then
  PROJECT_IS_DARWIN=1
  export SED=gsed
else
  export SED=sed
fi

function error_exit() {
  echo $1
  exit $2
}

function update_file() {
  local FILE=$1
  ${SED} -i "s/FIFTHGRID_/${PROJECT_NAME_UPPER}_/g" "${FILE}"
  ${SED} -i "s/fifthgrid/${PROJECT_NAME}/g" "${FILE}"
}

function update_util_sources() {
  for FILE in $(find ${DEST_DIR}/support/include/ -type f -name "*.hpp"); do
    update_file "${FILE}"
  done

  for FILE in $(find ${DEST_DIR}/support/src/ -type f -name "*.cpp"); do
    update_file "${FILE}"
  done

  for FILE in $(find ${DEST_DIR}/support/test/ -type f -name "*.hpp"); do
    update_file "${FILE}"
  done

  for FILE in $(find ${DEST_DIR}/support/test/ -type f -name "*.cpp"); do
    update_file "${FILE}"
  done
}

function process_file() {
  local FILE_NAME=$1
  local SRC_FILE_NAME=$1
  if [ "$2" != "" ]; then
    local DEST_PART=/$2
  fi
  if [ "${FILE_NAME}" == "CMakeLists.txt" ]; then
    local SRC_FILE_NAME="CMakeLists.txt_"
  fi
  if [ "${FILE_NAME}" == "main_test.cpp" ]; then
    local DEST_FILE=${DEST_DIR}${DEST_PART}/main.cpp
  else
    local DEST_FILE=${DEST_DIR}${DEST_PART}/${FILE_NAME}
  fi

  rsync -av --progress src/${SRC_FILE_NAME} "${DEST_FILE}" ||
    error_exit "failed to copy ${FILE_NAME}" 1

  ${SED} -i s/%PROJECT_NAME%/${PROJECT_NAME}/g "${DEST_FILE}" ||
    error_exit "failed to set project name in ${DEST_FILE}" 1

  ${SED} -i s/fifthgrid/${PROJECT_NAME}/g "${DEST_FILE}" ||
    error_exit "failed to set project name in ${DEST_FILE}" 1

  ${SED} -i s/FIFTHGRID_/${PROJECT_NAME_UPPER}_/g "${DEST_FILE}" ||
    error_exit "failed to set project name in ${DEST_FILE}" 1
}

function update_cmakelists() {
  for PROJECT_LIBRARY in "${PROJECT_LIBRARIES[@]}"; do
    ENABLE_NAME=PROJECT_ENABLE_${PROJECT_LIBRARY}
    KEEP_NAME=PROJECT_KEEP_${PROJECT_LIBRARY}
    ${SED} -i "/%PROJECT_ENABLE%/i \ \ \ \ \ \ -D${ENABLE_NAME}=\$\{${ENABLE_NAME}\}" "${DEST_DIR}/CMakeLists.txt" ||
      error_exit "failed to set ${ENABLE_NAME} to ${!ENABLE_NAME} in ${DEST_DIR}/CMakeLists.txt" 1
  done

  ${SED} -i "/%PROJECT_ENABLE%/d" "${DEST_DIR}/CMakeLists.txt" ||
    error_exit "failed to delete %PROJECT_ENABLE% in ${DEST_DIR}/CMakeLists.txt" 1
}

function update_config() {
  for PROJECT_LIBRARY in "${PROJECT_LIBRARIES[@]}"; do
    ENABLE_NAME=PROJECT_ENABLE_${PROJECT_LIBRARY}
    KEEP_NAME=PROJECT_KEEP_${PROJECT_LIBRARY}
    if [ "${PROJECT_LIBRARY}" == "TESTING" ]; then
      ${SED} -i "/%PROJECT_ENABLE%/i ${ENABLE_NAME}=ON" "${DEST_DIR}/config.sh" ||
        error_exit "failed to set ${ENABLE_NAME} to ON in ${DEST_DIR}/config.sh" 1
    else
      ${SED} -i "/%PROJECT_ENABLE%/i ${ENABLE_NAME}=OFF" "${DEST_DIR}/config.sh" ||
        error_exit "failed to set ${ENABLE_NAME} to OFF in ${DEST_DIR}/config.sh" 1
    fi
  done

  ${SED} -i "/%PROJECT_ENABLE%/d" "${DEST_DIR}/config.sh" ||
    error_exit "failed to delete %PROJECT_ENABLE% in ${DEST_DIR}/config.sh" 1
}

function sync_common() {
  rsync -av --progress .clang* "${DEST_DIR}/" ||
    error_exit "failed to copy .clang*" 1

  rsync -avh --delete --progress cmake/ "${DEST_DIR}/cmake/" ||
    error_exit "failed to copy cmake/" 1

  rsync -avh --delete --progress docker/ "${DEST_DIR}/docker/" ||
    error_exit "failed to copy docker/" 1

  rsync -avh --delete --progress src/scripts/ "${DEST_DIR}/scripts/" ||
    error_exit "failed to copy src/scripts/" 1

  rsync -avh --delete --progress support/ "${DEST_DIR}/support/" ||
    error_exit "failed to copy support/" 1
}

function sync_create() {
  rsync -avh --delete --progress .cspell/* "${DEST_DIR}/.cspell/" ||
    error_exit "failed to copy .cpsell/" 1

  rsync -av --progress .gitignore "${DEST_DIR}/" ||
    error_exit "failed to copy .gitignore" 1
}

function create_versions_cmake() {
  VERSION_LIST=()
  for NAME in "${!PROJECT_VERSIONS[@]}"; do
    VERSION_LIST+=("set(${NAME}_VERSION ${PROJECT_VERSIONS[${NAME}]})")
  done
  (printf "%s\n" "${VERSION_LIST[@]}" | sort) >${DEST_DIR}/cmake/versions.cmake
}

if [ "${PROJECT_NAME}" == "" ]; then
  error_exit "missing project name" 2
else
  if [ "${DEST_DIR}" == "" ]; then
    DEST_DIR=${CURRENT_DIR}
  fi
  DEST_DIR=${DEST_DIR}/${PROJECT_NAME}

  if [ "${IS_UPDATE}" == "0" ] && [ -d "${DEST_DIR}" ]; then
    error_exit "dest directory already exists: ${DEST_DIR}" 2
  fi

  mkdir -p "${DEST_DIR}"
  DEST_DIR=$(realpath "${DEST_DIR}")
  if [ "${IS_UPDATE}" == "1" ] && [ ! -d "${DEST_DIR}" ]; then
    error_exit "dest directory not found: ${DEST_DIR}" 2
  fi
fi

mkdir -p "${DEST_DIR}/${PROJECT_NAME}/${PROJECT_NAME}/include/"
mkdir -p "${DEST_DIR}/${PROJECT_NAME}/${PROJECT_NAME}/src/"
mkdir -p "${DEST_DIR}/${PROJECT_NAME}/${PROJECT_NAME}_test/include/"
mkdir -p "${DEST_DIR}/${PROJECT_NAME}/${PROJECT_NAME}_test/src/"
mkdir -p "${DEST_DIR}/${PROJECT_NAME}/lib${PROJECT_NAME}/include/"
mkdir -p "${DEST_DIR}/${PROJECT_NAME}/lib${PROJECT_NAME}/src/"
