staload "SATS/wc.sats"
staload "libats/libc/SATS/stdio.sats"

#include "$PATSHOMELOCS/ats-bench-0.3.3/bench.dats"
#include "share/atspre_staload.hats"
#include "DATS/wc.dats"

#define BUFSZ 32768

extern
castfn fp_is_null { l : addr | l == null }{m:fm} (FILEptr(l,m)) :<> void

fn count_file_bytecount(inp : !FILEptr1) : int =
  let
    val (pfat, pfgc | p) = malloc_gc(g1i2u(BUFSZ))
    prval () = pfat := b0ytes2bytes_v(pfat)

    fun loop { l : addr | l != null }(pf : !bytes_v(l, BUFSZ) | inp : !FILEptr1, p : ptr(l)) : int =
      let
        var file_bytes = freadc(pf | inp, i2sz(BUFSZ), p)
      in
        if file_bytes = 0 then
          0
        else
          let
            extern
            praxi lt_bufsz {m:nat} (size_t(m)) : [m <= BUFSZ] void

            var fb_prf = bounded(file_bytes)
            prval () = lt_bufsz(fb_prf)
            var acc = count_lines(pf | p, fb_prf)
          in
            acc + loop(pf | inp, p)
          end
      end

    val ret = loop(pfat | inp, p)
    val () = mfree_gc(pfat, pfgc | p)
  in
    ret
  end

fn harness_bytecount() : void =
  let
    var inp = fopen("test/data/sqlite3.c", file_mode_r)
    val () = if FILEptr_is_null(inp) then
      let
        val () = fp_is_null(inp)
        val () = println!("failed to open file")
      in end
    else
      let
        var newlines = count_file_bytecount(inp)
        val () = fclose1_exn(inp)
      in end
  in end

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

val harness_bytecount_delay: io = lam () => harness_bytecount()
val harness_naive_delay: io = lam () => harness_naive()

implement main0 () =
  {
    val () = print_slope("sqlite.c (naive)", 6, harness_naive_delay)
    val () = print_slope("sqlite.c (bytecount)", 6, harness_bytecount_delay)
  }
