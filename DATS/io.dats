staload "SATS/io.sats"

implement freadc (pf | inp, bufsize, p) =
  let
    extern
    castfn as_fileref(x : !FILEptr1) :<> FILEref

    var n = $extfcall(size_t, "fread", p, sizeof<byte>, bufsize, as_fileref(inp))
  in
    n
  end
