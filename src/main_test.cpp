#if defined(PROJECT_ENABLE_BACKWARD_CPP)
#include "backward.hpp"
#endif // defined(PROJECT_ENABLE_BACKWARD_CPP)

#include "gtest/gtest.h"

#include "initialize.hpp"
#include "utils/config.hpp"
#include "utils/error.hpp"

using namespace fifthgrid;

int PROJECT_TEST_RESULT{0};

auto main(int argc, char **argv) -> int {
  FIFTHGRID_USES_FUNCTION_NAME();

#if defined(PROJECT_ENABLE_BACKWARD_CPP)
  static backward::SignalHandling sh;
#endif

  if (not fifthgrid::project_initialize()) {
    fifthgrid::project_cleanup();
    return -1;
  }

  try {
    ::testing::InitGoogleTest(&argc, argv);
    PROJECT_TEST_RESULT = RUN_ALL_TESTS();
  } catch (const std::exception &e) {
    utils::error::handle_exception(function_name, e);
  } catch (...) {
    utils::error::handle_exception(function_name);
  }

  fifthgrid::project_cleanup();

  return PROJECT_TEST_RESULT;
}
