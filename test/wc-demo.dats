#include "share/atspre_staload.hats"
#include "share/HATS/atslib_staload_libats_libc.hats"
#include "share/HATS/atspre_staload_libats_ML.hats"
#include "DATS/file.dats"
#include "DATS/print.dats"
#include "DATS/lang/c.dats"
#include "DATS/lang/haskell.dats"
#include "DATS/lang/j.dats"
#include "DATS/lang/vimscript.dats"
#include "DATS/pointer.dats"

implement main0 (argc, argv) =
  if argc > 1 then
    {
      val () = println!("C filecount")
      val () = filecount<parse_state_c>(argv[1])
      val () = println!("Haskell filecount")
      val () = filecount<parse_state_hs>(argv[1])
      val () = println!("J filecount")
      val () = filecount<parse_state_j>(argv[1])
    }
  else
    (println!("No file provided") ; exit(1))
