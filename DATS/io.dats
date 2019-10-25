staload UN = "prelude/SATS/unsafe.sats"

fn freadc { l : addr | l != null }{ sz : nat | sz >= 1 }(pf : !bytes_v(l, sz)
                                                        | inp : !FILEptr1, bufsize : size_t(sz), p : ptr(l)) :
  [ m : nat | m <= sz ] size_t(m) =
  let
    extern
    castfn as_fileref(x : !FILEptr1) :<> FILEref

    var n = $extfcall(size_t, "fread", p, sizeof<byte>, bufsize, as_fileref(inp))
  in
    $UN.cast(n)
  end
