datavtype parse_state_hs =
  | in_string
  | in_block_comment of int
  | post_lbrace
  | post_lbrace_regular
  | post_backslash_in_string
  | line_comment
  | line_comment_end
  | post_lbrace_in_block_comment of int
  | post_lbrace_in_block_comment_first_line of int
  | post_hyphen_in_block_comment of int
  | post_hyphen_in_block_comment_first_line of int
  | regular
  | post_newline_whitespace
  | post_block_comment
  | post_tick
  | post_backslash_after_tick
  | in_char
  | lbrace_after_tick
  | hyphen_after_tick
  | maybe_close_char
  | in_block_comment_first_line of int
  | post_hyphen
  | post_hyphen_regular

fn parse_state_hs_tostring(st : &parse_state_hs >> _) : string

fn free_st_hs(parse_state_hs) : void

overload free with free_st_hs
