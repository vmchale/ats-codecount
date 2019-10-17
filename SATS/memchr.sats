fn memchr2 { l : addr | l != null }{m:nat}{ n : nat | n <= m }(!bytes_v(l, m) | ptr(l), char, char, size_t(n)) :
  Option_vt([ k : nat | k <= n ] size_t(k)) =
  "ext#"

fn memchr3 { l : addr | l != null }{m:nat}{ n : nat | n <= m }(!bytes_v(l, m) | ptr(l), char, char, char, size_t(n)) :
  Option_vt([ k : nat | k <= n ] size_t(k)) =
  "ext#"
