staload "SATS/lang/haskell.sats"

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
