(*
 * Copyright (c) 2010-2014 Anil Madhavapeddy <anil@recoil.org>
 * Copyright (c) 2010-2011 Thomas Gazagnaire <thomas@ocamlpro.com>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *)

open Ocamlbuild_plugin
open Printf

module Configure = struct
  (* Read a list of lines from files in _config/<arg> *)
  let config x =
    try string_list_of_file (Pathname.pwd ^ "/_config/" ^ x)
    with Sys_error _ ->
      eprintf "_config/%s not found: run ./configure first\n%!" x;
      exit 1

  (* Read a config file as a shell fragment to be appended directly.
   * Repeat lines are also filtered, but ordering preserved. *)
  let config_sh x = Sh (String.concat " " (config x))

  (* Test to see if a flag file exists *)
  let test_flag x = Sys.file_exists (sprintf "%s/_config/flag.%s" Pathname.pwd x)

  let flags () =
    let fl = if test_flag "opt" && test_flag "natdynlink" then
      "ppflags.opt" else "ppflags.byte" in
    let ofl = S [config_sh "oflags"] in
    flag ["ocaml"; "pp"; "use_syntax"] & S [config_sh fl];
    flag ["ocaml"; "ocamldep"] & ofl;
    flag ["ocaml"; "compile"] & ofl;
    flag ["ocaml"; "link"] & ofl

  let tools () =
    if test_flag "opt" then begin
      Options.ocamlc := Sh "ocamlc.opt";
      Options.ocamlopt := Sh "ocamlopt.opt";
      Options.ocamldep := Sh "ocamldep.opt"
    end
end

let _ = dispatch begin function
    | After_options -> Configure.tools ()
    | After_rules -> Configure.flags ();
    | _ -> ()
  end
