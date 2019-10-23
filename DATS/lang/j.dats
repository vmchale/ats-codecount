staload "SATS/file.sats"
staload "SATS/lang/j.sats"
staload "SATS/lang/common.sats"

implement free_st_j (st) =
  case+ st of
    | ~in_string () => ()
    | ~post_n() => ()
    | ~post_b() => ()
    | ~post_n_regular() => ()
    | ~post_b_regular() => ()
    | ~line_comment() => ()
    | ~line_comment_end() => ()
    | ~regular() => ()
    | ~post_newline_whitespace() => ()

implement parse_state_j_tostring (st) =
  case+ st of
    | regular() => "regular"
    | in_string() => "in_string"
    | post_n() => "post_n"
    | post_b() => "post_b"
    | post_n_regular() => "post_n_regular"
    | post_b_regular() => "post_b_regular"
    | line_comment() => "line_comment"
    | post_newline_whitespace() => "post_newline_whitespace"
    | line_comment_end() => "line_comment_end"

implement free$lang<parse_state_j> (st) =
  free_st_j(st)

implement advance_char$lang<parse_state_j> (c, st, file_st) =
  case+ st of
    | regular() =>
      begin
        case+ c of
          | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | '\'' => (free(st) ; st := in_string)
          | 'N' => (free(st) ; st := post_n)
          | _ => ()
      end
    | post_n() =>
      begin
        case+ c of
          | 'B' => (free(st) ; st := post_b)
          | 'N' => ()
          | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | '\'' => (free(st) ; st := in_string)
          | _ => (free(st) ; st := regular)
      end
    | ~post_b() =>
      begin
        case+ c of
          | '.' => st := line_comment
          | 'N' => st := post_n
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | '\'' => st := in_string
          | _ => st := regular
      end
    | post_n_regular() =>
      begin
        case+ c of
          | 'B' => (free(st) ; st := post_b_regular)
          | 'N' => ()
          | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | '\'' => (free(st) ; st := in_string)
          | _ => (free(st) ; st := regular)
      end
    | ~post_b_regular() =>
      begin
        case+ c of
          | '.' => st := line_comment_end
          | 'N' => st := post_n
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | '\'' => st := in_string
          | _ => st := regular
      end
    | in_string() =>
      begin
        case+ c of
          | '\'' => (free(st) ; st := regular)
          | _ => ()
      end
    | line_comment() =>
      begin
        case+ c of
          | '\n' => (free(st) ; file_st.comments := file_st.comments + 1 ; st := post_newline_whitespace)
          | _ => ()
      end
    | line_comment_end() =>
      begin
        case+ c of
          | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | _ => ()
      end
    | post_newline_whitespace() =>
      begin
        case+ c of
          | '\n' => (file_st.blanks := file_st.blanks + 1)
          | '\t' => ()
          | ' ' => ()
          | '\'' => (free(st) ; st := in_string)
          | _ => (free(st) ; st := regular)
      end
