staload "SATS/file.sats"
staload "SATS/lang/j.sats"
staload "SATS/pointer.sats"
staload "SATS/size.sats"

#include "DATS/io.dats"

#define BUFSZ 32768

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

fn count_c_for_loop { l : addr | l != null }{m:nat}{ n : nat | n <= m }( pf : !bytes_v(l, m) | p : ptr(l)
                                                                       , parse_st : &parse_state_j >> _
                                                                       , bufsz : size_t(n)
                                                                       ) : file =
  let
    fn advance_char(c : char, st : &parse_state_j >> _, file_st : &file >> _) : void =
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

fn count_file_j(inp : !FILEptr1) : file =
  let
    val (pfat, pfgc | p) = malloc_gc(g1i2u(BUFSZ))
    prval () = pfat := b0ytes2bytes_v(pfat)
    var init_st: parse_state_j = post_newline_whitespace

    fun loop { l : addr | l != null }(pf : !bytes_v(l, BUFSZ) | inp : !FILEptr1, st : &parse_state_j >> _, p : ptr(l)) :
      file =
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
            var acc = count_c_for_loop(pf | p, st, fb_prf)
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
