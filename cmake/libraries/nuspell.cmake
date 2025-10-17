if(PROJECT_ENABLE_NUSPELL)
  if(PROJECT_BUILD)
    find_package(Nuspell ${NUSPELL_VERSION} REQUIRED)

    add_definitions(-DPROJECT_ENABLE_NUSPELL)

    include_directories(BEFORE SYSTEM ${NUSPELL_INCLUDE_DIRS})

    link_libraries(Nuspell::nuspell) 
  elseif(NOT PROJECT_IS_MINGW)
    ExternalProject_Add(nuspell_project
      PREFIX external
      URL ${PROJECT_3RD_PARTY_DIR}/nuspell-v${NUSPELL_VERSION}.tar.gz
      URL_HASH SHA256=${NUSPELL_HASH}
      LIST_SEPARATOR |
      CMAKE_ARGS ${PROJECT_EXTERNAL_CMAKE_FLAGS}
        -DBUILD_DOCS=OFF
        -DBUILD_SHARED_LIBS=${PROJECT_BUILD_SHARED_LIBS}
        -DBUILD_STATIC_LIBS=ON
        -DBUILD_TESTING=OFF
        -DBUILD_TOOLS=OFF
        -DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}
    )

    list(APPEND PROJECT_DEPENDENCIES nuspell_project)
  endif()
endif()
