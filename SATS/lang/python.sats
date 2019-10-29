datavtype parse_state_py =
  | line_comment
  | line_comment_regular
  | regular
  | post_newline_whitespace
  | in_squote_string
  | in_dquote_string
  | in_multiline_squote_string
  | in_multiline_dquote_string
  | post_dquote_in_multiline_string
  | post_dquote2_in_multiline_string
  | post_squote_in_multiline_string
  | post_squote2_in_multiline_string
  | post_squote
  | post_squote2
  | post_dquote
  | post_dquote2
  | post_backslash_squote_string
  | post_backslash_dquote_string

fn parse_state_py_tostring(st : &parse_state_py >> _) : string

fn free_st_py(parse_state_py) : void

overload free with free_st_py
