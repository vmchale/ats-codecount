vtypedef file = @{ lines = int, blanks = int, comments = int, doc_comments = int }

datavtype parse_state =
  | in_string
  | in_block_comment
  | post_slash
  | post_slash_regular
  | post_backslash_in_string
  | line_comment
  | line_comment_end
  | post_asterisk_in_block_comment
  | post_asterisk_in_block_comment_first_line
  | regular
  | post_newline_whitespace
  | post_block_comment
  | post_tick
  | in_block_comment_first_line

fn parse_state_tostring(st : &parse_state >> _) : string

val empty_file: file

fn file_eq(file, file) : bool

fn count_buf { l : addr | l != null }{m:nat} (!bytes_v(l, m) | ptr(l), bufsz : size_t(m), &parse_state >> _) : file

fn add_file(file, file) : file

fn file_tostring(file) : string

fn free_st(parse_state) : void

overload free with free_st
overload + with add_file
overload = with file_eq
