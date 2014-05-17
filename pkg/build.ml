#!/usr/bin/env ocaml 
#directory "pkg"
#use "topkg.ml"

let lwt = Env.bool "lwt"
let async = Env.bool "async"
let lwt_unix = Env.bool "lwt-unix"

let () = 
  Pkg.describe "cohttp" ~builder:`OCamlbuild [
    Pkg.lib "pkg/META";
    Pkg.lib ~exts:Exts.module_library "cohttp/cohttp";
    Pkg.lib ~cond:lwt ~exts:Exts.module_library "lwt/cohttp_lwt";
    Pkg.lib ~cond:lwt_unix ~exts:Exts.module_library "lwt/cohttp_lwt_unix";
    Pkg.lib ~cond:async ~exts:Exts.module_library "async/cohttp_async";
    Pkg.doc "README.md"; 
    Pkg.doc "CHANGES"; 
  ];
