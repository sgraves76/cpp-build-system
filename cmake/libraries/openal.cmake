if(PROJECT_ENABLE_OPENAL)
  if(PROJECT_BUILD)
    add_definitions(-DPROJECT_ENABLE_OPENAL)

    find_package(OpenAL ${OPENAL_VERSION} REQUIRED)

    include_directories(BEFORE SYSTEM ${OPENAL_INCLUDE_DIR})

    link_libraries(${OPENAL_LIBRARY})
  elseif(NOT PROJECT_IS_MINGW)
    ExternalProject_Add(openal_project
      PREFIX external
      URL ${PROJECT_3RD_PARTY_DIR}/openal-${OPENAL_VERSION}.tar.gz
      URL_HASH SHA256=${OPENAL_HASH}
      LIST_SEPARATOR |
      CMAKE_ARGS ${PROJECT_EXTERNAL_CMAKE_FLAGS}
        -DBUILD_SHARED_LIBS=${PROJECT_BUILD_SHARED_LIBS}
        -DBUILD_STATIC_LIBS=ON
        -DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}
    )

    list(APPEND PROJECT_DEPENDENCIES openal_project)
  endif()
endif()
