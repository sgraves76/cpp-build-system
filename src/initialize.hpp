#ifndef LIBFIFTHGRID_INCLUDE_INITIALIZE_HPP_
#define LIBFIFTHGRID_INCLUDE_INITIALIZE_HPP_

namespace fifthgrid {
void project_cleanup();

[[nodiscard]] auto project_initialize() -> bool;
} // namespace fifthgrid

#endif // LIBFIFTHGRID_INCLUDE_INITIALIZE_HPP_
