if(PROJECT_ENABLE_LIBPNG)
  if(PROJECT_BUILD)
    add_definitions(-DPROJECT_ENABLE_PNG)

    find_package(PNG ${LIBPNG_VERSION} REQUIRED )

    include_directories(${PNG_INCLUDE_DIRS})

    link_libraries(PNG::PNG)
  elseif(NOT PROJECT_IS_MINGW)
    ExternalProject_Add(libpng_project
      PREFIX external
      URL ${PROJECT_3RD_PARTY_DIR}/libpng-v${LIBPNG_VERSION}.tar.gz
      URL_HASH SHA256=${LIBPNG_HASH}
      LIST_SEPARATOR |
      CMAKE_ARGS ${PROJECT_EXTERNAL_CMAKE_FLAGS}
        -DBUILD_SHARED_LIBS=${PROJECT_BUILD_SHARED_LIBS}
        -DBUILD_STATIC_LIBS=ON
        -DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}
        -DENABLE_SHARED=${PROJECT_BUILD_SHARED_LIBS}
        -DPNG_SHARED=ON
        -DPNG_STATIC=ON
        -DPNG_TESTS=OFF
        -DPNG_TOOLS=OFF
    )

    list(APPEND PROJECT_DEPENDENCIES libpng_project)
  endif()
endif()

