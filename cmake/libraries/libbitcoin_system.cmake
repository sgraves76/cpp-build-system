if(PROJECT_ENABLE_LIBBITCOIN_SYSTEM)
  if(PROJECT_BUILD)
    add_definitions(
      -DPROJECT_ENABLE_LIBBITCOIN_SYSTEM
      -DBC_STATIC
      -DECMULT_GEN_PREC_BITS=4
      -DECMULT_WINDOW_SIZE=15
      -DWITH_ICU
    )

    set(LIBBITCOIN_SYSTEM_ROOT ${PROJECT_BUILD_DIR}/external/src/libbitcoin_system_project)

    include_directories(SYSTEM BEFORE ${LIBBITCOIN_SYSTEM_ROOT}/include)

    set(PROJECT_ADDITIONAL_SOURCES
      ${PROJECT_ADDITIONAL_SOURCES}
      ${LIBBITCOIN_SYSTEM_ROOT}/src/config/*.cpp
      ${LIBBITCOIN_SYSTEM_ROOT}/src/error.cpp
      ${LIBBITCOIN_SYSTEM_ROOT}/src/formats/*.cpp
      ${LIBBITCOIN_SYSTEM_ROOT}/src/math/*.cpp
      ${LIBBITCOIN_SYSTEM_ROOT}/src/math/external/*.c
      ${LIBBITCOIN_SYSTEM_ROOT}/src/message/network_address.cpp
      ${LIBBITCOIN_SYSTEM_ROOT}/src/unicode/*.cpp
      ${LIBBITCOIN_SYSTEM_ROOT}/src/utility/istream_reader.cpp
      ${LIBBITCOIN_SYSTEM_ROOT}/src/utility/ostream_writer.cpp
      ${LIBBITCOIN_SYSTEM_ROOT}/src/utility/string.cpp
      ${LIBBITCOIN_SYSTEM_ROOT}/src/wallet/dictionary.cpp
      ${LIBBITCOIN_SYSTEM_ROOT}/src/wallet/electrum.cpp
      ${LIBBITCOIN_SYSTEM_ROOT}/src/wallet/electrum_dictionary.cpp
      ${LIBBITCOIN_SYSTEM_ROOT}/src/wallet/mnemonic.cpp
    )
  else()
    ExternalProject_Add(libbitcoin_system_project
      PREFIX external
      URL ${PROJECT_3RD_PARTY_DIR}/libbitcoin-system-${LIBBITCOIN_SYSTEM_VERSION}.tar.gz
      URL_HASH SHA256=0d10d79472e914620223f1ddb9396b0fa92ae5eb0b31acc14b9aa634a01d78b6
      CONFIGURE_COMMAND echo "No configure"
      BUILD_COMMAND echo "No build"
      INSTALL_COMMAND echo "No install"
    )

    list(APPEND PROJECT_DEPENDENCIES libbitcoin_system_project)

    if(NOT PROJECT_IS_MINGW_UNIX)
      add_dependencies(libbitcoin_system_project 
        boost_project
        secp256k1_project
      )
    endif()
  endif()
endif()
