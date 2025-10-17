if(PROJECT_ENABLE_LIBDSM)
  if(PROJECT_BUILD)
    add_definitions(-DPROJECT_ENABLE_LIBDSM)

    find_library(libdsm_LIBRARIES NAMES libdsm.a)

    link_libraries(${libdsm_LIBRARIES})
  elseif(NOT PROJECT_IS_MINGW)
    set(_meson_c_args       "-I${PROJECT_EXTERNAL_BUILD_ROOT}/deps/include")
    set(_meson_c_link_args  "-L${PROJECT_EXTERNAL_BUILD_ROOT}/deps/lib -L${PROJECT_EXTERNAL_BUILD_ROOT}/deps/lib64")
    set(_meson_host_arg     "")
    set(_meson_host_file    "${PROJECT_EXTERNAL_BUILD_ROOT}/libdsm_host_machine.ini")

    if(PROJECT_IS_DARWIN)
      set(_mac_arch_raw "${CMAKE_OSX_ARCHITECTURES}")
      string(TOLOWER "${_mac_arch_raw}" _mac_arch)

      if(_mac_arch MATCHES ";")
        set(_meson_c_args      "${_meson_c_args}|-arch|arm64|-arch|x86_64")
        set(_meson_c_link_args "${_meson_c_link_args}|-arch|arm64|-arch|x86_64")
      else()
        if(_mac_arch STREQUAL "arm64")
          set(_meson_cpu_family "aarch64")
          set(_meson_cpu        "arm64")
          set(_meson_c_args      "${_meson_c_args}|-arch|arm64")
          set(_meson_c_link_args "${_meson_c_link_args}|-arch|arm64")
        elseif(_mac_arch STREQUAL "x86_64")
          set(_meson_cpu_family "x86_64")
          set(_meson_cpu        "x86_64")
          set(_meson_c_args      "${_meson_c_args}|-arch|x86_64")
          set(_meson_c_link_args "${_meson_c_link_args}|-arch|x86_64")
        endif()

        if(DEFINED _meson_cpu_family AND DEFINED _meson_cpu)
          file(WRITE "${_meson_host_file}"
            "[binaries]
            c = 'clang'
            cpp = 'clang++'

            [host_machine]
            system = 'darwin'
            cpu_family = '${_meson_cpu_family}'
            cpu = '${_meson_cpu}'
            endian = 'little'
            "
          )

          set(_meson_host_arg "--native-file=${_meson_host_file}")
        endif()
      endif()
    endif()

    ExternalProject_Add(libdsm_project
      PREFIX external
      URL ${PROJECT_3RD_PARTY_DIR}/libdsm-${LIBDSM_VERSION}.tar.gz
      URL_HASH SHA256=${LIBDSM_HASH}
      BUILD_IN_SOURCE 1
      LIST_SEPARATOR |
      PATCH_COMMAND ${PROJECT_3RD_PARTY_DIR}/libdsm_patch.sh
        ${PROJECT_3RD_PARTY_DIR}
        ${CMAKE_BINARY_DIR}/external/src/libdsm_project
      CONFIGURE_COMMAND meson
        setup
        -Dc_args="${_meson_c_args}"
        -Dcpp_args="${_meson_c_args}"
        -Dc_link_args="${_meson_c_link_args}"
        -Dcpp_link_args="${_meson_c_link_args}"
        ${_meson_host_arg}
        --prefix=${PROJECT_EXTERNAL_BUILD_ROOT}
        -Dbinaries=false
        -Ddefault_library=static
        _build
      BUILD_COMMAND meson
        compile -C _build
      INSTALL_COMMAND meson
        install -C _build
    )

    list(APPEND PROJECT_DEPENDENCIES libdsm_project)

    add_dependencies(libdsm_project 
      libiconv_project
      libtasn1_project
      openssl_project
    )
  endif()
endif()
