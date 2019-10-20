staload "SATS/wc.sats"
staload "libats/libc/SATS/stdio.sats"

#include "share/atspre_staload.hats"
#include "share/HATS/atslib_staload_libats_libc.hats"
#include "share/HATS/atspre_staload_libats_ML.hats"
#include "DATS/wc.dats"
#include "DATS/print.dats"

#define BUFSZ 32768

fn filecount(fp : string) : void =
  let
    var inp = fopen(fp, file_mode_r)
    val () = if FILEptr_is_null(inp) then
      let
        extern
        castfn fp_is_null { l : addr | l == null }{m:fm} (FILEptr(l,m)) :<> void

        val () = fp_is_null(inp)
        val () = println!("failed to open file")
      in end
    else
      let
        var newlines = count_file(inp)
        val () = println!(file_tostring(newlines))
        val () = fclose1_exn(inp)
      in end
  in end

implement main0 (argc, argv) =
  if argc > 1 then
    filecount(argv[1])
  else
    (println!("No file provided") ; exit(1))
