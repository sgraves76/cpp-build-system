if(PROJECT_ENABLE_LIBEVENT)
  if(PROJECT_BUILD)
    add_definitions(-DPROJECT_ENABLE_LIBEVENT)

    if(PROJECT_IS_MINGW AND NOT PROJECT_IS_MINGW_UNIX)
      pkg_check_modules(LIBEVENT REQUIRED libevent>=${LIBEVENT_VERSION})
    else()
      set(LIBEVENT_STATIC_LINK ${PROJECT_STATIC_LINK})
      find_package(Libevent ${LIBEVENT_VERSION} REQUIRED)
    endif()

    include_directories(BEFORE SYSTEM ${LIBEVENT_INCLUDE_DIRS})
    if (PROJECT_IS_MINGW_UNIX)
      unset(LIBEVENT_LIBRARIES)
      set(LIBEVENT_LIBRARIES 
        /mingw64/lib/libevent.dll.a
        /mingw64/lib/libevent_core.dll.a
        /mingw64/lib/libevent_extra.dll.a
      )
    endif()
    link_libraries(${LIBEVENT_LIBRARIES})
  elseif(NOT PROJECT_IS_MINGW)
    if(PROJECT_BUILD_SHARED_LIBS)
      set(LIBEVENT_LIBRARY_TYPE BOTH)
    else()
      set(LIBEVENT_LIBRARY_TYPE STATIC)
    endif()

    ExternalProject_Add(libevent_project
      PREFIX external
      URL ${PROJECT_3RD_PARTY_DIR}/libevent-${LIBEVENT_VERSION}-stable.tar.gz
      URL_HASH SHA256=${LIBEVENT_HASH}
      LIST_SEPARATOR |
      PATCH_COMMAND ${PROJECT_3RD_PARTY_DIR}/libevent_patch.sh 
        ${PROJECT_3RD_PARTY_DIR}
        ${CMAKE_BINARY_DIR}/external/src/libevent_project
      CMAKE_ARGS ${PROJECT_EXTERNAL_CMAKE_FLAGS}
        -DBUILD_SHARED_LIBS=${PROJECT_BUILD_SHARED_LIBS}
        -DBUILD_STATIC_LIBS=ON
        -DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}
        -DEVENT__DISABLE_OPENSSL=ON
        -DEVENT__DISABLE_SAMPLES=ON
        -DEVENT__DISABLE_TESTS=ON
        -DEVENT__LIBRARY_TYPE=${LIBEVENT_LIBRARY_TYPE}
    )

    list(APPEND PROJECT_DEPENDENCIES libevent_project)
  endif()
endif()
