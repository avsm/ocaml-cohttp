.PHONY: all clean install build
all: build test doc

PREFIX ?= /usr/local
NAME=cohttp

LWT ?= $(shell if ocamlfind query lwt >/dev/null 2>&1; then echo true; else echo false; fi)
LWT_UNIX ?= $(shell if ocamlfind query lwt.unix >/dev/null 2>&1; then echo echo true; else echo false; fi)
ASYNC ?= $(shell if ocamlfind query async >/dev/null 2>&1; then echo true; else echo false; fi)
#NETTESTS ?= --enable-tests --enable-nettests

build:
	ocaml pkg/build.ml native=true native-dynlink=true lwt=$(LWT) async=$(ASYNC) lwt-unix=$(ASYNC)

explain:
	ocaml pkg/build.ml explain

clean:
	ocamlbuild -clean
