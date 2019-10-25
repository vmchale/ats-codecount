datavtype parse_state_egi =
  | line_comment
  | regular
  | post_newline_whitespace

fn parse_state_egi_tostring(st : &parse_state_egi >> _) : string

fn free_st_egi(parse_state_egi) : void

overload free with free_st_egi
