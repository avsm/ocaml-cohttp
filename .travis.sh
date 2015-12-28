#!/bin/sh -ex

OS=~/build/$TRAVIS_REPO_SLUG
git clone git://github.com/ocaml/ocaml-travisci-skeleton $OS/__test
docker run -v \
  $OS:/repo \
  ocaml/opam-dockerfiles:${DISTRO}_ocaml-${OCAML_VERSION} \
  cd /repo/__test && ocaml travis_opam.ml
