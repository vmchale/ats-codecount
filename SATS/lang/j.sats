datavtype parse_state_j =
  | in_string
  | post_n
  | post_b
  | post_n_regular
  | post_b_regular
  | line_comment
  | line_comment_end
  | regular
  | post_newline_whitespace

fn parse_state_j_tostring(st : &parse_state_j >> _) : string

fn free_st_j(parse_state_j) : void

overload free with free_st_j
