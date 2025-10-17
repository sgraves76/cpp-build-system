if(PROJECT_ENABLE_FONTCONFIG)
  if(PROJECT_BUILD)
    add_definitions(-DPROJECT_ENABLE_FONTCONFIG)

    find_package(Fontconfig ${FONTCONFIG_VERSION} REQUIRED)

    include_directories(BEFORE SYSTEM ${FONTCONFIG_INCLUDE_DIRS})

    link_libraries(Fontconfig::Fontconfig)
  elseif(NOT PROJECT_IS_MINGW)
    ExternalProject_Add(fontconfig_project
      PREFIX external
      URL ${PROJECT_3RD_PARTY_DIR}/fontconfig-${FONTCONFIG_VERSION}.tar.xz
      URL_HASH SHA256=${FONTCONFIG_HASH}
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

    list(APPEND PROJECT_DEPENDENCIES fontconfig_project)

    add_dependencies(fontconfig_project
      freetype2_project
      libjpeg_turbo_project
      libpng_project
    )
  endif()
endif()

