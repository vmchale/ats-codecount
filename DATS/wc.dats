extern
fn memchr {l:addr}{m:nat}(pf : bytes_v(l, m) | p : ptr(l), c : int, size_t) : [l0:addr] ( bytes_v(l, l0-l)
                                                                                        , bytes_v(l0, l+m-l0)
                                                                                        | ptr(l0)) =
  "mac#"

implement empty_file =
  @{ lines = 0, blanks = 0, comments = 0, doc_comments = 0 } : file

implement count_buf (pf | ptr, st) =
  case+ st of
    | in_string() => empty_file
    | in_block_comment() => empty_file
    | line_comment() => empty_file
    | regular() => empty_file
