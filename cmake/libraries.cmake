find_package(PkgConfig REQUIRED)

set(Boost_USE_STATIC_LIBS ${PROJECT_STATIC_LINK})
set(CURL_USE_STATIC_LIBS ${PROJECT_STATIC_LINK})
set(OPENSSL_USE_STATIC_LIBS ${PROJECT_STATIC_LINK})
set(SFML_STATIC_LIBRARIES ${PROJECT_STATIC_LINK})
if (PROJECT_IS_DARWIN)
  set(ZLIB_USE_STATIC_LIBS OFF)
else()
  set(ZLIB_USE_STATIC_LIBS ${PROJECT_STATIC_LINK})
endif()
set(wxWidgets_USE_STATIC ${PROJECT_STATIC_LINK})
set(ICU_USE_STATIC_LIBS ${PROJECT_STATIC_LINK})

include(cmake/libraries/icu.cmake)
include(cmake/libraries/openssl.cmake)
include(cmake/libraries/boost.cmake)
include(cmake/libraries/backward_cpp.cmake)
include(cmake/libraries/cli11.cmake)
include(cmake/libraries/cpp_httplib.cmake)
include(cmake/libraries/curl.cmake)
include(cmake/libraries/cxxopts.cmake)
include(cmake/libraries/dtl.cmake)
include(cmake/libraries/flac.cmake)
include(cmake/libraries/fmt.cmake)
include(cmake/libraries/fontconfig.cmake)
include(cmake/libraries/freetype2.cmake)
include(cmake/libraries/fuse.cmake)
include(cmake/libraries/fzf.cmake)
include(cmake/libraries/gtkmm.cmake)
include(cmake/libraries/json.cmake)
include(cmake/libraries/libbitcoin_system.cmake)
include(cmake/libraries/libdsm.cmake)
include(cmake/libraries/libevent.cmake)
include(cmake/libraries/libiconv.cmake)
include(cmake/libraries/libjpeg_turbo.cmake)
include(cmake/libraries/libpng.cmake)
include(cmake/libraries/libsodium.cmake)
include(cmake/libraries/libtasn.cmake)
include(cmake/libraries/nana.cmake)
include(cmake/libraries/nuspell.cmake)
include(cmake/libraries/ogg.cmake)
include(cmake/libraries/openal.cmake)
include(cmake/libraries/pugixml.cmake)
include(cmake/libraries/rocksdb.cmake)
include(cmake/libraries/sago_platform_folders.cmake)
include(cmake/libraries/sdl.cmake)
include(cmake/libraries/secp256k1.cmake)
include(cmake/libraries/sfml.cmake)
include(cmake/libraries/spdlog.cmake)
include(cmake/libraries/sqlite.cmake)
include(cmake/libraries/stduuid.cmake)
include(cmake/libraries/testing.cmake)
include(cmake/libraries/tpl.cmake)
include(cmake/libraries/vlc.cmake)
include(cmake/libraries/vorbis.cmake)
include(cmake/libraries/winfsp.cmake)
include(cmake/libraries/wxwidgets.cmake)

if(PROJECT_BUILD)
  find_package(Threads REQUIRED)
  find_package(ZLIB REQUIRED)

  include_directories(BEFORE SYSTEM ${ZLIB_INCLUDE_DIRS})
  link_libraries(${ZLIB_LIBRARIES})

  if(PROJECT_IS_MINGW)
    link_libraries(
      advapi32
      bcrypt
      comdlg32
      crypt32
      dbghelp
      gdi32
      httpapi
      iphlpapi
      kernel32
      mswsock
      ncrypt
      ole32
      oleaut32
      rpcrt4
      secur32
      shell32
      shlwapi
      user32
      userenv
      uuid
      version
      winhttp
      wininet
      winspool
      ws2_32
  )
  elseif(NOT PROJECT_IS_DARWIN)
    link_libraries(
      uring
    )
  endif()
endif()
