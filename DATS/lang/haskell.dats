staload "SATS/lang/haskell.sats"
staload "libats/ML/SATS/string.sats"

implement free_st (st) =
  case+ st of
    | ~in_string() => ()
    | ~in_block_comment (_) => ()
    | ~post_lbrace() => ()
    | ~post_lbrace_regular() => ()
    | ~post_backslash_in_string() => ()
    | ~line_comment() => ()
    | ~line_comment_end() => ()
    | ~post_asterisk_in_block_comment (_) => ()
    | ~post_asterisk_in_block_comment_first_line (_) => ()
    | ~regular() => ()
    | ~post_newline_whitespace() => ()
    | ~post_block_comment() => ()
    | ~post_tick() => ()
    | ~in_block_comment_first_line (_) => ()
    | ~post_hyphen() => ()
    | ~post_hyphen_regular() => ()

implement parse_state_tostring (st) =
  case+ st of
    | in_string() => "in_string"
    | in_block_comment (i) => "in_block_comment(" + tostring_int(i) + ")"
    | post_lbrace() => "post_lbrace"
    | post_lbrace_regular() => "post_lbrace_regular"
    | post_backslash_in_string() => "post_backslash_in_string"
    | line_comment() => "line_comment"
    | line_comment_end() => "line_comment_end"
    | post_asterisk_in_block_comment (i) => "post_asterisk_in_block_comment(" + tostring_int(i) + ")"
    | post_asterisk_in_block_comment_first_line (i) => "post_asterisk_in_block_comment_first_line(" + tostring_int(i) + ")"
    | regular() => "regular"
    | post_newline_whitespace() => "post_newline_whitespace"
    | post_block_comment() => "post_block_comment"
    | post_tick() => "post_tick"
    | in_block_comment_first_line (i) => "in_block_comment_first_line(" + tostring_int(i) + ")"
    | post_hyphen() => "post_hyphen"
    | post_hyphen_regular() => "post_hyphen_regular"
