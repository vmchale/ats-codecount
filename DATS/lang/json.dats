staload "SATS/file.sats"
staload "SATS/lang/json.sats"
staload "SATS/lang/common.sats"

implement free_st_json (st) =
  case+ st of
    | ~regular() => ()
    | ~post_newline_whitespace() => ()

implement parse_state_json_tostring (st) =
  case+ st of
    | regular() => "regular"
    | post_newline_whitespace() => "post_newline_whitespace"

implement free$lang<parse_state_json> (st) =
  free_st_json(st)

implement init$lang<parse_state_json> (st) =
  st := post_newline_whitespace

implement advance_char$lang<parse_state_json> (c, st, file_st) =
  case+ st of
    | regular() => 
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
          | _ => (free(st) ; st := regular)
      end
