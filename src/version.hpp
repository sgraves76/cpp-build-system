#ifndef LIBFIFTHGRID_INCLUDE_VERSION_HPP_
#define LIBFIFTHGRID_INCLUDE_VERSION_HPP_

#include <string_view>

namespace fifthgrid {
[[nodiscard]] auto project_get_git_rev() -> std::string_view;

[[nodiscard]] auto project_get_version() -> std::string_view;
} // namespace fifthgrid

#endif // LIBFIFTHGRID_INCLUDE_VERSION_HPP_
