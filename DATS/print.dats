staload "libats/ML/SATS/string.sats"
staload "SATS/wc.sats"

implement file_tostring (f) =
  "Lines: "
  + tostring_int(f.lines + f.blanks + f.comments + f.doc_comments)
  + " Code: "
  + tostring_int(f.lines)
  + " Blanks: "
  + tostring_int(f.blanks)
  + " Comments: "
  + tostring_int(f.comments)

implement parse_state_tostring (st) =
  case+ st of
    | regular() => "regular"
    | in_block_comment() => "in_block_comment"
    | in_string() => "in_string"
    | post_slash() => "post_slash"
    | post_backslash_in_string() => "post_backslash_is_string"
    | line_comment() => "line_comment"
    | post_asterisk_in_block_comment() => "post_asterisk_in_block_comment"
    | post_newline_whitespace() => "post_newline_whitespace"
    | post_block_comment() => "post_block_comment"
    | post_tick() => "post_tick"
    | in_block_comment_first_line() => "in_block_comment_first_line"
    | line_comment_end() => "line_comment_end"
    | post_slash_regular() => "post_slash_regular"
    | post_asterisk_in_block_comment_first_line() => "post_asterisk_in_block_comment_first_line"
