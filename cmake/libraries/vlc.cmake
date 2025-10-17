if(PROJECT_ENABLE_VLC AND PROJECT_BUILD) 
  add_definitions(-DPROJECT_ENABLE_VLC)
  if (PROJECT_IS_MINGW)
    set(libvlc_INCLUDE_DIRS ${PROJECT_3RD_PARTY_DIR}/vlc/sdk/include)

    set(libvlc_LIBRARIES 
      ${PROJECT_3RD_PARTY_DIR}/vlc/sdk/lib/libvlc.lib
      ${PROJECT_3RD_PARTY_DIR}/vlc/sdk/lib/libvlccore.lib
    )
  else()
    pkg_check_modules(libvlc REQUIRED libvlc>=${VLC_VERSION})
  endif()

  include_directories(BEFORE SYSTEM ${libvlc_INCLUDE_DIRS})
  link_libraries(${libvlc_LIBRARIES})
endif()
