if(PROJECT_ENABLE_OGG)
  if(PROJECT_BUILD)
    add_definitions(-DPROJECT_ENABLE_OGG)

    find_package(Ogg ${OGG_VERSION} REQUIRED)

    include_directories(BEFORE SYSTEM ${OGG_INCLUDE_DIRS})

    link_libraries(Ogg::ogg)
  elseif(NOT PROJECT_IS_MINGW)
    ExternalProject_Add(ogg_project
      PREFIX external
      URL ${PROJECT_3RD_PARTY_DIR}/ogg-v${OGG_VERSION}.tar.gz
      URL_HASH SHA256=${OGG_HASH}
      LIST_SEPARATOR |
      CMAKE_ARGS ${PROJECT_EXTERNAL_CMAKE_FLAGS}
        -DBUILD_SHARED_LIBS=${PROJECT_BUILD_SHARED_LIBS}
        -DBUILD_STATIC_LIBS=ON
        -DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}
    )

    list(APPEND PROJECT_DEPENDENCIES ogg_project)
  endif()
endif()
