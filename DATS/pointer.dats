staload UN = "prelude/SATS/unsafe.sats"
staload "SATS/pointer.sats"

implement byteview_read_as_char (pf | p) =
  $UN.ptr0_get<char>(p)
