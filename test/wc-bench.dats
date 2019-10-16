staload "SATS/wc.sats"
staload "libats/libc/SATS/stdio.sats"

#include "share/atspre_staload.hats"
#include "DATS/wc.dats"

#define BUFSZ 32768

fun harness() : void =
  let
    var inp = fopen("README.md", file_mode_r)
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
        val () = println!(final_file.lines)
        val () = free(st)
        val () = mfree_gc(pfat, pfgc | p)
        val () = fclose1_exn(inp)
      in end
  in end

implement main0 () =
  {
    val () = harness()
    val () = println!("Sucess?")
  }
