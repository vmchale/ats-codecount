#define BUFSZ 32768

staload UN = "prelude/SATS/unsafe.sats"

// bad (?) idea: use rawmemchr + append lol
extern
fn memchr {l:addr}{m:nat}(pf : bytes_v(l, m) | p : ptr(l), c : int, size_t) : [l0:addr] ( bytes_v(l, l0-l)
                                                                                        , bytes_v(l0, l+m-l0)
                                                                                        | ptr(l0)) =
  "mac#"

extern
fn count_lines {l:addr}{m:nat}(!bytes_v(l, m) | ptr(l), bufsz : size_t) : size_t =
  "ext#"

implement empty_file =
  @{ lines = 0, blanks = 0, comments = 0, doc_comments = 0 } : file

implement count_buf (pf | ptr, st) =
  case+ st of
    | ~in_string (n) => let
      // fromEnum '"' = 34
      val (pf0, pf1 | p2) = memchr(pf | ptr, 34, $UN.cast(BUFSZ))
      val () = if ptr_is_null(ptr) then
        {
          prval () = pf := bytes_v_unsplit(pf0,pf1)
          val strlines = count_lines(pf | ptr, $UN.cast(BUFSZ))
          val () = st := in_string(n + 0)
        }
      else
        {
          // TODO: don't do this; loop?
          prval () = pf := bytes_v_unsplit(pf0,pf1)
          val () = st := regular()
        }
    in
      empty_file
    end
    | in_block_comment (_) => empty_file
    | line_comment (_) => empty_file
    | regular() => empty_file
