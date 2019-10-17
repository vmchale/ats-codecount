staload "SATS/wc.sats"
staload "libats/libc/SATS/stdio.sats"

#include "$PATSHOMELOCS/ats-bench-0.3.3/bench.dats"
#include "share/atspre_staload.hats"
#include "DATS/wc.dats"

#define BUFSZ 32768

fn harness_bytecount() : void =
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
        var newlines = count_lines(pfat | p, file_bytes)
        val () = mfree_gc(pfat, pfgc | p)
        val () = fclose1_exn(inp)
      in end
  in end

fn harness() : void =
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
        val newlines = count_lines_memchr(pfat | p, file_bytes)
        val () = mfree_gc(pfat, pfgc | p)
        val () = fclose1_exn(inp)
      in end
  in end

val harness_delay: io = lam () => harness()
val harness_bytecount_delay: io = lam () => harness_bytecount()

implement main0 () =
  {
    val () = print_slope("sqlite.c (code count)", 7, harness_delay)
    val () = print_slope("sqlite.c (bytecount)", 8, harness_bytecount_delay)
  }
