datavtype parse_state_j =
  | post_n
  | post_b
  | line_comment
  | regular
  | post_newline_whitespace

fn parse_state_j_tostring(st : &parse_state_j >> _) : string

fn free_st_j(parse_state_j) : void

overload free with free_st_j
