datavtype parse_state_idr =
  | line_comment
  | regular
  | post_newline_whitespace
  | line_comment_regular
  | post_lbrace
  | post_hyphen
  | post_hyphen_regular
  | post_vbar
  | post_vbar2
  | in_doc_comment
  | post_quote
  | post_quote2
  | in_string
  | in_multiline_string
  | post_lbrace_regular
  | in_block_comment of int
  | post_lbrace_in_block_comment of int
  | post_hyphen_in_block_comment of int
  | post_block_comment
  | in_block_comment_first_line of int
  | post_lbrace_in_block_comment_first_line of int
  | post_hyphen_in_block_comment_first_line of int
  | post_tick
  | post_backslash_after_tick
  | maybe_close_char
  | post_backslash_in_string
  | post_quote_in_multiline_string
  | post_quote2_in_multiline_string
  | hyphen_after_tick
  | lbrace_after_tick

fn parse_state_idr_tostring(st : &parse_state_idr >> _) : string

fn free_st_idr(parse_state_idr) : void

overload free with free_st_idr
