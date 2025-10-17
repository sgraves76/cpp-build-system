if(PROJECT_ENABLE_FLAC)
  if(PROJECT_BUILD)
    add_definitions(-DPROJECT_ENABLE_FLAC)

    find_package(FLAC ${FLAC_VERSION} REQUIRED)

    include_directories(BEFORE SYSTEM ${FLAC_INCLUDE_DIRS})

    link_libraries(FLAC::FLAC)
  elseif(NOT PROJECT_IS_MINGW)
    ExternalProject_Add(flac_project
      PREFIX external
      URL ${PROJECT_3RD_PARTY_DIR}/flac-${FLAC_VERSION}.tar.gz
      URL_HASH SHA256=${FLAC_HASH}
      LIST_SEPARATOR |
      CMAKE_ARGS ${PROJECT_EXTERNAL_CMAKE_FLAGS}
        -DBUILD_SHARED_LIBS=${PROJECT_BUILD_SHARED_LIBS}
        -DBUILD_STATIC_LIBS=ON
        -DBUILD_EXAMPLES=OFF
        -DBUILD_PROGRAMS=OFF
        -DBUILD_TESTING=OFF
        -DBUILD_DOCS=OFF
        -DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}
        -DINSTALL_MANPAGES=OFF
    )

    list(APPEND PROJECT_DEPENDENCIES flac_project)

    add_dependencies(flac_project libiconv_project vorbis_project)
  endif()
endif()
