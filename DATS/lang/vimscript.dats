staload "SATS/file.sats"
staload "SATS/lang/vimscript.sats"
staload "SATS/lang/common.sats"

implement free_st_vim (st) =
  case+ st of
    | ~line_comment() => ()
    | ~regular() => ()
    | ~post_newline_whitespace() => ()

implement parse_state_vim_tostring (st) =
  case+ st of
    | regular() => "regular"
    | line_comment() => "line_comment"
    | post_newline_whitespace() => "post_newline_whitespace"

implement free$lang<parse_state_vim> (st) =
  free_st_vim(st)

implement init$lang<parse_state_vim> (st) =
  st := post_newline_whitespace

implement advance_char$lang<parse_state_vim> (c, st, file_st) =
  case+ st of
    | regular() => 
      begin
        case+ c of
          | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | _ => ()
      end
    | line_comment() => 
      begin
        case+ c of
          | '\n' => (free(st) ; file_st.comments := file_st.comments + 1 ; st := post_newline_whitespace)
          | _ => ()
      end
    | post_newline_whitespace() => 
      begin
        case+ c of
          | '\n' => (file_st.blanks := file_st.blanks + 1)
          | '\t' => ()
          | ' ' => ()
          | '"' => (free(st) ; st := line_comment)
          | _ => (free(st) ; st := regular)
      end
