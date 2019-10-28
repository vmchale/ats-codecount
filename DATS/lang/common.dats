staload "libats/libc/SATS/stdio.sats"
staload "SATS/pointer.sats"
staload "SATS/file.sats"
staload "SATS/lang/common.sats"
staload "SATS/size.sats"

#include "DATS/io.dats"

#define BUFSZ 32768

fn {a:vt@ype} count_for_loop { l : addr | l != null }{m:nat}{ n : nat | n <= m }( pf : !bytes_v(l, m) | p : ptr(l)
                                                                                , parse_st : &a >> _
                                                                                , bufsz : size_t(n)
                                                                                ) : file =
  let
    var res: file = empty_file
    var i: size_t
    val () = for* { i : nat | i <= n } .<n-i>. (i : size_t(i)) =>
        (i := i2sz(0) ; i < bufsz ; i := i + 1)
        let
          var current_char = byteview_read_as_char(pf | add_ptr_bsz(p, i))
        in
          advance_char$lang<a>(current_char, parse_st, res)
        end
  in
    res
  end

fn {a:vt@ype} count_file_buf { l : addr | l != null }(pf : !bytes_v(l, BUFSZ) | p : ptr(l), inp : !FILEptr1) : file =
  let
    var init_st: a
    val () = init$lang<a>(init_st)

    fun loop { l : addr | l != null }(pf : !bytes_v(l, BUFSZ) | inp : !FILEptr1, st : &a >> _, p : ptr(l)) : file =
      let
        var file_bytes = freadc(pf | inp, i2sz(BUFSZ), p)

        extern
        praxi lt_bufsz {m:nat} (size_t(m)) : [m <= BUFSZ] void
      in
        if file_bytes = 0 then
          empty_file
        else
          let
            prval () = lt_bufsz(file_bytes)
            var acc = count_for_loop<a>(pf | p, st, file_bytes)
          in
            acc + loop(pf | inp, st, p)
          end
      end

    var ret = loop(pf | inp, init_st, p)
    val () = free$lang<a>(init_st)
  in
    ret
  end

fn {a:vt@ype} count_file(inp : !FILEptr1) : file =
  let
    val (pfat, pfgc | p) = malloc_gc(g1i2u(BUFSZ))
    prval () = pfat := b0ytes2bytes_v(pfat)
    var ret = count_file_buf<a>(pfat | p, inp)
    val () = mfree_gc(pfat, pfgc | p)
  in
    ret
  end

implement {a} filecount (fp) =
  case+ file$lang<a>(fp) of
    | ~Some_vt (res) => println!(file_tostring(res))
    | ~None_vt() => prerr!("failed to open file\n")

implement {a} file$lang (fp) =
  let
    var inp = fopen(fp, file_mode_r)
  in
    if FILEptr_is_null(inp) then
      let
        extern
        castfn fp_is_null { l : addr | l == null }{m:fm} (FILEptr(l,m)) :<> void

        val () = fp_is_null(inp)
      in
        None_vt
      end
    else
      let
        var newlines = count_file<a>(inp)
        val () = fclose1_exn(inp)
      in
        Some_vt(newlines)
      end
  end
