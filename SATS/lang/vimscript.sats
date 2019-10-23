datavtype parse_state_vim =
  | line_comment
  | regular
  | post_newline_whitespace

fn parse_state_vim_tostring(st : &parse_state_vim >> _) : string

fn free_st_vim(parse_state_vim) : void

overload free with free_st_vim
