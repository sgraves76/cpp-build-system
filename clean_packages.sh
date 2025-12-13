#!/usr/bin/env bash

CURRENT_DIR=$(realpath "$0")
CURRENT_DIR=$(dirname "${CURRENT_DIR}")

pushd "${CURRENT_DIR}"

mapfile -t FILE_LIST < <(find support/3rd_party/ -type f \( -name '*.gz' -o -name '*.bz2' -o -name '*.xz' -o -name '*.msi' -o -name '*.zip' \))

for NAME in "${FILE_LIST[@]}"; do
  echo "Removing ${NAME}"
  rm -f "${NAME}"
done

mapfile -t FILE_LIST < <(find support/3rd_party/mingw64/ -type f \( -name '*.exe' \))
for NAME in "${FILE_LIST[@]}"; do
  echo "Removing ${NAME}"
  rm -f "${NAME}"
done

popd
