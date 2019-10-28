staload "SATS/file.sats"
staload "SATS/lang/assembly.sats"
staload "SATS/lang/common.sats"

implement free_st_as (st) =
  case+ st of
    | ~line_comment() => ()
    | ~regular() => ()
    | ~post_newline_whitespace() => ()
    | ~in_string() => ()
    | ~post_backslash_in_string() => ()
    | ~post_slash() => ()
    | ~post_asterisk_in_block_comment() => ()
    | ~post_block_comment() => ()
    | ~in_block_comment() => ()
    | ~line_comment_regular() => ()
    | ~in_block_comment_line_end() => ()
    | ~post_slash_regular() => ()
    | ~post_asterisk_in_block_comment_line_end() => ()
    | ~post_tick() => ()
    | ~maybe_close_char() => ()

implement parse_state_as_tostring (st) =
  case+ st of
    | regular() => "regular"
    | line_comment() => "line_comment"
    | post_newline_whitespace() => "post_newline_whitespace"
    | in_string() => "in_string"
    | post_backslash_in_string() => "post_backslash_in_string"
    | in_block_comment() => "in_block_comment"
    | post_slash() => "post_slash"
    | post_asterisk_in_block_comment() => "post_asterisk_in_block_comment"
    | post_block_comment() => "post_block_comment"
    | line_comment_regular() => "line_comment_regular"
    | in_block_comment_line_end() => "in_block_comment_line_end"
    | post_slash_regular() => "post_slash_regular"
    | post_asterisk_in_block_comment_line_end() => "post_asterisk_in_block_comment_line_end"
    | post_tick() => "post_tick"
    | maybe_close_char() => "maybe_close_char"

implement free$lang<parse_state_as> (st) =
  free_st_as(st)

implement init$lang<parse_state_as> (st) =
  st := post_newline_whitespace

implement advance_char$lang<parse_state_as> (c, st, file_st) =
  case- st of
    | regular() => 
      begin
        case+ c of
          | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | '#' => (free(st) ; st := line_comment_regular)
          | ';' => (free(st) ; st := line_comment_regular)
          | '/' => (free(st) ; st := post_slash_regular)
          | '\'' => (free(st) ; st := post_tick)
          | '"' => (free(st) ; st := in_string)
          | _ => ()
      end
    | line_comment() => 
      begin
        case+ c of
          | '\n' => (free(st) ; file_st.comments := file_st.comments + 1 ; st := post_newline_whitespace)
          | _ => ()
      end
    | line_comment_regular() => 
      begin
        case+ c of
          | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | _ => ()
      end
