#include "share/atspre_staload.hats"
#include "share/HATS/atslib_staload_libats_libc.hats"
#include "share/HATS/atspre_staload_libats_ML.hats"
#include "DATS/file.dats"
#include "DATS/print.dats"
#include "DATS/lang/c.dats"
#include "DATS/lang/haskell.dats"
#include "DATS/lang/j.dats"
#include "DATS/lang/dhall.dats"
#include "DATS/lang/futhark.dats"
#include "DATS/lang/egison.dats"
#include "DATS/pointer.dats"

fn prext(fp : string) : void =
  let
    val (pf | str) = filename_get_ext(fp)
    val match: string = if strptr2ptr(str) > 0 then
      $UN.strptr2string(str)
    else
      ""
    val () = case+ match of
      | "hs" => filecount<parse_state_hs>(fp)
      | "c" => filecount<parse_state_c>(fp)
      | "ijs" => filecount<parse_state_j>(fp)
      | "dhall" => filecount<parse_state_dhall>(fp)
      | "fut" => filecount<parse_state_fut>(fp)
      | "egi" => filecount<parse_state_egi>(fp)
      | _ => prerr!("Unknown file type\n")
    prval () = pf(str)
  in end

implement main0 (argc, argv) =
  if argc > 1 then
    prext(argv[1])
  else
    (prerr!("No file provided\n") ; exit(1))
