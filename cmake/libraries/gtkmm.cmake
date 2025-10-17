if(PROJECT_ENABLE_GTKMM)
  if(PROJECT_BUILD)
    add_definitions(-DPROJECT_ENABLE_GTKMM)

    find_package(PNG REQUIRED)

    pkg_check_modules(GTKMM REQUIRED gtkmm-${GTKMM_VERSION})

    add_definitions(${GTKMM_DEFINITIONS})

    include_directories(
      ${GTKMM_INCLUDE_DIRS}
      ${PNG_INCLUDE_DIRS}
    )

    link_directories(${GTKMM_LIBRARY_DIRS})

    link_libraries(
      ${GTKMM_LIBRARIES}
      ${PNG_LIBRARIES}
    )
  endif()
endif()
