if(PROJECT_ENABLE_SFML)
  if(PROJECT_BUILD)
    add_definitions(-DPROJECT_ENABLE_SFML)

    find_package(OpenGL REQUIRED)
    find_package(X11 REQUIRED)

    find_package(SFML ${SFML_VERSION}
      COMPONENTS 
        audio
        graphics
        network
        system
        window
      REQUIRED
    )

    if(NOT PROJECT_BUILD_SHARED_LIBS)
      set(SFML_STATIC_LIB_APPEND "-s")
    endif()

    link_libraries(
      ${X11_LIBRARIES}
      sfml-audio${SFML_STATIC_LIB_APPEND}
      sfml-graphics${SFML_STATIC_LIB_APPEND}
      sfml-network${SFML_STATIC_LIB_APPEND}
      sfml-system${SFML_STATIC_LIB_APPEND}
      sfml-window${SFML_STATIC_LIB_APPEND}
    )

    include_directories(BEFORE SYSTEM
      ${X11_INCLUDE_DIR}
      ${SFML_INCLUDE_DIR}
    )
  elseif(NOT PROJECT_IS_MINGW)
    ExternalProject_Add(sfml_project
      PREFIX external
      URL ${PROJECT_3RD_PARTY_DIR}/SFML-${SFML_VERSION}.tar.gz
      URL_HASH SHA256=${SFML_HASH}
      PATCH_COMMAND ${PROJECT_3RD_PARTY_DIR}/SFML_patch.sh
      LIST_SEPARATOR |
      BUILD_COMMAND 
        ${CMAKE_COMMAND} --build . -- -j$ENV{CMAKE_BUILD_PARALLEL_LEVEL}
      CMAKE_ARGS ${PROJECT_EXTERNAL_CMAKE_FLAGS}
        -DBUILD_SHARED_LIBS=${PROJECT_BUILD_SHARED_LIBS}
        -DBUILD_STATIC_LIBS=ON
        -DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}
    )

    list(APPEND PROJECT_DEPENDENCIES sfml_project)

    add_dependencies(sfml_project 
      flac_project
      fontconfig_project
      freetype2_project
      openal_project
    )
  endif()
endif()
