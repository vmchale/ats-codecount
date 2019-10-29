staload "SATS/file.sats"
staload "SATS/lang/python.sats"
staload "SATS/lang/common.sats"

implement free_st_py (st) =
  case+ st of
    | ~line_comment() => ()
    | ~regular() => ()
    | ~post_newline_whitespace() => ()
    | ~line_comment_regular() => ()
    | ~in_squote_string() => ()
    | ~in_dquote_string() => ()
    | ~post_squote() => ()
    | ~post_dquote() => ()
    | ~post_squote2() => ()
    | ~post_dquote2() => ()
    | ~post_backslash_squote_string() => ()
    | ~post_backslash_dquote_string() => ()
    | ~in_multiline_dquote_string() => ()
    | ~in_multiline_squote_string() => ()
    | ~post_dquote_in_multiline_string() => ()
    | ~post_dquote2_in_multiline_string() => ()
    | ~post_squote_in_multiline_string() => ()
    | ~post_squote2_in_multiline_string() => ()

implement parse_state_py_tostring (st) =
  case+ st of
    | regular() => "regular"
    | line_comment() => "line_comment"
    | post_newline_whitespace() => "post_newline_whitespace"
    | line_comment_regular() => "line_comment_regular"
    | in_squote_string() => "in_squote_string"
    | in_dquote_string() => "in_dquote_string"
    | in_multiline_squote_string() => "in_multiline_squote_string"
    | in_multiline_dquote_string() => "in_multiline_dquote_string"
    | post_dquote_in_multiline_string() => "post_dquote_in_multiline_string"
    | post_dquote2_in_multiline_string() => "post_dquote2_in_multiline_string"
    | post_squote_in_multiline_string() => "post_squote_in_multiline_string"
    | post_squote2_in_multiline_string() => "post_squote2_in_multiline_string"
    | post_squote() => "post_squote"
    | post_squote2() => "post_squote2"
    | post_dquote() => "post_dquote"
    | post_dquote2() => "post_dquote2"
    | post_backslash_squote_string() => "post_backslash_squote_string"
    | post_backslash_dquote_string() => "post_backslash_dquote_string"

implement free$lang<parse_state_py> (st) =
  free_st_py(st)

implement init$lang<parse_state_py> (st) =
  st := post_newline_whitespace

implement advance_char$lang<parse_state_py> (c, st, file_st) =
  case+ st of
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
    | regular() =>
      begin
        case+ c of
          | '#' => (free(st) ; st := line_comment_regular)
          | '\'' => (free(st) ; st := post_squote)
          | '"' => (free(st) ; st := post_dquote)
          | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | _ => ()
      end
    | post_newline_whitespace() =>
      begin
        case+ c of
          | '#' => (free(st) ; st := line_comment)
          | '\'' => (free(st) ; st := post_squote)
          | '"' => (free(st) ; st := post_dquote)
          | '\n' => (free(st) ; file_st.blanks := file_st.blanks + 1 ; st := post_newline_whitespace)
          | _ => ()
      end
    | in_squote_string() =>
      begin
        case+ c of
          | '\\' => (free(st) ; st := post_backslash_squote_string)
          | '\'' => (free(st) ; st := regular)
          | _ => ()
      end
    | in_dquote_string() =>
      begin
        case+ c of
          | '\\' => (free(st) ; st := post_backslash_dquote_string)
          | '"' => (free(st) ; st := regular)
          | _ => ()
      end
    | in_multiline_squote_string() =>
      begin
        case+ c of
          | '\n' => file_st.lines := file_st.lines + 1
          | '\'' => (free(st) ; st := post_squote_in_multiline_string)
          | _ => ()
      end
    | in_multiline_dquote_string() =>
      begin
        case+ c of
          | '\n' => file_st.lines := file_st.lines + 1
          | '"' => (free(st) ; st := post_dquote_in_multiline_string)
          | _ => ()
      end
    | ~post_dquote_in_multiline_string() =>
      begin
        case+ c of
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := in_multiline_dquote_string)
          | '"' => st := post_dquote2_in_multiline_string
          | _ => st := in_multiline_dquote_string
      end
    | ~post_squote_in_multiline_string() =>
      begin
        case+ c of
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := in_multiline_squote_string)
          | '\'' => st := post_squote2_in_multiline_string
          | _ => st := in_multiline_squote_string
      end
    | ~post_dquote2_in_multiline_string() =>
      begin
        case+ c of
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := in_multiline_dquote_string)
          | '"' => st := regular
          | _ => st := in_multiline_dquote_string
      end
    | ~post_squote2_in_multiline_string() =>
      begin
        case+ c of
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := in_multiline_squote_string)
          | '\'' => st := regular
          | _ => st := in_multiline_squote_string
      end
    | ~post_squote() =>
      begin
        case+ c of
          | '\'' => st := post_squote2
          | _ => st := in_squote_string
      end
    | ~post_dquote() =>
      begin
        case+ c of
          | '"' => st := post_dquote2
          | _ => st := in_dquote_string
      end
    | ~post_squote2() =>
      begin
        case+ c of
          | '\'' => st := in_multiline_squote_string
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | '#' => st := line_comment_regular
          | _ => st := regular
      end
    | ~post_dquote2() =>
      begin
        case+ c of
          | '"' => st := in_multiline_dquote_string
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | '#' => st := line_comment_regular
          | _ => st := regular
      end
    | ~post_backslash_squote_string() => st := in_squote_string
    | ~post_backslash_dquote_string() => st := in_dquote_string
