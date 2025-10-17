if(PROJECT_ENABLE_BACKWARD_CPP AND PROJECT_BUILD)
  if(PROJECT_IS_MINGW)
    add_definitions(-DPROJECT_ENABLE_BACKWARD_CPP)

    link_libraries(msvcr90)
  else()
    add_definitions(-DBACKWARD_HAS_BFD)

    link_libraries(bfd)
  endif()
endif()
