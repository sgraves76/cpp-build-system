#!/usr/bin/env bash

pushd "$2"
patch -Np0 <"$1/libdsm_meson_build.patch" || exit $?
patch -Np0 <"$1/libdsm_netbios_session_c.patch" || exit $?
patch -Np0 <"$1/libdsm_netbios_session_c_2.patch" || exit $?
patch -Np0 <"$1/libdsm_netbios_utils_c.patch" || exit $?
patch -Np0 <"$1/libdsm_smb_ntlm_c.patch" || exit $?
popd
