staload "libats/ML/SATS/string.sats"
staload "SATS/file.sats"
staload "SATS/pointer.sats"
staload "SATS/size.sats"
staload "SATS/lang/haskell.sats"

#include "DATS/io.dats"

#define BUFSZ 32768

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
    | in_block_comment_first_line (i) => "in_block_comment_first_line(" + tostring_int(i) + ")"
    | post_hyphen() => "post_hyphen"
    | post_hyphen_regular() => "post_hyphen_regular"
    | post_lbrace_in_block_comment (i) => "post_lbrace_in_block_comment(" + tostring_int(i) + ")"
    | post_lbrace_in_block_comment_first_line (i) => "post_lbrace_in_block_comment_first_line(" + tostring_int(i) + ")"

fn count_hs_for_loop { l : addr | l != null }{m:nat}{ n : nat | n <= m }( pf : !bytes_v(l, m) | p : ptr(l)
                                                                        , parse_st : &parse_state_hs >> _
                                                                        , bufsz : size_t(n)
                                                                        ) : file =
  let
    // TODO: generate or at least validate these functions
    fn advance_char(c : char, st : &parse_state_hs >> _, file_st : &file >> _) : void =
      case- st of
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
              | _ => ()
          end
        | post_lbrace_regular() =>
          begin
            case+ c of
              | '-' => (free(st) ; st := in_block_comment_first_line(1))
              | '\n' => (free(st) ; file_st.lines := file_st.lines + 1 ; st := post_newline_whitespace)
              | _ => ()
          end
        | post_backslash_in_string() =>
          begin
            case+ c of
              | '\n' => file_st.lines := file_st.lines + 1
              | _ => (free(st) ; st := in_string)
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

    var res: file = empty_file
    var i: size_t
    val () = for* { i : nat | i <= n } .<n-i>. (i : size_t(i)) =>
        (i := i2sz(0) ; i < bufsz ; i := i + 1)
        (let
          var current_char = byteview_read_as_char(pf | add_ptr_bsz(p, i))
        in
          advance_char(current_char, parse_st, res)
        end)
  in
    res
  end

fn count_file_hs(inp : !FILEptr1) : file =
  let
    val (pfat, pfgc | p) = malloc_gc(g1i2u(BUFSZ))
    prval () = pfat := b0ytes2bytes_v(pfat)
    var init_st: parse_state_hs = post_newline_whitespace

    fun loop { l : addr | l != null }(pf : !bytes_v(l, BUFSZ) | inp : !FILEptr1, st : &parse_state_hs >> _, p : ptr(l))
      : file =
      let
        var file_bytes = freadc(pf | inp, i2sz(BUFSZ), p)

        extern
        praxi lt_bufsz {m:nat} (size_t(m)) : [m <= BUFSZ] void
      in
        if file_bytes = 0 then
          empty_file
        else
          let
            var fb_prf = bounded(file_bytes)
            prval () = lt_bufsz(fb_prf)
            var acc = count_hs_for_loop(pf | p, st, fb_prf)
          in
            acc + loop(pf | inp, st, p)
          end
      end

    var ret = loop(pfat | inp, init_st, p)
    val () = free(init_st)
    val () = mfree_gc(pfat, pfgc | p)
  in
    ret
  end
