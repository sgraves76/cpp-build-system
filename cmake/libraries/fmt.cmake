if(PROJECT_ENABLE_FMT)
  if(PROJECT_BUILD)
    add_definitions(-DPROJECT_ENABLE_FMT)

    find_package(fmt ${FMT_VERSION} REQUIRED)

    include_directories(BEFORE SYSTEM ${FMT_INCLUDE_DIRS})

    link_libraries(fmt::fmt) 
  elseif(NOT PROJECT_IS_MINGW OR CMAKE_HOST_WIN32)
    ExternalProject_Add(fmt_project
      PREFIX external
      URL ${PROJECT_3RD_PARTY_DIR}/fmt-${FMT_VERSION}.tar.gz
      URL_HASH SHA256=${FMT_HASH}
      LIST_SEPARATOR |
      CMAKE_ARGS ${PROJECT_EXTERNAL_CMAKE_FLAGS}
        -DBUILD_SHARED_LIBS=${PROJECT_BUILD_SHARED_LIBS}
        -DBUILD_STATIC_LIBS=ON
        -DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}
        -DFMT_DOC=OFF
        -DFMT_TEST=OFF
    )

    list(APPEND PROJECT_DEPENDENCIES fmt_project)
  endif()
endif()
