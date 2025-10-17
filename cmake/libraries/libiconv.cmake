if(PROJECT_ENABLE_LIBICONV)
  if(PROJECT_BUILD)
    add_definitions(-DPROJECT_ENABLE_LIBICONV)

    find_library(libiconv_LIBRARIES NAMES libiconv.a)

    link_libraries(${libiconv_LIBRARIES})
  elseif(NOT PROJECT_IS_MINGW)
    ExternalProject_Add(libiconv_project
      PREFIX external
      URL ${PROJECT_3RD_PARTY_DIR}/libiconv-${LIBICONV_VERSION}.tar.gz
      URL_HASH SHA256=${LIBICONV_HASH}
      BUILD_IN_SOURCE 1
      LIST_SEPARATOR |
      CONFIGURE_COMMAND ./configure 
        --enable-shared=no
        --enable-static=yes
        --prefix=${PROJECT_EXTERNAL_BUILD_ROOT}
      BUILD_COMMAND make -j1 
      INSTALL_COMMAND make install
    )

    list(APPEND PROJECT_DEPENDENCIES libiconv_project)
  endif()
endif()
