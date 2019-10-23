staload "SATS/file.sats"
staload "SATS/lang/j.sats"
staload "SATS/lang/common.sats"

implement free_st_j (st) =
  case+ st of
    | ~post_n() => ()
    | ~post_b() => ()
    | ~line_comment() => ()
    | ~regular() => ()
    | ~post_newline_whitespace() => ()

implement parse_state_j_tostring (st) =
  case+ st of
    | regular() => "regular"
    | post_n() => "post_n"
    | post_b() => "post_b"
    | line_comment() => "line_comment"
    | post_newline_whitespace() => "post_newline_whitespace"

implement free$lang<parse_state_j> (st) =
  free_st_j(st)

implement init$lang<parse_state_j> (st) =
  st := post_newline_whitespace

implement advance_char$lang<parse_state_j> (c, st, file_st) =
  case+ st of
    | regular() =>
      begin
        case+ c of
          | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | _ => ()
      end
    | post_n() =>
      begin
        case+ c of
          | 'B' => (free(st) ; st := post_b)
          | 'N' => ()
          | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | _ => (free(st) ; st := regular)
      end
    | ~post_b() =>
      begin
        case+ c of
          | '.' => st := line_comment
          | 'N' => st := post_n
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | _ => st := regular
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
          | 'N' => (free(st) ; st := post_n)
          | _ => (free(st) ; st := regular)
      end
