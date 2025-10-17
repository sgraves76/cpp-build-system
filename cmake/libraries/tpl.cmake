if(PROJECT_ENABLE_TPL)
  if(PROJECT_BUILD)
    add_definitions(-DPROJECT_ENABLE_TPL)

    find_package(tiny-process-library REQUIRED)

    link_libraries(tiny-process-library::tiny-process-library)
  elseif(NOT PROJECT_IS_MINGW OR CMAKE_HOST_WIN32)
    ExternalProject_Add(tpl_project
      PREFIX external
      URL ${PROJECT_3RD_PARTY_DIR}/tiny-process-library.tar.gz
      URL_HASH SHA256=82e46657e697aff5bf980387c86ef3aa05bb184622abbd75663a4df549c68f73
      LIST_SEPARATOR |
      CMAKE_ARGS ${PROJECT_EXTERNAL_CMAKE_FLAGS}
        -DBUILD_SHARED_LIBS=${PROJECT_BUILD_SHARED_LIBS}
        -DBUILD_STATIC_LIBS=ON
        -DBUILD_TESTING=OFF
        -DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}
    )

    list(APPEND PROJECT_DEPENDENCIES tpl_project)
  endif()
endif()

