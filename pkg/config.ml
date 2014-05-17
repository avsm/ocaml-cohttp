#!/usr/bin/env ocaml
#directory "pkg"
#use "topkg-ext.ml"

module Config = struct
  include Config_default
  let vars =
    [ "NAME", "cohttp";
      "VERSION", Git.describe ~chop_v:true "master";
      "MAINTAINER", "anil\\@recoil.org>" ]
end
