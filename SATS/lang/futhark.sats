datavtype parse_state_fut =
  | line_comment
  | regular
  | post_newline_whitespace
  | post_hyphen

fn parse_state_fut_tostring(st : &parse_state_fut >> _) : string

fn free_st_fut(parse_state_fut) : void

overload free with free_st_fut
