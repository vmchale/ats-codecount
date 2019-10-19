vtypedef file = @{ lines = int, blanks = int, comments = int, doc_comments = int }

datavtype parse_state =
  | in_string
  | in_block_comment
  | post_slash
  | post_backslash_in_string
  | line_comment
  | post_asterisk_in_block_comment
  | regular
  | post_newline_whitespace
  | post_block_comment
  | post_tick

val empty_file: file

fn count_buf { l : addr | l != null }{m:nat} (!bytes_v(l, m) | ptr(l), bufsz : size_t(m), &parse_state >> _) : file

fn add_file(file, file) : file

fn file_to_string(file) : string

fn free_st(parse_state) : void

overload free with free_st
overload + with add_file
