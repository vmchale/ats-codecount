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
    | ~post_char_backslash() => ()
    | ~in_char() => ()

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
    | post_char_backslash() => "post_char_backslash"
    | in_char() => "in_char"

implement free$lang<parse_state_as> (st) =
  free_st_as(st)

implement init$lang<parse_state_as> (st) =
  st := post_newline_whitespace

implement advance_char$lang<parse_state_as> (c, st, file_st) =
  let
    fn pr_warning() : void =
      prerr!("\33[33mWarning:\33[0m inconsistent state in Dhall lexer.\n")
  in
    case+ st of
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
      | in_string() =>
        begin
          case+ c of
            | '\\' => (free(st) ; st := post_backslash_in_string)
            | '"' => (free(st) ; st := regular)
            | _ => ()
        end
      | ~post_backslash_in_string() => st := in_string
      | post_block_comment() =>
        begin
          case+ c of
            | '\n' => (free(st) ; file_st.comments := file_st.comments + 1 ; st := post_newline_whitespace)
            | ' ' => ()
            | '\t' => ()
            | '#' => (free(st) ; st := line_comment)
            | '\'' => (free(st) ; st := post_tick)
            | '"' => (free(st) ; st := in_string)
            | '/' => (free(st) ; st := post_slash)
            | _ => (free(st) ; st := regular)
        end
      | in_block_comment() =>
        begin
          case+ c of
            | '\n' => file_st.comments := file_st.comments + 1
            | '*' => (free(st) ; st := post_asterisk_in_block_comment)
            | _ => ()
        end
      | ~post_slash() =>
        begin
          case+ c of
            | '*' => st := in_block_comment
            | _ => (pr_warning() ; st := regular)
        end
      | post_asterisk_in_block_comment() =>
        begin
          case+ c of
            | '*' => ()
            | '\n' => (free(st) ; file_st.comments := file_st.comments + 1 ; st := in_block_comment)
            | '/' => (free(st) ; st := post_block_comment)
            | _ => (free(st) ; st := in_block_comment)
        end
      | post_newline_whitespace() =>
        begin
          case+ c of
            | '\n' => (free(st) ; file_st.blanks := file_st.blanks + 1 ; st := post_newline_whitespace)
            | '#' => (free(st) ; st := line_comment)
            | ';' => (free(st) ; st := line_comment)
            | '/' => (free(st) ; st := post_slash)
            | ' ' => ()
            | '\t' => ()
            | _ => (free(st) ; st := regular)
        end
      | in_block_comment_line_end() =>
        begin
          case+ c of
            | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := in_block_comment)
            | '*' => (free(st) ; st := post_asterisk_in_block_comment_line_end)
            | _ => ()
        end
      | ~post_slash_regular() =>
        begin
          case+ c of
            | '*' => st := in_block_comment_line_end
            | _ => (pr_warning() ; st := regular)
        end
      | post_asterisk_in_block_comment_line_end() =>
        begin
          case+ c of
            | '*' => ()
            | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := in_block_comment)
            | '/' => (free(st) ; st := regular)
            | _ => (free(st) ; st := in_block_comment)
        end
      | ~post_tick() =>
        begin
          case+ c of
            | '\\' => st := post_char_backslash
            | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
            | _ => st := maybe_close_char
        end
      | ~post_char_backslash() =>
        begin
          case+ c of
            | '0' => st := in_char
            | '1' => st := in_char
            | '2' => st := in_char
            | '3' => st := in_char
            | '4' => st := in_char
            | '5' => st := in_char
            | '6' => st := in_char
            | '7' => st := in_char
            | 'X' => st := in_char
            | 'x' => st := in_char
            | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
            | _ => st := maybe_close_char
        end
      | ~maybe_close_char() =>
        begin
          case+ c of
            | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
            | '#' => st := line_comment_regular
            | ';' => st := line_comment_regular
            | '/' => st := post_slash_regular
            | '"' => st := in_string
            | _ => st := regular
        end
      | ~in_char() =>
        begin
          case+ c of
            | '0' => st := in_char
            | '1' => st := in_char
            | '2' => st := in_char
            | '3' => st := in_char
            | '4' => st := in_char
            | '5' => st := in_char
            | '6' => st := in_char
            | '7' => st := in_char
            | '8' => st := in_char
            | '9' => st := in_char
            | _ => st := regular
        end
  end
