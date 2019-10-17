staload "SATS/wc.sats"
staload "libats/libc/SATS/stdio.sats"

#include "$PATSHOMELOCS/ats-bench-0.3.3/bench.dats"
#include "share/atspre_staload.hats"
#include "DATS/wc.dats"

#define BUFSZ 32768

fun harness() : void =
  let
    var inp = fopen("test/data/sqlite3.c", file_mode_r)
    val () = if FILEptr_is_null(inp) then
      let
        extern
        castfn fp_is_null { l : addr | l == null }{m:fm} (FILEptr(l,m)) :<> void

        val () = fp_is_null(inp)
        val () = println!("failed to open file")
      in end
    else
      let
        val (pfat, pfgc | p) = malloc_gc(g1i2u(BUFSZ))
        prval () = pfat := b0ytes2bytes_v(pfat)
        val file_bytes = freadc_(pfat | inp, i2sz(BUFSZ), p)
        var st: parse_state = regular()
        val final_file = count_buf(pfat | p, file_bytes, st)
        val () = free(st)
        val () = mfree_gc(pfat, pfgc | p)
        val () = fclose1_exn(inp)
      in end
  in end

val harness_delay: io = lam () => harness()

implement main0 () =
  { val () = print_slope("sqlite.c", 7, harness_delay) }
