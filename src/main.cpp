#if defined(PROJECT_ENABLE_BACKWARD_CPP)
#include "backward.hpp"
#endif // defined(PROJECT_ENABLE_BACKWARD_CPP)

#include "initialize.hpp"
#include "utils/config.hpp"
#include "utils/error.hpp"

using namespace fifthgrid;

auto main(int argc, char **argv) -> int {
  FIFTHGRID_USES_FUNCTION_NAME();

#if defined(PROJECT_ENABLE_BACKWARD_CPP)
  static backward::SignalHandling sh;
#endif // defined(PROJECT_ENABLE_BACKWARD_CPP)

  if (not fifthgrid::project_initialize()) {
    fifthgrid::project_cleanup();
    return -1;
  }

  int exit_code{0};

  try {
    // TODO Main code here
  } catch (const std::exception &e) {
    utils::error::handle_exception(function_name, e);
  } catch (...) {
    utils::error::handle_exception(function_name);
  }

  fifthgrid::project_cleanup();

  return exit_code;
}
