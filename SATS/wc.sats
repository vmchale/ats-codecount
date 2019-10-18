vtypedef file = @{ lines = int, blanks = int, comments = int, doc_comments = int }

datavtype parse_state =
  | in_string of int
  | in_block_comment of int
  | line_comment
  | regular

val empty_file: file

fn count_buf { l : addr | l != null }{m:nat} (!bytes_v(l, m) | ptr(l), bufsz : size_t(m), &parse_state >> _) : file

fn free_st(parse_state) : void

overload free with free_st
