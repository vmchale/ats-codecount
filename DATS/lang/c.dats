staload "SATS/lang/common.sats"
staload "SATS/lang/c.sats"

#include "DATS/lang/common.dats"

implement free_st_c (st) =
  case+ st of
    | ~in_string () => ()
    | ~in_block_comment () => ()
    | ~line_comment() => ()
    | ~line_comment_end() => ()
    | ~post_asterisk_in_block_comment() => ()
    | ~post_backslash_in_string() => ()
    | ~post_slash() => ()
    | ~post_slash_regular() => ()
    | ~regular() => ()
    | ~post_newline_whitespace() => ()
    | ~post_block_comment() => ()
    | ~post_tick() => ()
    | ~in_block_comment_first_line() => ()
    | ~post_asterisk_in_block_comment_first_line() => ()

implement parse_state_c_tostring (st) =
  case+ st of
    | regular() => "regular"
    | in_block_comment() => "in_block_comment"
    | in_string() => "in_string"
    | post_slash() => "post_slash"
    | post_backslash_in_string() => "post_backslash_is_string"
    | line_comment() => "line_comment"
    | post_asterisk_in_block_comment() => "post_asterisk_in_block_comment"
    | post_newline_whitespace() => "post_newline_whitespace"
    | post_block_comment() => "post_block_comment"
    | post_tick() => "post_tick"
    | in_block_comment_first_line() => "in_block_comment_first_line"
    | line_comment_end() => "line_comment_end"
    | post_slash_regular() => "post_slash_regular"
    | post_asterisk_in_block_comment_first_line() => "post_asterisk_in_block_comment_first_line"

implement free$lang<parse_state_c> (st) =
  free_st_c(st)

implement advance_char$lang<parse_state_c> (c, st, file_st) =
  case+ st of
    | regular() =>
      begin
        case+ c of
          | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | '\'' => (free(st) ; st := post_tick)
          | '"' => (free(st) ; st := in_string)
          | '/' => (free(st) ; st := post_slash_regular)
          | _ => ()
      end
    | in_string() =>
      begin
        case+ c of
          | '\n' => file_st.lines := file_st.lines + 1
          | '\\' => (free(st) ; st := post_backslash_in_string)
          | '"' => (free(st) ; st := regular)
          | _ => ()
      end
    | post_asterisk_in_block_comment() =>
      begin
        case+ c of
          | '/' => (free(st) ; st := post_block_comment)
          | '\n' => (free(st) ; file_st.comments := file_st.comments + 1 ; st := in_block_comment)
          | '*' => ()
          | _ => (free(st) ; st := in_block_comment)
      end
    | post_asterisk_in_block_comment_first_line() =>
      begin
        case+ c of
          | '/' => (free(st) ; st := regular)
          | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := in_block_comment)
          | '*' => ()
          | _ => (free(st) ; st := in_block_comment_first_line)
      end
    | in_block_comment() =>
      begin
        case+ c of
          | '*' => (free(st) ; st := post_asterisk_in_block_comment)
          | '\n' => file_st.comments := file_st.comments + 1
          | _ => ()
      end
    | in_block_comment_first_line() =>
      begin
        case+ c of
          | '*' => (free(st) ; st := post_asterisk_in_block_comment_first_line)
          | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := in_block_comment)
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
    | ~post_backslash_in_string() =>
      begin
        case+ c of
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := in_string)
          | _ => (st := in_string)
      end
    | ~post_slash() =>
      begin
        case+ c of
          | '/' => st := line_comment
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | '*' => st := in_block_comment
          | '\'' => st := post_tick
          | '"' => st := in_string
          | _ => st := regular
      end
    | ~post_slash_regular() =>
      begin
        case+ c of
          | '/' => st := line_comment_end
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | '*' => st := in_block_comment_first_line
          | '\'' => st := post_tick
          | '"' => st := in_string
          | _ => st := regular
      end
    | post_newline_whitespace() =>
      begin
        case+ c of
          | '\n' => (file_st.blanks := file_st.blanks + 1)
          | '\t' => ()
          | ' ' => ()
          | '/' => (free(st) ; st := post_slash)
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
          | '/' => (free(st) ; st := post_slash)
          | '"' => (free(st) ; st := in_string)
          | '\'' => (free(st) ; st := post_tick)
          | _ => (free(st) ; st := regular)
      end
    | ~post_tick() =>
      begin
        case+ c of
          | '\n' => (file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
          | _ => st := regular
      end

implement init$lang<parse_state_c> (st) =
  st := post_newline_whitespace

fn count_file_c(inp : !FILEptr1) : file =
  count_file<parse_state_c>(inp)
