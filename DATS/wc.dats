staload "SATS/wc.sats"
staload "SATS/memchr.sats"
staload "SATS/bytecount.sats"
staload "prelude/SATS/pointer.sats"
staload UN = "prelude/SATS/unsafe.sats"

#include "DATS/bytecount.dats"
#include "DATS/memchr.dats"

%{
size_t sub_ptr1_ptr1_size(atstype_ptr p1, atstype_ptr p2) {
  return ((char *)p1 - (char *)p2);
}
%}

extern
fn sub_ptr1_ptr1_size { l0, l1 : addr | l0 >= l1 }(p1 : ptr(l0), p2 : ptr(l1)) :<> size_t(l0-l1) =
  "ext#"

fn bptr_succ {l:addr}(p : ptr(l)) :<> ptr(l+1) =
  $UN.cast(ptr1_succ<byte>(p))

fn freadc_ {l:addr}{ sz : nat | sz > 0 }{ n : nat | n <= sz }(pf : !bytes_v(l, sz)
                                                             | inp : !FILEptr1, bufsize : size_t(sz), p : ptr(l)) :
  size_t(n) =
  let
    extern
    castfn as_fileref(x : !FILEptr1) :<> FILEref

    var n = $extfcall(size_t(n), "fread", p, sizeof<byte>, bufsize, as_fileref(inp))
  in
    n
  end

implement empty_file =
  @{ lines = 0, blanks = 0, comments = 0, doc_comments = 0 } : file

implement free_st (st) =
  case+ st of
    | ~in_string (_) => ()
    | ~in_block_comment (_) => ()
    | ~line_comment() => ()
    | ~regular() => ()

fn byteview_read {l0:addr}{m:nat}{ l1 : addr | l1 <= l0+m }(pf : !bytes_v(l0, m) | p : ptr(l1)) : char =
  $UN.ptr0_get<char>(p)

implement count_lines_naive {l:addr}{m:int} (pf | ptr, bufsz : size_t(m)) =
  let
    var res: int = 0
    var i: size_t
    val () = for* { i : nat | i <= m } .<i>. (i : size_t(i)) =>
        (i := bufsz ; i != 0 ; i := i - 1)
        (let
          val current_char = byteview_read(pf | add_ptr_bsz(ptr, i))
        in
          case+ current_char of
            | '\n' => res := res + 1
            | _ => ()
        end)
  in
    $UN.cast(res)
  end

implement count_lines_memchr (pf | ptr, bufsz) =
  let
    val (pf0, pf1 | next_ptr) = memchr(pf | ptr, 34, bufsz)
  in
    if ptr_is_null(next_ptr) then
      let
        prval () = pf := bytes_v_unsplit(pf0,pf1)
      in
        0
      end
    else
      let
        var bytes_taken = sub_ptr1_ptr1_size(next_ptr, ptr)
        var bytes_remaining = bufsz - bytes_taken
      in
        if bytes_remaining > 0 then
          let
            extern
            praxi splittable {l:addr}{m:nat}{n:nat} (!bytes_v(l, m) | size_t(n)) : [n <= m] void

            extern
            praxi eq_sz { l0, l1 : addr }{m:nat} (!bytes_v(l0, m) | ptr(l1)) : [l0 == l1] void

            var succ_ptr = bptr_succ(next_ptr)
            var b_at = bytes_taken + 1
            prval () = splittable(pf1 | b_at)
            prval (pf2, pf3) = bytes_v_split_at(pf1 | b_at)
            prval () = eq_sz(pf2 | succ_ptr)
            var intermed = 1 + count_lines_memchr(pf2 | succ_ptr, bytes_remaining)
            prval () = pf1 := bytes_v_unsplit(pf2,pf3)
            prval () = pf := bytes_v_unsplit(pf0,pf1)
          in
            intermed
          end
        else
          let
            prval () = pf := bytes_v_unsplit(pf0,pf1)
          in
            0
          end
      end
  end
