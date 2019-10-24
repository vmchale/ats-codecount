// Two special chars: ''${ and '''
datavtype parse_state_dhall =
  | in_multiline_string
  | post_tick_in_multiline_string
  | post_second_tick_in_multiline_string
  | post_maybe_escaped_dollar_sign
  | in_block_comment of int
  | post_lbrace
  | post_lbrace_regular
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
  | in_block_comment_first_line of int
  | post_hyphen
  | post_hyphen_regular

fn parse_state_dhall_tostring(st : &parse_state_dhall >> _) : string

fn free_st_dhall(parse_state_dhall) : void

overload free with free_st_dhall
