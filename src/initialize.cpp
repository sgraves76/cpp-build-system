#if defined(PROJECT_ENABLE_CURL)
#include "curl/curl.h"
#endif // defined(PROJECT_ENABLE_CURL)

#if defined(PROJECT_ENABLE_OPENSSL)
#include "openssl/ssl.h"
#endif // defined(PROJECT_ENABLE_OPENSSL)

#if defined(PROJECT_REQUIRE_ALPINE) && !defined(PROJECT_IS_MINGW)
#include <filesystem>
#include <pthread.h>
#include <stdlib.h>
#endif // defined(PROJECT_REQUIRE_ALPINE) && !defined(PROJECT_IS_MINGW)

#if defined(PROJECT_ENABLE_LIBSODIUM)
#include "sodium.h"
#endif // defined(PROJECT_ENABLE_LIBSODIUM)

#if defined(PROJECT_ENABLE_SQLITE)
#include "sqlite3.h"
#endif // defined(PROJECT_ENABLE_SQLITE)

#if defined(PROJECT_ENABLE_SPDLOG)
#include <chrono>

#include "spdlog/async.h"
#include "spdlog/sinks/stdout_color_sinks.h"
#include "spdlog/spdlog.h"
#endif // defined(PROJECT_ENABLE_SPDLOG)

#include "initialize.hpp"
#include "utils/error.hpp"

#if defined(PROJECT_REQUIRE_ALPINE) && !defined(PROJECT_IS_MINGW)
#include "utils/path.hpp"
#endif // defined(PROJECT_REQUIRE_ALPINE) && !defined (PROJECT_IS_MINGW)

#if defined(__APPLE__)
#include <csignal>
#endif // defined(__APPLE__)

namespace {
#if defined(PROJECT_ENABLE_CURL)
bool curl_initialized{false};
#endif // defined(PROJECT_ENABLE_CURL)

#if defined(PROJECT_ENABLE_SPDLOG)
bool spdlog_initialized{false};
#endif // defined(PROJECT_ENABLE_SPDLOG)

#if defined(PROJECT_ENABLE_SQLITE)
bool sqlite3_initialized{false};
#endif // defined(PROJECT_ENABLE_SQLITE)
} // namespace

namespace fifthgrid {
auto project_initialize() -> bool {
  FIFTHGRID_USES_FUNCTION_NAME();

#if defined(__APPLE__)
  std::signal(SIGPIPE, SIG_IGN);
#endif // defined(__APPLE__)

#if defined(PROJECT_REQUIRE_ALPINE) && !defined(PROJECT_IS_MINGW)
  {
    static constexpr auto guard_size{4096U};
    static constexpr auto stack_size{8U * 1024U * 1024U};

    pthread_attr_t attr{};
    pthread_attr_setstacksize(&attr, stack_size);
    pthread_attr_setguardsize(&attr, guard_size);
    pthread_setattr_default_np(&attr);
  }
#endif // defined(PROJECT_REQUIRE_ALPINE) && !defined(PROJECT_IS_MINGW)

#if defined(PROJECT_ENABLE_SPDLOG)
  spdlog::drop_all();
  spdlog::flush_every(std::chrono::seconds(5));
  spdlog::set_pattern("%Y-%m-%d|%T.%e|%^%l%$|%v");

  spdlog::create_async<spdlog::sinks::stdout_color_sink_mt>("console");
  spdlog_initialized = true;
#endif // defined(PROJECT_ENABLE_SPDLOG)

#if defined(PROJECT_ENABLE_LIBSODIUM)
  if (sodium_init() == -1) {
    utils::error::handle_error(function_name, "failed to initialize sodium");
    return false;
  }
#endif // defined(PROJECT_ENABLE_LIBSODIUM)

#if defined(PROJECT_ENABLE_OPENSSL)
  SSL_library_init();
#endif // defined(PROJECT_ENABLE_OPENSSL)

#if defined(PROJECT_ENABLE_CURL)
  {
    auto res = curl_global_init(CURL_GLOBAL_ALL);
    if (res != 0) {
      utils::error::handle_error(function_name,
                                 "failed to initialize curl|result|" +
                                     std::to_string(res));
      return false;
    }

    curl_initialized = true;
  }
#endif // defined(PROJECT_ENABLE_CURL)

#if defined(PROJECT_ENABLE_SQLITE)
  {
    auto res = sqlite3_initialize();
    if (res != SQLITE_OK) {
      utils::error::handle_error(function_name,
                                 "failed to initialize sqlite3|result|" +
                                     std::to_string(res));
      return false;
    }

    sqlite3_initialized = true;
  }
#endif // defined(PROJECT_ENABLE_SQLITE)

  return true;
}

void project_cleanup() {
#if defined(PROJECT_ENABLE_CURL)
  if (curl_initialized) {
    curl_global_cleanup();
    curl_initialized = false;
  }
#endif // defined(PROJECT_ENABLE_CURL)

#if defined(PROJECT_ENABLE_SQLITE)
  if (sqlite3_initialized) {
    sqlite3_shutdown();
    sqlite3_initialized = false;
  }
#endif // defined(PROJECT_ENABLE_SQLITE)

#if defined(PROJECT_ENABLE_SPDLOG)
  if (spdlog_initialized) {
    spdlog::shutdown();
    spdlog_initialized = false;
  }
#endif // defined(PROJECT_ENABLE_SPDLOG)
}
} // namespace fifthgrid
