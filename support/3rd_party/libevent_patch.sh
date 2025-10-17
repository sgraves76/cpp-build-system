#!/usr/bin/env bash

pushd "$2"
${SED} -i s/3\.1/3\.10/g CMakeLists.txt
popd
