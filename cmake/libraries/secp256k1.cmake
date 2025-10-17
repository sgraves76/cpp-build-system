if(PROJECT_ENABLE_SECP256K1)
  if(PROJECT_BUILD)
    add_definitions(-DPROJECT_ENABLE_SECP256K1)

    pkg_check_modules(SECP256K1 libsecp256k1=${SECP256K1_VERSION} REQUIRED)

    include_directories(BEFORE SYSTEM ${SECP256K1_INCLUDE_DIRS})

    link_libraries(${SECP256K1_LINK_LIBRARIES})
  elseif(NOT PROJECT_IS_MINGW OR CMAKE_HOST_WIN32)
    if(PROJECT_BUILD_SHARED_LIBS)
      set(SECP256K1_ENABLE_SHARED yes)
    else()
      set(SECP256K1_ENABLE_SHARED no)
    endif()

    ExternalProject_Add(secp256k1_project
      PREFIX external
      URL ${PROJECT_3RD_PARTY_DIR}/secp256k1-${SECP256K1_VERSION}.tar.gz
      URL_HASH SHA256=${SECP256K1_HASH}
      BUILD_IN_SOURCE 1
      LIST_SEPARATOR |
      CONFIGURE_COMMAND ./autogen.sh && ./configure
        --enable-shared=${SECP256K1_ENABLE_SHARED}
        --enable-static=yes
        --enable-module-ecdh
        --enable-module-recovery
        --prefix=${PROJECT_EXTERNAL_BUILD_ROOT}
      BUILD_COMMAND make -j1
      INSTALL_COMMAND make install
    )

    list(APPEND PROJECT_DEPENDENCIES secp256k1_project)
  endif()
endif()
