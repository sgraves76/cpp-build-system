if(PROJECT_ENABLE_WXWIDGETS)
  if(PROJECT_BUILD)
    add_definitions(-DPROJECT_ENABLE_WXWIDGETS)

    find_package(OpenGL REQUIRED)

    set(wxWidgets_USE_WINDOWS OFF)
    find_package(wxWidgets ${WXWIDGETS_VERSION} REQUIRED 
      COMPONENTS 
        net 
        core 
        base 
        gl
        adv 
        xml 
        aui 
        html 
        media 
        propgrid 
        qa 
        ribbon 
        richtext
        stc
        webview
        xrc
      )

    if(wxWidgets_USE_FILE)
      include(${wxWidgets_USE_FILE})
    endif()
  elseif(NOT PROJECT_IS_MINGW)
    ExternalProject_Add(wxwidgets_project
      PREFIX external
      URL ${PROJECT_3RD_PARTY_DIR}/wxWidgets-${WXWIDGETS_VERSION}.tar.bz2
      URL_HASH SHA256=${WXWIDGETS_HASH}
      LIST_SEPARATOR |
      BUILD_COMMAND 
        ${CMAKE_COMMAND} --build . -- -j$ENV{CMAKE_BUILD_PARALLEL_LEVEL}
      CMAKE_ARGS ${PROJECT_EXTERNAL_CMAKE_FLAGS}
        -DBUILD_SHARED_LIBS=${PROJECT_BUILD_SHARED_LIBS}
        -DBUILD_STATIC_LIBS=ON
        -DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}
        -DwxBUILD_MONOLITHIC=OFF
        -DwxBUILD_SHARED=${PROJECT_BUILD_SHARED_LIBS}
    )

    list(APPEND PROJECT_DEPENDENCIES wxwidgets_project)

    add_dependencies(wxwidgets_project curl_project)
  endif()
endif()
