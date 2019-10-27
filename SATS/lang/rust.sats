// https://doc.rust-lang.org/reference/tokens.html#character-literals
datavtype parse_state_rs =
  | line_comment
  | line_comment_regular
  | post_slash
  | post_slash_regular
  | regular
  | in_string
  | post_backslash_in_string
  | post_r
  | post_r_hash of int
  | in_raw_string of int
  | maybe_close_hash of (int, int)
  | in_block_comment of int
  | in_block_comment_first_line of int
  | post_slash_in_block_comment of int
  | post_slash_in_block_comment_first_line of int
  | post_asterisk_in_block_comment of int
  | post_asterisk_in_block_comment_first_line of int
  | post_newline_whitespace
  | post_tick
  | maybe_close_char
  | in_char
  | post_block_comment
  | post_backslash_after_tick

fn parse_state_rs_tostring(st : &parse_state_rs >> _) : string

fn free_st_rs(parse_state_rs) : void

overload free with free_st_rs
