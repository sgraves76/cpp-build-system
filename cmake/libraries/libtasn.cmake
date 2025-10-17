if(PROJECT_ENABLE_LIBTASN)
  if(PROJECT_BUILD)
    add_definitions(-DPROJECT_ENABLE_LIBTASN)

    find_library(libtasn1_LIBRARIES NAMES libtasn1.a)

    link_libraries(${libtasn1_LIBRARIES})
  elseif(NOT PROJECT_IS_MINGW)
    ExternalProject_Add(libtasn1_project
      PREFIX external
      URL ${PROJECT_3RD_PARTY_DIR}/libtasn1-${LIBTASN_VERSION}.tar.gz
      URL_HASH SHA256=${LIBTASN_HASH}
      BUILD_IN_SOURCE 1
      LIST_SEPARATOR |
      CONFIGURE_COMMAND ./configure 
        --disable-doc
        --enable-shared=no
        --enable-static=yes
        --prefix=${PROJECT_EXTERNAL_BUILD_ROOT}
      BUILD_COMMAND make -j1 
      INSTALL_COMMAND make install
    )

    list(APPEND PROJECT_DEPENDENCIES libtasn1_project)

    if (PROJECT_ENABLE_OPENSSL)
      add_dependencies(libtasn1_project openssl_project)
    endif()
  endif()
endif()
