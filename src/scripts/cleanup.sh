#!/usr/bin/env bash

PROJECT_SCRIPTS_DIR=$(dirname "$0")
PROJECT_SCRIPTS_DIR=$(realpath ${PROJECT_SCRIPTS_DIR})
. "${PROJECT_SCRIPTS_DIR}/env.sh" "$1" "$2" "$3" "$4" "$5" 1 1>/dev/null 2>&1

for PROJECT_LIBRARY in "${PROJECT_LIBRARIES[@]}"; do
  PROJECT_LIBRARY_LOWER=$(echo ${PROJECT_LIBRARY} | tr "[:upper:]" "[:lower:]")
  ENABLE_NAME=PROJECT_ENABLE_${PROJECT_LIBRARY}
  KEEP_NAME=PROJECT_KEEP_${PROJECT_LIBRARY}
  if [ ${!ENABLE_NAME} == "OFF" ] && [ ${!KEEP_NAME} != "1" ]; then
    CLEANUP_LIST=(${PROJECT_CLEANUP[${PROJECT_LIBRARY}]//:/ })
    for CLEANUP_ITEM in "${CLEANUP_LIST[@]}"; do
      rm -r ${PROJECT_SUPPORT_DIR}/${CLEANUP_ITEM}
    done

    ${SED} -i "/.*\/${PROJECT_LIBRARY_LOWER}\.cmake/d" "${PROJECT_SOURCE_DIR}/cmake/libraries.cmake"
    ${SED} -i "/D${ENABLE_NAME}/d" "${PROJECT_SOURCE_DIR}/CMakeLists.txt"

    ${SED} -i "/${ENABLE_NAME}/d" "${PROJECT_SOURCE_DIR}/cmake/options.cmake"
    ${SED} -i "/\[${PROJECT_LIBRARY}\]/d" "${PROJECT_SOURCE_DIR}/scripts/libraries.sh"
    ${SED} -i "/\ \ ${PROJECT_LIBRARY}/d" "${PROJECT_SOURCE_DIR}/scripts/libraries.sh"

    ${SED} -i "/${PROJECT_LIBRARY}_HASH/d" "${PROJECT_SOURCE_DIR}/cmake/hashes.cmake"
    ${SED} -i "/${PROJECT_LIBRARY}2_HASH/d" "${PROJECT_SOURCE_DIR}/cmake/hashes.cmake"

    ${SED} -i "/${PROJECT_LIBRARY}_VERSION/d" "${PROJECT_SOURCE_DIR}/cmake/versions.cmake"
    ${SED} -i "/${PROJECT_LIBRARY}2_VERSION/d" "${PROJECT_SOURCE_DIR}/cmake/versions.cmake"
    ${SED} -i "/\[${PROJECT_LIBRARY}\]/d" "${PROJECT_SOURCE_DIR}/scripts/versions.sh"
    ${SED} -i "/\[${PROJECT_LIBRARY}2\]/d" "${PROJECT_SOURCE_DIR}/scripts/versions.sh"

    rm -f "${PROJECT_SOURCE_DIR}/cmake/libraries/${PROJECT_LIBRARY_LOWER}.cmake"
  fi

  if [ ${!ENABLE_NAME} == "ON" ] && [ "${PROJECT_CLEANUP[${PROJECT_LIBRARY}_ON]}" != "" ]; then
    CLEANUP_LIST=(${PROJECT_CLEANUP[${PROJECT_LIBRARY}_ON]//:/ })
    for CLEANUP_ITEM in "${CLEANUP_LIST[@]}"; do
      rm -r ${PROJECT_SUPPORT_DIR}/${CLEANUP_ITEM}
    done
  fi
done

${SED} -i "s/\ OFF)/\ ON)/" "${PROJECT_SOURCE_DIR}/cmake/options.cmake"
