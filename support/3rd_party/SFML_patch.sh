#!/usr/bin/env bash

${SED} -i s/set_target_properties\(\$\{target\}\ PROPERTIES\ PREFIX\ \"\"\)// cmake/Macros.cmake &&
  ${SED} -i s/set_target_properties\(\$\{target\}\ PROPERTIES\ IMPORT_SUFFIX\ \"\.a\"\)// cmake/Macros.cmake
