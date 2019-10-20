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

fn free_st(parse_state) : void

overload free with free_st
