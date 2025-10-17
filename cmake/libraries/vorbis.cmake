if(PROJECT_ENABLE_VORBIS)
  if(PROJECT_BUILD)
    add_definitions(-DPROJECT_ENABLE_VORBIS)

    if(PROJECT_IS_MINGW AND NOT PROJECT_IS_MINGW_UNIX)
      pkg_check_modules(VORBIS REQUIRED vorbis>=${VORBIS_VERSION})
      link_libraries(${VORBIS_LINK_LIBRARIES})
    else()
      find_package(Vorbis ${VORBIS_VERSION} REQUIRED)
      link_libraries(Vorbis::vorbis)
    endif()

    include_directories(BEFORE SYSTEM ${VORBIS_INCLUDE_DIRS})
  elseif(NOT PROJECT_IS_MINGW)
    ExternalProject_Add(vorbis_project
      PREFIX external
      URL ${PROJECT_3RD_PARTY_DIR}/vorbis-v${VORBIS_VERSION}.tar.gz
      URL_HASH SHA256=${VORBIS_HASH}
      PATCH_COMMAND ${PROJECT_3RD_PARTY_DIR}/vorbis_patch.sh
        ${PROJECT_3RD_PARTY_DIR}
        ${CMAKE_BINARY_DIR}/external/src/vorbis_project
      LIST_SEPARATOR |
      CMAKE_ARGS ${PROJECT_EXTERNAL_CMAKE_FLAGS}
        -DBUILD_SHARED_LIBS=${PROJECT_BUILD_SHARED_LIBS}
        -DBUILD_STATIC_LIBS=ON
        -DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    )

    list(APPEND PROJECT_DEPENDENCIES vorbis_project)

    add_dependencies(vorbis_project ogg_project)
  endif()
endif()
