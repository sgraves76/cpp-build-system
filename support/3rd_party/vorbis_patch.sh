#!/usr/bin/env bash

pushd "$2"
patch -Np0 < "$1/vorbis_cmakelists_txt.patch" || exit $?
popd
