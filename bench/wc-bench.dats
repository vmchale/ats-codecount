staload "libats/libc/SATS/stdio.sats"

#include "$PATSHOMELOCS/ats-bench-0.3.3/bench.dats"
#include "share/atspre_staload.hats"
#include "DATS/wc.dats"
#include "DATS/lang/c.dats"
#include "DATS/lang/haskell.dats"
#include "DATS/lang/dhall.dats"
#include "DATS/pointer.dats"

extern
castfn fp_is_null { l : addr | l == null }{m:fm} (FILEptr(l,m)) :<> void

fn harness_naive() : void =
  let
    var inp = fopen("bench/data/sqlite3.c", file_mode_r)
    val () = if FILEptr_is_null(inp) then
      let
        val () = fp_is_null(inp)
        val () = println!("failed to open file")
      in end
    else
      let
        var newlines = count_file_for_loop(inp)
        val () = fclose_silent(inp)
      in end
  in end

fn harness_filecount_c(fp : string) : void =
  let
    var inp = fopen(fp, file_mode_r)
    val () = if FILEptr_is_null(inp) then
      let
        val () = fp_is_null(inp)
        val () = println!("failed to open file")
      in end
    else
      let
        var newlines = count_file<parse_state_c>(inp)
        val () = fclose_silent(inp)
      in end
  in end

fn harness_filecount_asm() : void =
  let
    var inp = fopen("bench/data/fpsp.S", file_mode_r)
    val () = if FILEptr_is_null(inp) then
      let
        val () = fp_is_null(inp)
        val () = println!("failed to open file")
      in end
    else
      let
        var newlines = count_file<parse_state_c>(inp)
        val () = fclose_silent(inp)
      in end
  in end

fn harness_filecount_hs() : void =
  let
    var inp = fopen("test/data/Setup.hs", file_mode_r)
    val () = if FILEptr_is_null(inp) then
      let
        val () = fp_is_null(inp)
        val () = println!("failed to open file")
      in end
    else
      let
        var newlines = count_file<parse_state_hs>(inp)
        val () = fclose_silent(inp)
      in end
  in end

fn harness_filecount_dhall() : void =
  let
    var inp = fopen("bench/data/pkg-set.dhall", file_mode_r)
    val () = if FILEptr_is_null(inp) then
      let
        val () = fp_is_null(inp)
        val () = println!("failed to open file")
      in end
    else
      let
        var newlines = count_file<parse_state_dhall>(inp)
        val () = fclose_silent(inp)
      in end
  in end

val harness_naive_delay: io = lam () => harness_naive()
val harness_filecount_c_delay: io = lam () =>
    harness_filecount_c("bench/data/sqlite3.c")
val harness_filecount_c_delay2: io = lam () =>
    harness_filecount_c("bench/data/core.c")
val harness_filecount_hs_delay: io = lam () => harness_filecount_hs()
val harness_filecount_dhall_delay: io = lam () => harness_filecount_dhall()
val harness_filecount_asm_delay: io = lam () => harness_filecount_asm()

implement main0 () =
  {
    val () = print_slope("sqlite.c (for loop)", 8, harness_naive_delay)
    val () = print_slope("sqlite.c (filecount_c)", 6, harness_filecount_c_delay)
    val () = print_slope("core.c (filecount_c)", 9, harness_filecount_c_delay2)
    val () = print_slope("fpsp.S (filecount_asm)", 8, harness_filecount_asm_delay)
    val () = print_slope("Distribution.Simple.Setup (filecount_hs)", 9, harness_filecount_hs_delay)
    val () = print_slope("pkg-set.dhall (filecount_dhall)", 9, harness_filecount_dhall_delay)
  }
