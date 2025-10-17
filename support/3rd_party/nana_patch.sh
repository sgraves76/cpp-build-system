#!/usr/bin/env bash

pushd "$2"
patch -Np0 <"$1/nana_dragdrop_cpp.patch" || exit $?
patch -Np0 <"$1/nana_filebox_cpp.patch" || exit $?
popd
