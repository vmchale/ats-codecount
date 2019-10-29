staload "libats/ML/SATS/string.sats"
staload "SATS/lang/dhall.sats"
staload "SATS/lang/common.sats"

#include "DATS/lang/common.dats"

implement free_st_dhall (st) =
  case+ st of
    | ~regular() => ()
    | ~in_multiline_string() => ()
    | ~post_tick_in_multiline_string() => ()
    | ~post_second_tick_in_multiline_string() => ()
    | ~post_maybe_escaped_dollar_sign() => ()
    | ~in_block_comment (_) => ()
    | ~post_lbrace() => ()
    | ~post_lbrace_regular() => ()
    | ~line_comment() => ()
    | ~line_comment_end() => ()
    | ~post_lbrace_in_block_comment (_) => ()
    | ~post_lbrace_in_block_comment_first_line (_) => ()
    | ~post_hyphen_in_block_comment (_) => ()
    | ~post_hyphen_in_block_comment_first_line (_) => ()
    | ~post_newline_whitespace() => ()
    | ~post_block_comment() => ()
    | ~post_tick() => ()
    | ~in_block_comment_first_line (_) => ()
    | ~post_hyphen() => ()
    | ~post_hyphen_regular() => ()
    | ~in_string() => ()
    | ~post_backslash_in_string() => ()

implement parse_state_dhall_tostring (st) =
  case+ st of
    | regular() => "regular"
    | in_multiline_string() => "in_multiline_string"
    | post_tick_in_multiline_string() => "post_tick_in_multiline_string"
    | post_second_tick_in_multiline_string() => "post_second_tick_in_multiline_string"
    | post_maybe_escaped_dollar_sign() => "post_maybe_escaped_dollar_sign"
    | in_block_comment (i) => "in_block_comment(" + tostring_int(i) + ")"
    | post_lbrace() => "post_lbrace"
    | post_lbrace_regular() => "post_lbrace_regular"
    | line_comment() => "line_comment"
    | line_comment_end() => "line_comment_end"
    | post_lbrace_in_block_comment (i) => "post_lbrace_in_block_comment(" + tostring_int(i) + ")"
    | post_lbrace_in_block_comment_first_line (i) => "post_lbrace_in_block_comment_first_line(" + tostring_int(i) + ")"
    | post_hyphen_in_block_comment (i) => "post_hyphen_in_block_comment(" + tostring_int(i) + ")"
    | post_hyphen_in_block_comment_first_line (i) => "post_hyphen_in_block_comment_first_line(" + tostring_int(i) + ")"
    | post_newline_whitespace() => "post_newline_whitespace"
    | post_block_comment() => "post_block_comment"
    | post_tick() => "post_tick"
    | in_block_comment_first_line (i) => "in_block_comment_first_line(" + tostring_int(i) + ")"
    | post_hyphen() => "post_hyphen"
    | post_hyphen_regular() => "post_hyphen_regular"
    | in_string() => "in_string"
    | post_backslash_in_string() => "post_backslash_in_string"

implement free$lang<parse_state_dhall> (st) =
  free_st_dhall(st)

implement init$lang<parse_state_dhall> (st) =
  st := post_newline_whitespace

implement advance_char$lang<parse_state_dhall> (c, st, file_st) =
  let
    fn pr_warning() : void =
      prerr!("\33[33mWarning:\33[0m inconsistent state in Dhall lexer.\n")
  in
    case+ st of
      | regular() =>
        begin
          case+ c of
            | '\'' => (free(st) ; st := post_tick)
            | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
            | '-' => (free(st) ; st := post_hyphen_regular)
            | '\{' => (free(st) ; st := post_lbrace_regular)
            | '"' => (free(st) ; st := in_string)
            | _ => ()
        end
      | ~post_tick_in_multiline_string() =>
        begin
          case+ c of
            | '\'' => st := post_second_tick_in_multiline_string
            | '\n' => (file_st.lines := file_st.lines + 1 ; st := in_multiline_string)
            | _ => st := in_multiline_string
        end
      | ~post_second_tick_in_multiline_string() =>
        begin
          case+ c of
            | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
            | '-' => st := post_hyphen_regular
            | '\{' => st := post_lbrace_regular
            | '\'' => st := in_multiline_string
            | '$' => st := post_maybe_escaped_dollar_sign
            | _ => st := regular
        end
      | ~post_maybe_escaped_dollar_sign() =>
        begin
          case+ c of
            | '\{' => st := in_multiline_string
            | '\n' => (pr_warning() ; file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
            | _ => (pr_warning() ; st := regular)
        end
      | in_block_comment (i) =>
        begin
          case+ c of
            | '\{' => (free(st) ; st := post_lbrace_in_block_comment(i))
            | '\n' => file_st.lines := file_st.lines + 1
            | '-' => (free(st) ; st := post_hyphen_in_block_comment(i))
            | _ => ()
        end
      | ~post_lbrace() =>
        begin
          case+ c of
            | '-' => st := in_block_comment(1)
            | '\{' => st := post_lbrace_regular
            | '\'' => st := post_tick
            | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
            | '"' => st := in_string
            | _ => st := regular
        end
      | post_lbrace_regular() =>
        begin
          case+ c of
            | '-' => (free(st) ; st := in_block_comment_first_line(1))
            | '\{' => ()
            | '\'' => (free(st) ; st := post_tick)
            | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
            | '"' => (free(st) ; st := in_string)
            | _ => (free(st) ; st := regular)
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
      | post_lbrace_in_block_comment (i) =>
        begin
          case+ c of
            | '-' => (free(st) ; st := in_block_comment(i + 1))
            | '\{' => ()
            | '\n' => file_st.comments := file_st.comments + 1
            | _ => (free(st) ; st := in_block_comment(i))
        end
      | post_lbrace_in_block_comment_first_line (i) =>
        begin
          case+ c of
            | '-' => (free(st) ; st := in_block_comment_first_line(i + 1))
            | '\{' => ()
            | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := in_block_comment(i))
            | _ => (free(st) ; st := in_block_comment_first_line(i))
        end
      | post_hyphen_in_block_comment (i) =>
        begin
          case+ c of
            | '}' when i - 1 = 0 => (free(st) ; st := post_block_comment)
            | '}' => (free(st) ; st := in_block_comment(i - 1))
            | '-' => ()
            | '\n' => file_st.comments := file_st.comments + 1
            | _ => (free(st) ; st := in_block_comment(i))
        end
      | post_hyphen_in_block_comment_first_line (i) =>
        begin
          case+ c of
            | '}' when i - 1 = 0 => (free(st) ; st := regular)
            | '}' => (free(st) ; st := in_block_comment_first_line(i - 1))
            | '-' => ()
            | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := in_block_comment(i))
            | _ => (free(st) ; st := in_block_comment(i))
        end
      | post_newline_whitespace() =>
        begin
          case+ c of
            | '\n' => file_st.blanks := file_st.blanks + 1
            | ' ' => ()
            | '\t' => ()
            | '-' => (free(st) ; st := post_hyphen)
            | '\{' => (free(st) ; st := post_lbrace)
            | '\'' => (free(st) ; st := post_tick)
            | '"' => (free(st) ; st := in_string)
            | _ => (free(st) ; st := regular)
        end
      | post_block_comment() =>
        begin
          case+ c of
            | '\n' => (free(st) ; file_st.comments := file_st.comments + 1 ; st := post_newline_whitespace)
            | ' ' => ()
            | '\t' => ()
            | '\'' => (free(st) ; st := post_tick)
            | '"' => (free(st) ; st := in_string)
            | _ => (free(st) ; st := regular)
        end
      | ~post_tick() =>
        begin
          case+ c of
            | '\'' => st := in_multiline_string
            | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
            | '-' => st := post_hyphen_regular
            | '\{' => st := post_lbrace_regular
            | '"' => st := in_string
            | _ => st := regular
        end
      | in_block_comment_first_line (i) =>
        begin
          case+ c of
            | '-' => (free(st) ; st := post_hyphen_in_block_comment_first_line(i))
            | '\{' => (free(st) ; st := post_lbrace_in_block_comment_first_line(i))
            | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := in_block_comment(i))
            | _ => ()
        end
      | ~post_hyphen() =>
        begin
          case+ c of
            | '-' => st := line_comment
            | '\'' => st := post_tick
            | '\{' => st := post_lbrace
            | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
            | '"' => st := in_string
            | _ => st := regular
        end
      | ~post_hyphen_regular() =>
        begin
          case+ c of
            | '-' => st := line_comment_end
            | '\'' => st := post_tick
            | '\{' => st := post_lbrace
            | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
            | '"' => st := in_string
            | _ => st := regular
        end
      | in_multiline_string() =>
        begin
          case+ c of
            | '\'' => (free(st) ; st := post_tick_in_multiline_string)
            | '\n' => file_st.lines := file_st.lines + 1
            | _ => ()
        end
      | in_string() =>
        begin
          case+ c of
            | '"' => (free(st) ; st := regular)
            | '\\' => (free(st) ; st := post_backslash_in_string)
            | _ => ()
        end
      | ~post_backslash_in_string() => st := in_string
  end
