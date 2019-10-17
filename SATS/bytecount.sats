fn count_char { l : addr | l != null }{m:nat}(!bytes_v(l, m) | ptr(l), c : char, bufsz : size_t(m)) :
  [ n : nat | n <= m ] int(n) =
  "ext#"
