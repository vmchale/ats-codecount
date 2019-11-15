datavtype parse_state_json =
  | regular
  | post_newline_whitespace

fn parse_state_json_tostring(st : &parse_state_json >> _) : string

fn free_st_json(parse_state_json) : void

overload free with free_st_json
