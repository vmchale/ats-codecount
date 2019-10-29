staload "libats/ML/SATS/string.sats"
staload "SATS/file.sats"
staload "SATS/lang/idris.sats"
staload "SATS/lang/common.sats"

implement free_st_idr (st) =
  case+ st of
    | ~line_comment() => ()
    | ~regular() => ()
    | ~post_newline_whitespace() => ()
    | ~line_comment_regular() => ()
    | ~post_lbrace() => ()
    | ~post_lbrace_regular() => ()
    | ~post_hyphen() => ()
    | ~post_vbar() => ()
    | ~post_vbar2() => ()
    | ~in_doc_comment() => ()
    | ~post_quote() => ()
    | ~post_quote2() => ()
    | ~in_string() => ()
    | ~in_multiline_string() => ()
    | ~in_block_comment (_) => ()
    | ~post_lbrace_in_block_comment (_) => ()
    | ~post_hyphen_in_block_comment (_) => ()
    | ~post_block_comment() => ()
    | ~post_hyphen_in_block_comment_first_line (_) => ()
    | ~post_lbrace_in_block_comment_first_line (_) => ()
    | ~in_block_comment_first_line (_) => ()
    | ~post_tick() => ()
    | ~post_backslash_after_tick() => ()
    | ~maybe_close_char() => ()
    | ~post_hyphen_regular() => ()
    | ~post_backslash_in_string() => ()
    | ~post_quote_in_multiline_string() => ()
    | ~post_quote2_in_multiline_string() => ()
    | ~hyphen_after_tick() => ()
    | ~lbrace_after_tick() => ()

implement parse_state_idr_tostring (st) =
  case+ st of
    | regular() => "regular"
    | line_comment() => "line_comment"
    | post_newline_whitespace() => "post_newline_whitespace"
    | line_comment_regular() => "line_comment_regular"
    | post_lbrace() => "post_lbrace"
    | post_lbrace_regular() => "post_lbrace_regular"
    | post_hyphen() => "post_hyphen"
    | post_vbar() => "post_vbar"
    | post_vbar2() => "post_vbar2"
    | in_doc_comment() => "in_doc_comment"
    | post_quote() => "post_quote"
    | post_quote2() => "post_quote2"
    | in_string() => "in_string"
    | in_multiline_string() => "in_multiline_string"
    | in_block_comment (i) => "in_block_comment(" + tostring_int(i) + ")"
    | post_lbrace_in_block_comment (i) => "post_lbrace_in_block_comment(" + tostring_int(i) + ")"
    | post_hyphen_in_block_comment (i) => "post_hyphen_in_block_comment(" + tostring_int(i) + ")"
    | post_block_comment() => "post_block_comment"
    | in_block_comment_first_line (i) => "in_block_comment_first_line(" + tostring_int(i) + ")"
    | post_lbrace_in_block_comment_first_line (i) => "post_lbrace_in_block_comment_first_line(" + tostring_int(i) + ")"
    | post_hyphen_in_block_comment_first_line (i) => "post_hyphen_in_block_comment_first_line(" + tostring_int(i) + ")"
    | post_tick() => "post_tick"
    | post_backslash_after_tick() => "post_backslash_after_tick"
    | maybe_close_char() => "maybe_close_char"
    | post_hyphen_regular() => "post_hyphen_regular"
    | post_backslash_in_string() => "post_backslash_in_string"
    | post_quote_in_multiline_string() => "post_quote_in_multiline_string"
    | post_quote2_in_multiline_string() => "post_quote2_in_multiline_string"
    | hyphen_after_tick() => "hyphen_after_tick"
    | lbrace_after_tick() => "lbrace_after_tick"

implement free$lang<parse_state_idr> (st) =
  free_st_idr(st)

implement init$lang<parse_state_idr> (st) =
  st := post_newline_whitespace

implement advance_char$lang<parse_state_idr> (c, st, file_st) =
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
          | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | '"' => (free(st) ; st := post_quote)
          | '-' => (free(st) ; st := post_hyphen_regular)
          | '\{' => (free(st) ; st := post_lbrace_regular)
          | _ => ()
      end
    | post_newline_whitespace() =>
      begin
        case+ c of
          | '\n' => (free(st) ; file_st.blanks := file_st.blanks + 1 ; st := post_newline_whitespace)
          | '|' => (free(st) ; st := post_vbar)
          | '"' => (free(st) ; st := post_quote)
          | '-' => (free(st) ; st := post_hyphen)
          | '\{' => (free(st) ; st := post_lbrace)
          | ' ' => ()
          | '\t' => ()
          | _ => (free(st) ; st := regular)
      end
    | ~post_lbrace() =>
      begin
        case+ c of
          | '\{' => st := post_lbrace_regular
          | '-' => st := in_block_comment(1)
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | '"' => st := post_quote
          | '\'' => st := post_tick
          | _ => st := regular
      end
    | ~post_hyphen() =>
      begin
        case+ c of
          | '-' => st := line_comment
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | '"' => st := post_quote
          | '\'' => st := post_tick
          | '\{' => st := post_lbrace
          | _ => st := regular
      end
    | ~post_hyphen_regular() =>
      begin
        case+ c of
          | '-' => st := line_comment_regular
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | '"' => st := post_quote
          | '\'' => st := post_tick
          | '\{' => st := post_lbrace_regular
          | _ => st := regular
      end
    | ~post_vbar() =>
      begin
        case+ c of
          | '|' => st := post_vbar2
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | '-' => st := post_hyphen_regular
          | '\{' => st := post_lbrace_regular
          | '"' => st := post_quote
          | '\'' => st := post_tick
          | _ => st := regular
      end
    | ~post_vbar2() =>
      begin
        case+ c of
          | '|' => st := in_doc_comment
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | '-' => st := post_hyphen_regular
          | '\{' => st := post_lbrace_regular
          | '"' => st := post_quote
          | '\'' => st := post_tick
          | _ => st := regular
      end
    | in_doc_comment() =>
      begin
        case+ c of
          | '\n' => (free(st) ; file_st.doc_comments := file_st.doc_comments + 1 ; st := post_newline_whitespace)
          | _ => ()
      end
    | ~post_quote() =>
      begin
        case+ c of
          | '"' => st := post_quote2
          | _ => st := in_string
      end
    | ~post_quote2() =>
      begin
        case+ c of
          | '"' => st := in_multiline_string
          | '-' => st := post_hyphen_regular
          | '\{' => st := post_lbrace_regular
          | '\'' => st := post_tick
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | _ => st := regular
      end
    | in_string() =>
      begin
        case+ c of
          | '\\' => (free(st) ; st := post_backslash_in_string)
          | '"' => (free(st) ; st := regular)
          | _ => ()
      end
    | in_multiline_string() =>
      begin
        case+ c of
          | '\n' => file_st.lines := file_st.lines + 1
          | '"' => (free(st) ; st := post_quote_in_multiline_string)
          | _ => ()
      end
    | post_lbrace_regular() =>
      begin
        case+ c of
          | '-' => (free(st) ; st := in_block_comment_first_line(1))
          | '\{' => ()
          | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | '"' => (free(st) ; st := post_quote)
          | '\'' => (free(st) ; st := post_tick)
          | _ => (free(st) ; st := regular)
      end
    | in_block_comment (i) =>
      begin
        case+ c of
          | '-' => (free(st) ; st := post_hyphen_in_block_comment(i))
          | '\n' => file_st.comments := file_st.comments + 1
          | '\{' => (free(st) ; st := post_lbrace_in_block_comment(i))
          | _ => ()
      end
    | post_lbrace_in_block_comment (i) =>
      begin
        case+ c of
          | '-' => (free(st) ; st := in_block_comment(i + 1))
          | '\{' => ()
          | '\n' => (free(st) ; file_st.comments := file_st.comments + 1 ; st := in_block_comment(i))
          | _ => (free(st) ; st := in_block_comment(i))
      end
    | post_hyphen_in_block_comment (i) =>
      begin
        case+ c of
          | '}' when i - 1 = 0 => (free(st) ; st := post_block_comment)
          | '}' => (free(st) ; st := in_block_comment(i - 1))
          | '-' => ()
          | '\n' => (free(st) ; file_st.comments := file_st.comments + 1 ; st := in_block_comment(i))
          | '\{' => (free(st) ; st := post_lbrace_in_block_comment(i))
          | _ => (free(st) ; st := in_block_comment(i))
      end
    | post_block_comment() =>
      begin
        case+ c of
          | '\n' => (free(st) ; file_st.comments := file_st.comments + 1 ; st := post_newline_whitespace)
          | ' ' => ()
          | '\t' => ()
          | '\{' => (free(st) ; st := post_lbrace)
          | '-' => (free(st) ; st := post_hyphen)
          | '"' => (free(st) ; st := post_quote)
          | '\'' => (free(st) ; st := post_tick)
          | _ => (free(st) ; st := regular)
      end
    | in_block_comment_first_line (i) =>
      begin
        case+ c of
          | '-' => (free(st) ; st := post_hyphen_in_block_comment_first_line(i))
          | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := in_block_comment(i))
          | '\{' => (free(st) ; st := post_lbrace_in_block_comment_first_line(i))
          | _ => ()
      end
    | post_lbrace_in_block_comment_first_line (i) =>
      begin
        case+ c of
          | '-' => (free(st) ; st := in_block_comment_first_line(i + 1))
          | '\{' => ()
          | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := in_block_comment(i))
          | _ => (free(st) ; st := in_block_comment_first_line(i))
      end
    | post_hyphen_in_block_comment_first_line (i) =>
      begin
        case+ c of
          | '}' when i - 1 = 0 => (free(st) ; st := post_block_comment)
          | '}' => (free(st) ; st := in_block_comment_first_line(i - 1))
          | '-' => ()
          | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := in_block_comment_first_line(i))
          | '\{' => (free(st) ; st := post_lbrace_in_block_comment_first_line(i))
          | _ => (free(st) ; st := in_block_comment_first_line(i))
      end
    | ~post_tick() =>
      begin
        case+ c of
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | '\\' => st := post_backslash_after_tick
          | '-' => st := hyphen_after_tick
          | '\{' => st := lbrace_after_tick
          | '\'' => st := regular
          | _ => st := maybe_close_char
      end
    | ~post_backslash_after_tick() => st := maybe_close_char
    | ~maybe_close_char() =>
      begin
        case+ c of
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | '"' => st := in_string
          | '-' => st := post_hyphen_regular
          | '\{' => st := post_lbrace_regular
          | _ => st := regular
      end
    | ~post_backslash_in_string() => st := in_string
    | ~post_quote_in_multiline_string() =>
      begin
        case+ c of
          | '"' => st := post_quote2_in_multiline_string
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := in_multiline_string)
          | _ => st := in_multiline_string
      end
    | ~post_quote2_in_multiline_string() =>
      begin
        case+ c of
          | '"' => st := regular
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := in_multiline_string)
          | _ => st := in_multiline_string
      end
    | ~hyphen_after_tick() =>
      begin
        case+ c of
          | '-' => st := line_comment_regular
          | '\{' => st := post_lbrace_regular
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | '"' => st := in_string
          | _ => st := regular
      end
    | ~lbrace_after_tick() =>
      begin
        case+ c of
          | '-' => st := in_block_comment_first_line(1)
          | '\{' => st := post_lbrace_regular
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | '"' => st := in_string
          | _ => st := regular
      end
