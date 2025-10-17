#!/usr/bin/env bash

CURRENT_DIR=$(realpath "$0")
CURRENT_DIR=$(dirname "${CURRENT_DIR}")

function do_update() {
  pushd "../$1"
  git pull
  popd

  ./update_project.sh $1 ..

  pushd "../$1"
  scripts/cleanup.sh
  git add .
  git commit -a -m 'updated build system'
  git push
  popd
}

pushd "${CURRENT_DIR}"
git add .
git commit -a -m "updates"
git push

do_update dxmedia3
do_update fifthgrid
do_update gamepadx
do_update joule
do_update med
do_update repertory
do_update monitarr
popd
