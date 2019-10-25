datavtype parse_state_tex =
  | line_comment
  | regular
  | post_newline_whitespace

fn parse_state_tex_tostring(st : &parse_state_tex >> _) : string

fn free_st_tex(parse_state_tex) : void

overload free with free_st_tex
