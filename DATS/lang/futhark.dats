staload "SATS/file.sats"
staload "SATS/lang/futhark.sats"
staload "SATS/lang/common.sats"

implement free_st_fut (st) =
  case+ st of
    | ~line_comment() => ()
    | ~regular() => ()
    | ~post_newline_whitespace() => ()
    | ~post_hyphen() => ()

implement parse_state_fut_tostring (st) =
  case+ st of
    | regular() => "regular"
    | line_comment() => "line_comment"
    | post_newline_whitespace() => "post_newline_whitespace"
    | post_hyphen() => "post_hyphen"

implement free$lang<parse_state_fut> (st) =
  free_st_fut(st)

implement init$lang<parse_state_fut> (st) =
  st := post_newline_whitespace

implement advance_char$lang<parse_state_fut> (c, st, file_st) =
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
          | '-' => (free(st) ; st := post_hyphen)
          | _ => (free(st) ; st := regular)
      end
    | ~post_hyphen() =>
      begin
        case+ c of
          | '-' => st := line_comment
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | _ => st := regular
      end
