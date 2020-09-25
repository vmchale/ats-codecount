datavtype parse_state_q =
  | post_slash
  | regular
  | permanent_comment

fn parse_state_q_tostring(st : &parse_state_q >> _) : string

fn free_st_q(parse_state_q) : void

overload free with free_st_q
