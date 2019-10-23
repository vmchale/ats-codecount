staload "libats/ML/SATS/string.sats"
staload "SATS/lang/haskell.sats"
staload "SATS/lang/common.sats"

#include "DATS/lang/common.dats"

implement free_st (st) =
  case+ st of
    | ~in_string() => ()
    | ~in_block_comment (_) => ()
    | ~post_lbrace() => ()
    | ~post_lbrace_regular() => ()
    | ~post_backslash_in_string() => ()
    | ~line_comment() => ()
    | ~line_comment_end() => ()
    | ~post_hyphen_in_block_comment (_) => ()
    | ~post_hyphen_in_block_comment_first_line (_) => ()
    | ~regular() => ()
    | ~post_newline_whitespace() => ()
    | ~post_block_comment() => ()
    | ~post_tick() => ()
    | ~post_backslash_after_tick() => ()
    | ~in_char() => ()
    | ~lbrace_after_tick() => ()
    | ~hyphen_after_tick() => ()
    | ~maybe_close_char() => ()
    | ~in_block_comment_first_line (_) => ()
    | ~post_hyphen() => ()
    | ~post_hyphen_regular() => ()
    | ~post_lbrace_in_block_comment (_) => ()
    | ~post_lbrace_in_block_comment_first_line (_) => ()

implement parse_state_hs_tostring (st) =
  case+ st of
    | in_string() => "in_string"
    | in_block_comment (i) => "in_block_comment(" + tostring_int(i) + ")"
    | post_lbrace() => "post_lbrace"
    | post_lbrace_regular() => "post_lbrace_regular"
    | post_backslash_in_string() => "post_backslash_in_string"
    | line_comment() => "line_comment"
    | line_comment_end() => "line_comment_end"
    | post_hyphen_in_block_comment (i) => "post_hyphen_in_block_comment(" + tostring_int(i) + ")"
    | post_hyphen_in_block_comment_first_line (i) => "post_hyphen_in_block_comment_first_line(" + tostring_int(i) + ")"
    | regular() => "regular"
    | post_newline_whitespace() => "post_newline_whitespace"
    | post_block_comment() => "post_block_comment"
    | post_tick() => "post_tick"
    | post_backslash_after_tick() => "post_backslash_after_tick"
    | in_char() => "in_char"
    | lbrace_after_tick() => "lbrace_after_tick"
    | hyphen_after_tick() => "hyphen_after_tick"
    | maybe_close_char() => "maybe_close_char"
    | in_block_comment_first_line (i) => "in_block_comment_first_line(" + tostring_int(i) + ")"
    | post_hyphen() => "post_hyphen"
    | post_hyphen_regular() => "post_hyphen_regular"
    | post_lbrace_in_block_comment (i) => "post_lbrace_in_block_comment(" + tostring_int(i) + ")"
    | post_lbrace_in_block_comment_first_line (i) => "post_lbrace_in_block_comment_first_line(" + tostring_int(i) + ")"

implement free$lang<parse_state_hs> (st) =
  free_st(st)

implement advance_char$lang<parse_state_hs> (c, st, file_st) =
  case+ st of
    | in_string() =>
      begin
        case+ c of
          | '\\' => (free(st) ; st := post_backslash_in_string)
          | '\n' => file_st.lines := file_st.lines + 1
          | '"' => (free(st) ; st := regular)
          | _ => ()
      end
    | in_block_comment (n) =>
      begin
        case+ c of
          | '\n' => file_st.comments := file_st.comments + 1
          | '-' => (free(st) ; st := post_hyphen_in_block_comment(n))
          | '\{' => (free(st) ; st := post_lbrace_in_block_comment(n))
          | _ => ()
      end
    | post_lbrace() =>
      begin
        case+ c of
          | '-' => (free(st) ; st := in_block_comment(1))
          | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | '\{' => ()
          | '"' => (free(st) ; st := in_string)
          | _ => (free(st) ; st := regular)
      end
    | post_lbrace_regular() =>
      begin
        case+ c of
          | '-' => (free(st) ; st := in_block_comment_first_line(1))
          | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | '\{' => ()
          | '"' => (free(st) ; st := in_string)
          | _ => (free(st) ; st := regular)
      end
    | ~post_backslash_in_string() =>
      begin
        case+ c of
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := in_string)
          | _ => st := in_string
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
    | post_lbrace_in_block_comment (n) =>
      begin
        case+ c of
          | '-' => (free(st) ; st := in_block_comment(n + 1))
          | '\{' => ()
          | '\n' => (free(st) ; file_st.comments := file_st.comments + 1 ; st := in_block_comment(n))
          | _ => ()
      end
    | post_lbrace_in_block_comment_first_line (n) =>
      begin
        case+ c of
          | '-' => (free(st) ; st := in_block_comment_first_line(n + 1))
          | '\{' => ()
          | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := in_block_comment(n))
          | _ => ()
      end
    | post_hyphen_in_block_comment (n) =>
      begin
        case+ c of
          | '}' when n - 1 = 0 => (free(st) ; st := post_block_comment)
          | '}' => (free(st) ; st := in_block_comment(n - 1))
          | '-' => ()
          | '\n' => file_st.comments := file_st.comments + 1
          | _ => (free(st) ; st := in_block_comment(n))
      end
    | post_hyphen_in_block_comment_first_line (n) =>
      begin
        case+ c of
          | '}' when n - 1 = 0 => (free(st) ; st := regular)
          | '}' => (free(st) ; st := in_block_comment(n - 1))
          | '-' => ()
          | '\n' => file_st.lines := file_st.lines + 1
          | _ => (free(st) ; st := in_block_comment(n))
      end
    | regular() =>
      begin
        case+ c of
          | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | '\{' => (free(st) ; st := post_lbrace_regular)
          | '\'' => (free(st) ; st := post_tick)
          | '"' => (free(st) ; st := in_string)
          | '-' => (free(st) ; st := post_hyphen_regular)
          | _ => ()
      end
    | post_newline_whitespace() =>
      begin
        case+ c of
          | '\n' => file_st.blanks := file_st.blanks + 1
          | '\t' => ()
          | ' ' => ()
          | '-' => (free(st) ; st := post_hyphen)
          | '\{' => (free(st) ; st := post_lbrace)
          | '"' => (free(st) ; st := in_string)
          | _ => (free(st) ; st := regular)
      end
    | post_block_comment() =>
      begin
        case+ c of
          | '\n' => (free(st) ; file_st.comments := file_st.comments + 1 ; st := post_newline_whitespace)
          | '\t' => ()
          | ' ' => ()
          | '\'' => (free(st) ; st := post_tick)
          | '"' => (free(st) ; st := in_string)
          | '\{' => (free(st) ; st := post_lbrace)
          | '-' => (free(st) ; st := post_hyphen)
          | _ => (free(st) ; st := regular)
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
    | ~post_backslash_after_tick() => st := in_char
    | in_char() =>
      begin
        case+ c of
          | '\'' => (free(st) ; st := regular)
          | _ => ()
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
    | ~hyphen_after_tick() =>
      begin
        case+ c of
          | '-' => st := line_comment_end
          | '\{' => st := post_lbrace_regular
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | '"' => st := in_string
          | _ => st := regular
      end
    | ~maybe_close_char() =>
      begin
        case+ c of
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | '"' => st := in_string
          | '-' => st := post_hyphen
          | '\{' => st := post_lbrace_regular
          | _ => st := regular
      end
    | in_block_comment_first_line (n) =>
      begin
        case+ c of
          | '-' => (free(st) ; st := post_hyphen_in_block_comment_first_line(n))
          | '\{' => (free(st) ; st := post_lbrace_in_block_comment_first_line(n))
          | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := in_block_comment(n))
          | _ => ()
      end
    | ~post_hyphen() =>
      begin
        case+ c of
          | '-' => st := line_comment
          | '\'' => st := post_tick
          | '\{' => st := post_lbrace_regular
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | '"' => st := in_string
          | _ => st := regular
      end
    | ~post_hyphen_regular() =>
      begin
        case+ c of
          | '-' => st := line_comment_end
          | '\'' => st := post_tick
          | '\{' => st := post_lbrace_regular
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | '"' => st := in_string
          | _ => st := regular
      end

implement init$lang<parse_state_hs> (st) =
  st := post_newline_whitespace
