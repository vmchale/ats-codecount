staload "SATS/wc.sats"
staload "libats/libc/SATS/stdio.sats"

#include "$PATSHOMELOCS/ats-bench-0.3.3/bench.dats"
#include "share/atspre_staload.hats"
#include "DATS/wc.dats"
#include "DATS/lang/c.dats"
#include "DATS/pointer.dats"

#define BUFSZ 32768

extern
castfn fp_is_null { l : addr | l == null }{m:fm} (FILEptr(l,m)) :<> void

fn harness_naive() : void =
  let
    var inp = fopen("test/data/sqlite3.c", file_mode_r)
    val () = if FILEptr_is_null(inp) then
      let
        val () = fp_is_null(inp)
        val () = println!("failed to open file")
      in end
    else
      let
        var newlines = count_file_for_loop(inp)
        val () = fclose1_exn(inp)
      in end
  in end

fn harness_filecount() : void =
  let
    var inp = fopen("test/data/sqlite3.c", file_mode_r)
    val () = if FILEptr_is_null(inp) then
      let
        val () = fp_is_null(inp)
        val () = println!("failed to open file")
      in end
    else
      let
        var newlines = count_file(inp)
        val () = fclose1_exn(inp)
      in end
  in end

val harness_naive_delay: io = lam () => harness_naive()
val harness_filecount_delay: io = lam () => harness_filecount()

implement main0 () =
  {
    val () = print_slope("sqlite.c (for loop)", 7, harness_naive_delay)
    val () = print_slope("sqlite.c (filecount)", 5, harness_filecount_delay)
  }
