staload "libats/ML/SATS/string.sats"
staload "SATS/file.sats"
staload "SATS/lang/rust.sats"
staload "SATS/lang/common.sats"

implement free_st_rs (st) =
  case+ st of
    | ~line_comment() => ()
    | ~regular() => ()
    | ~post_newline_whitespace() => ()
    | ~line_comment_regular() => ()
    | ~post_slash() => ()
    | ~post_slash_regular() => ()
    | ~in_string() => ()
    | ~post_backslash_in_string() => ()
    | ~post_r() => ()
    | ~post_r_hash (_) => ()
    | ~in_raw_string (_) => ()
    | ~maybe_close_hash (_, _) => ()
    | ~in_block_comment (_) => ()
    | ~in_block_comment_first_line (_) => ()
    | ~post_slash_in_block_comment (_) => ()
    | ~post_slash_in_block_comment_first_line (_) => ()
    | ~post_asterisk_in_block_comment (_) => ()
    | ~post_asterisk_in_block_comment_first_line (_) => ()
    | ~post_tick() => ()
    | ~maybe_close_char() => ()
    | ~in_char() => ()
    | ~post_block_comment() => ()
    | ~post_backslash_after_tick() => ()

implement parse_state_rs_tostring (st) =
  case+ st of
    | regular() => "regular"
    | line_comment() => "line_comment"
    | line_comment_regular() => "line_comment_regular"
    | post_newline_whitespace() => "post_newline_whitespace"
    | post_slash() => "post_slash_regular"
    | in_string() => "in_string"
    | post_backslash_in_string() => "post_backslash_in_string"
    | post_r() => "post_r"
    | post_slash_regular() => "post_slash_regular"
    | post_r_hash (i) => "post_r_hash(" + tostring_int(i) + ")"
    | in_raw_string (i) => "in_raw_string(" + tostring_int(i) + ")"
    | maybe_close_hash (i, j) => "maybe_close_hash(" + tostring_int(i) + ", " + tostring_int(j) + ")"
    | in_block_comment (i) => "in_block_comment(" + tostring_int(i) + ")"
    | in_block_comment_first_line (i) => "in_block_comment_first_line(" + tostring_int(i) + ")"
    | post_slash_in_block_comment (i) => "post_slash_in_block_comment(" + tostring_int(i) + ")"
    | post_slash_in_block_comment_first_line (i) => "post_slash_in_block_comment_first_line(" + tostring_int(i) + ")"
    | post_asterisk_in_block_comment (i) => "post_asterisk_in_block_comment(" + tostring_int(i) + ")"
    | post_asterisk_in_block_comment_first_line (i) => "post_asterisk_in_block_comment_first_line(" + tostring_int(i) + ")"
    | post_tick() => "post_tick"
    | maybe_close_char() => "maybe_close_char"
    | in_char() => "in_char"
    | post_block_comment() => "post_block_comment"
    | post_backslash_after_tick() => "post_backslash_after_tick"

implement free$lang<parse_state_rs> (st) =
  free_st_rs(st)

implement init$lang<parse_state_rs> (st) =
  st := post_newline_whitespace

implement advance_char$lang<parse_state_rs> (c, st, file_st) =
  let
    fn pr_warning() : void =
      prerr!("\33[33mWarning:\33[0m inconsistent state in Rust lexer.\n")
  in
    case+ st of
      | regular() => 
        begin
          case+ c of
            | '\'' => (free(st) ; st := post_tick)
            | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
            | '"' => (free(st) ; st := in_string)
            | '/' => (free(st) ; st := post_slash_regular)
            | 'r' => (free(st) ; st := post_r)
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
      | post_r() => 
        begin
          case+ c of
            | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
            | '#' => (free(st) ; st := post_r_hash(1))
            | '"' => (free(st) ; st := in_string)
            | '\'' => (free(st) ; st := post_tick)
            | _ => ()
        end
      | in_string() => 
        begin
          case+ c of
            | '\\' => (free(st) ; st := post_backslash_in_string)
            | '\n' => file_st.lines := file_st.lines + 1
            | '"' => (free(st) ; st := regular)
            | _ => ()
        end
      | ~post_slash() => 
        begin
          case+ c of
            | '/' => st := line_comment
            | '*' => st := in_block_comment(1)
            | '\'' => st := post_tick
            | 'r' => st := post_r
            | '"' => st := in_string
            | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
            | _ => st := regular
        end
      | ~post_slash_regular() => 
        begin
          case+ c of
            | '/' => st := line_comment_regular
            | '*' => st := in_block_comment_first_line(1)
            | '\'' => st := post_tick
            | 'r' => st := post_r
            | '"' => st := in_string
            | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
            | _ => st := regular
        end
      | ~post_backslash_in_string() => 
        begin
          case+ c of
            | '\n' => (file_st.lines := file_st.lines + 1 ; st := in_string)
            | _ => st := in_string
        end
      | ~post_r_hash (i) => 
        begin
          case+ c of
            | '#' => st := post_r_hash(i + 1)
            | '"' => st := in_raw_string(i)
            | _ => (pr_warning() ; st := regular)
        end
      | in_raw_string (i) => 
        begin
          case+ c of
            | '"' => (free(st) ; st := maybe_close_hash(i, 0))
            | '\n' => file_st.lines := file_st.lines + 1
            | _ => ()
        end
      | ~maybe_close_hash (i, j) => 
        begin
          case+ c of
            | '#' when i = j + 1 => st := regular
            | '#' => st := maybe_close_hash(i, j + 1)
            | '\n' => (file_st.lines := file_st.lines + 1 ; st := in_raw_string(i))
            | _ => st := in_raw_string(i)
        end
      | in_block_comment (i) => 
        begin
          case+ c of
            | '\n' => file_st.comments := file_st.comments + 1
            | '/' => (free(st) ; st := post_slash_in_block_comment(i))
            | _ => ()
        end
      | in_block_comment_first_line (i) => 
        begin
          case+ c of
            | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := in_block_comment(i))
            | '/' => (free(st) ; st := post_slash_in_block_comment_first_line(i))
            | _ => ()
        end
      | post_slash_in_block_comment (i) => 
        begin
          case+ c of
            | '\n' => file_st.comments := file_st.comments + 1
            | '*' => (free(st) ; st := in_block_comment(i + 1))
            | '/' => ()
            | _ => (free(st) ; st := in_block_comment(i))
        end
      | post_slash_in_block_comment_first_line (i) => 
        begin
          case+ c of
            | '\n' => file_st.lines := file_st.lines + 1
            | '*' => (free(st) ; st := in_block_comment_first_line(i + 1))
            | '/' => ()
            | _ => (free(st) ; st := in_block_comment_first_line(i))
        end
      | post_asterisk_in_block_comment (i) => 
        begin
          case+ c of
            | '/' when i - 1 = 0 => (free(st) ; st := regular)
            | '/' => (free(st) ; st := post_asterisk_in_block_comment(i - 1))
            | '*' => ()
            | '\n' => (free(st) ; file_st.comments := file_st.comments + 1 ; st := in_block_comment(i))
            | _ => ()
        end
      | post_asterisk_in_block_comment_first_line (i) => 
        begin
          case+ c of
            | '/' when i - 1 = 0 => (free(st) ; st := regular)
            | '/' => (free(st) ; st := post_asterisk_in_block_comment_first_line(i - 1))
            | '*' => ()
            | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := in_block_comment(i))
            | _ => ()
        end
      | post_newline_whitespace() => 
        begin
          case+ c of
            | '\'' => (free(st) ; st := post_tick)
            | '\n' => (free(st) ; file_st.blanks := file_st.blanks + 1 ; st := post_newline_whitespace)
            | '"' => (free(st) ; st := in_string)
            | '/' => (free(st) ; st := post_slash)
            | 'r' => (free(st) ; st := post_r)
            | ' ' => ()
            | '\t' => ()
            | _ => (free(st) ; st := regular)
        end
      | ~post_tick() => 
        begin
          case+ c of
            | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
            | '\\' => st := post_backslash_after_tick
            | _ => st := maybe_close_char
        end
      | ~post_backslash_after_tick() => st := in_char
      | in_char() => 
        begin
          case+ c of
            | '\'' => (free(st) ; st := regular)
            | _ => ()
        end
      | ~maybe_close_char() => 
        begin
          case+ c of
            | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
            | '"' => st := in_string
            | '/' => st := post_slash
            | 'r' => st := post_r
            | _ => st := regular
        end
      | post_block_comment() => 
        begin
          case+ c of
            | '\n' => (free(st) ; file_st.comments := file_st.comments + 1 ; st := post_newline_whitespace)
            | '\t' => ()
            | ' ' => ()
            | '\'' => (free(st) ; st := post_tick)
            | '"' => (free(st) ; st := in_string)
            | '/' => (free(st) ; st := post_slash)
            | _ => (free(st) ; st := regular)
        end
  end
