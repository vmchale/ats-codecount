fn count_char { l : addr | l != null }{m:nat}{ k : nat | k <= m }(!bytes_v(l, m) | ptr(l), c : char, bufsz : size_t(k))
  : [ n : nat | n <= m ] int(n) =
  "ext#"
