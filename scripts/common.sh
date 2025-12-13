#!/usr/bin/env bash

SCRIPTS_DIR=$(dirname "$0")
SCRIPTS_DIR=$(realpath ${SCRIPTS_DIR})

SOURCE_DIR=${SCRIPTS_DIR}/..
SOURCE_DIR=$(realpath "${SOURCE_DIR}")

TEST_DIR=${SOURCE_DIR}/build

PLATFORM=$1
BUILD_TYPE=$2
WITH_TYPE=$3
BUILD_ARCH=$4

if [ "$(uname -s)" == "Darwin" ]; then
  export SED=gsed
else
  export SED=sed
fi

function error_exit() {
  echo $1
  exit $2
}

if [ "${BUILD_TYPE}" != "shared" ] && [ "${BUILD_TYPE}" != "static" ]; then
  error_exit "must specify 'shared' or 'static'" 1
fi

if [ "${TEST_DIR}" == "" ]; then
  error_exit "TEST_DIR is not set" 1
fi

mkdir -p "${TEST_DIR}"

NAME=${PLATFORM}_${BUILD_TYPE}
if [ "${WITH_TYPE}" == "1" ]; then
  NAME=${NAME}_crypto
elif [ "${WITH_TYPE}" == "2" ]; then
  NAME=${NAME}_dsm
elif [ "${WITH_TYPE}" == "3" ]; then
  NAME=${NAME}_sqlite
elif [ "${WITH_TYPE}" == "4" ]; then
  NAME=${NAME}_errors_v1
elif [ "${WITH_TYPE}" == "5" ]; then
  NAME=${NAME}_fmt
elif [ "${WITH_TYPE}" == "6" ]; then
  NAME=${NAME}_libevent
elif [ "${WITH_TYPE}" == "7" ]; then
  NAME=${NAME}_crypto_no_boost
fi

if [ "${BUILD_ARCH}" != "" ]; then
  NAME=${NAME}_${BUILD_ARCH}
fi

rm -rf "${TEST_DIR}/${NAME}"

pushd "${SOURCE_DIR}"
./create_project.sh ${NAME} ${TEST_DIR} || error_exit "failed to create ${PLATFORM} project" 2
popd

pushd "${TEST_DIR}/${NAME}"
if [ "${WITH_TYPE}" == "1" ]; then
  ${SED} -i "s/PROJECT_ENABLE_LIBSODIUM=OFF/PROJECT_ENABLE_LIBSODIUM=ON/g" ./config.sh
  ${SED} -i "s/PROJECT_ENABLE_BOOST=OFF/PROJECT_ENABLE_BOOST=ON/g" ./config.sh
  ${SED} -i "s/PROJECT_ENABLE_JSON=OFF/PROJECT_ENABLE_JSON=ON/g" ./config.sh
elif [ "${WITH_TYPE}" == "2" ]; then
  ${SED} -i "s/PROJECT_ENABLE_LIBDSM=OFF/PROJECT_ENABLE_LIBDSM=ON/g" ./config.sh
elif [ "${WITH_TYPE}" == "3" ]; then
  ${SED} -i "s/PROJECT_ENABLE_SQLITE=OFF/PROJECT_ENABLE_SQLITE=ON/g" ./config.sh
elif [ "${WITH_TYPE}" == "4" ]; then
  ${SED} -i "s/PROJECT_ENABLE_V2_ERRORS=ON/PROJECT_ENABLE_V2_ERRORS=OFF/g" ./config.sh
elif [ "${WITH_TYPE}" == "5" ]; then
  ${SED} -i "s/PROJECT_ENABLE_FMT=OFF/PROJECT_ENABLE_FMT=ON/g" ./config.sh
elif [ "${WITH_TYPE}" == "6" ]; then
  ${SED} -i "s/PROJECT_ENABLE_LIBEVENT=OFF/PROJECT_ENABLE_LIBEVENT=ON/g" ./config.sh
elif [ "${WITH_TYPE}" == "7" ]; then
  ${SED} -i "s/PROJECT_ENABLE_LIBSODIUM=OFF/PROJECT_ENABLE_LIBSODIUM=ON/g" ./config.sh
fi

if [ "${BUILD_TYPE}" == "shared" ]; then
  ${SED} -i "s/PROJECT_STATIC_LINK=ON/PROJECT_STATIC_LINK=OFF/g" ./config.sh
fi

./scripts/make_${PLATFORM}.sh "${BUILD_ARCH}" || error_exit "build ${PLATFORM} ${BUILD_ARCH} failed" 3
if [ "${PLATFORM}" == "win32" ]; then
  ./scripts/run_tests.sh "${BUILD_ARCH}" "" "" 1 1 || error_exit "testing ${PLATFORM} failed" 4
else
  ./scripts/run_tests.sh "${BUILD_ARCH}" || error_exit "testing ${PLATFORM} ${BUILD_ARCH} failed" 4
fi
popd

rm -rf "${TEST_DIR}/${NAME}"
