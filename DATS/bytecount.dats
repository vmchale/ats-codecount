staload "SATS/bytecount.sats"

fn count_lines { l : addr | l != null }{m:nat}{ k : nat | k <= m }(pf : !bytes_v(l, m) | p : ptr(l), bufsz : size_t(k))
  : [ n : nat | n <= m ] int(n) =
  count_char(pf | p, '\n', bufsz)
