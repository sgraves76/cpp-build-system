if(PROJECT_ENABLE_NANA)
  if(PROJECT_BUILD)
    add_definitions(-DPROJECT_ENABLE_NANA)

    find_library(NANA_LIBRARIES NAMES nana REQUIRED)

    if (NOT PROJECT_IS_MINGW)
      find_package(X11 REQUIRED)
    endif()

    include_directories(SYSTEM ${X11_INCLUDE_DIR})

    link_libraries(
      ${NANA_LIBRARIES}
      ${X11_LIBRARIES}
    )

    if (NOT PROJECT_IS_MINGW)
      link_libraries(
        X11::Xft
        X11::Xcursor
      )
    endif()
  elseif(NOT PROJECT_IS_MINGW)
    ExternalProject_Add(nana_project
      PREFIX external
      URL ${PROJECT_3RD_PARTY_DIR}/nana-v${NANA_VERSION}.tar.gz
      URL_HASH SHA256=${NANA_HASH}
      LIST_SEPARATOR |
      PATCH_COMMAND ${PROJECT_3RD_PARTY_DIR}/nana_patch.sh 
        ${PROJECT_3RD_PARTY_DIR}
        ${CMAKE_BINARY_DIR}/external/src/nana_project
      CMAKE_ARGS 
        -DCMAKE_INSTALL_PREFIX=${PROJECT_EXTERNAL_BUILD_ROOT}
        -DBUILD_SHARED_LIBS=${PROJECT_BUILD_SHARED_LIBS}
        -DBUILD_STATIC_LIBS=ON
        -DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}
        -DNANA_CMAKE_ENABLE_AUDIO=OFF
        -DNANA_CMAKE_ENABLE_JPEG=ON
        -DNANA_CMAKE_ENABLE_PNG=ON
        -DNANA_CMAKE_INSTALL=ON
    )

    list(APPEND PROJECT_DEPENDENCIES nana_project)

    add_dependencies(nana_project libjpeg_turbo_project libpng_project)
  endif()
endif()
