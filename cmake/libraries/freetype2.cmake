if(PROJECT_ENABLE_FREETYPE2)
  if(PROJECT_BUILD)
    add_definitions(-DPROJECT_ENABLE_FREETYPE2)

    find_package(Freetype ${FREETYPE2_VERSION} REQUIRED)

    include_directories(BEFORE SYSTEM ${FREETYPE_INCLUDE_DIRS})

    link_libraries(Freetype::Freetype)
  elseif(NOT PROJECT_IS_MINGW)
    ExternalProject_Add(freetype2_project
      PREFIX external
      URL ${PROJECT_3RD_PARTY_DIR}/freetype-${FREETYPE2_VERSION}.tar.gz
      URL_HASH SHA256=${FREETYPE2_HASH}
      BUILD_IN_SOURCE 1
      LIST_SEPARATOR |
      CONFIGURE_COMMAND meson
        setup
        --prefix=${PROJECT_EXTERNAL_BUILD_ROOT}
        _build
      BUILD_COMMAND meson
        compile
        -C _build
      INSTALL_COMMAND meson
        install
        -C _build
    )

    list(APPEND PROJECT_DEPENDENCIES freetype2_project)
  endif()
endif()

