staload "SATS/wc.sats"
staload "prelude/SATS/pointer.sats"
staload UN = "prelude/SATS/unsafe.sats"
staload "SATS/io.sats"
staload "SATS/pointer.sats"
staload "SATS/size.sats"

#define BUFSZ 32768

implement file_eq (f0, f1) =
  f0.lines = f1.lines && f0.blanks = f1.blanks && f0.comments = f1.comments && f0.doc_comments = f1.doc_comments

implement empty_file =
  @{ lines = 0, blanks = 0, comments = 0, doc_comments = 0 } : file

implement add_file (f0, f1) =
  @{ lines = f0.lines + f1.lines
   , blanks = f0.blanks + f1.blanks
   , comments = f0.comments + f1.comments
   , doc_comments = f0.doc_comments + f1.doc_comments
   } : file

fn count_lines_for_loop { l : addr | l != null }{m:nat}{ n : nat | n <= m }(pf : !bytes_v(l, m)
                                                                           | ptr : ptr(l), bufsz : size_t(n)) : int =
  let
    var res: int = 0
    var i: size_t
    val () = for* { i : nat | i <= n } .<i>. (i : size_t(i)) =>
        (i := bufsz ; i != 0 ; i := i - 1)
        (let
          var current_char = byteview_read_as_char(pf | add_ptr_bsz(ptr, i))
        in
          case+ current_char of
            | '\n' => res := res + 1
            | _ => ()
        end)
    var current_char = byteview_read_as_char(pf | ptr)
    val () = case+ current_char of
      | '\n' => res := res + 1
      | _ => ()
  in
    res
  end

fn count_file_for_loop(inp : !FILEptr1) : int =
  let
    val (pfat, pfgc | p) = malloc_gc(g1i2u(BUFSZ))
    prval () = pfat := b0ytes2bytes_v(pfat)

    fun loop { l : addr | l != null }(pf : !bytes_v(l, BUFSZ) | inp : !FILEptr1, p : ptr(l)) : int =
      let
        var file_bytes = freadc(pf | inp, i2sz(BUFSZ), p)

        extern
        praxi lt_bufsz {m:nat} (size_t(m)) : [m <= BUFSZ] void
      in
        if file_bytes = 0 then
          0
        else
          let
            var fb_prf = bounded(file_bytes)
            prval () = lt_bufsz(fb_prf)
            var acc = count_lines_for_loop(pf | p, fb_prf)
          in
            acc + loop(pf | inp, p)
          end
      end

    var ret = loop(pfat | inp, p)
    val () = mfree_gc(pfat, pfgc | p)
  in
    ret
  end
