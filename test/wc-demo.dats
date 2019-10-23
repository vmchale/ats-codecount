#include "share/atspre_staload.hats"
#include "share/HATS/atslib_staload_libats_libc.hats"
#include "share/HATS/atspre_staload_libats_ML.hats"
#include "DATS/file.dats"
#include "DATS/print.dats"
#include "DATS/lang/c.dats"
#include "DATS/lang/haskell.dats"
#include "DATS/pointer.dats"

implement main0 (argc, argv) =
  if argc > 1 then
    {
      val () = filecount<parse_state_c>(argv[1])
      val () = filecount<parse_state_hs>(argv[1])
    }
  else
    (println!("No file provided") ; exit(1))
