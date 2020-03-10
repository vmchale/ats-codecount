datavtype parse_state_csv =
  | regular
  | post_newline_whitespace

fn parse_state_csv_tostring(st : &parse_state_csv >> _) : string

fn free_st_csv(parse_state_csv) : void

overload free with free_st_csv
