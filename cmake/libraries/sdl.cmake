if(PROJECT_ENABLE_SDL)
  if(PROJECT_BUILD)
    add_definitions(-DPROJECT_ENABLE_SDL)

    set(SDL2_NO_MWINDOWS ON)
    find_package(SDL2 ${SDL_VERSION} REQUIRED)

    include_directories(SYSTEM ${SDL2_INCLUDE_DIRS})

    link_libraries(SDL2::SDL2)
  elseif(NOT PROJECT_IS_MINGW)
    if(PROJECT_BUILD_SHARED_LIBS)
      set(SDL_CONFIGURE_OPTS --enable-shared=yes --enable-static=yes)
    else()
      set(SDL_CONFIGURE_OPTS --enable-shared=no --enable-static=yes)
    endif()

    ExternalProject_Add(sdl_project
      PREFIX external
      URL ${PROJECT_3RD_PARTY_DIR}/sdl-${SDL_VERSION}.tar.gz
      URL_HASH SHA256=${SDL_HASH}
      BUILD_IN_SOURCE 1
      LIST_SEPARATOR |
      CONFIGURE_COMMAND ./configure 
        --prefix=${PROJECT_EXTERNAL_BUILD_ROOT}
        ${SDL_CONFIGURE_OPTS}
      BUILD_COMMAND make -j1
      INSTALL_COMMAND make install
    )

    list(APPEND PROJECT_DEPENDENCIES sdl_project)
  endif()
endif()
