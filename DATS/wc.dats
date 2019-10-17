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

    var n = $extfcall(size_t(n), "fread", p, sizeof<byte>, bufsize - 1, as_fileref(inp))
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

implement count_buf (pf | ptr, bufsz, st) =
  case+ st of
    | ~in_string (n) => let
      // 34 -> "
      val (pf0, pf1 | p2) = memchr(pf | ptr, 34, bufsz)
    in
      if ptr_is_null(p2) then
        let
          prval () = pf := bytes_v_unsplit(pf0,pf1)
          var strlines = count_lines(pf | ptr, bufsz)
          val () = st := in_string(n + strlines)
        in
          empty_file
        end
      else
        let
          //TODO: check that p2's predecessor is not a backslash
          var pred_is_slash = if p2 > ptr then
            ptr1_pred<byte>(p2) = $UN.cast(92)
          else
            false
          var bytes_taken = sub_ptr1_ptr1_size(p2, ptr)
          var strlines = count_lines(pf0 | ptr, bytes_taken)
          var in_str = strlines + n
          var bytes_remaining = bufsz - bytes_taken
          val () = st := regular()
          var ret_file: file
          val () = ret_file := count_buf(pf1 | p2, bytes_remaining, st)
          val () = ret_file.lines := ret_file.lines + strlines
          prval () = pf := bytes_v_unsplit(pf0,pf1)
        in
          ret_file
        end
    end
    | in_block_comment (_) => empty_file
    | line_comment () => empty_file
    | regular() => let
      val next_char_offset = memchr3(pf | ptr, '\n', '"', '\\', bufsz)
      val ret = case+ next_char_offset of
        | ~Some_vt (char_ptr_off) => let
          var char_ptr = add_ptr_bsz(ptr, char_ptr_off)
          var char_val = $UN.ptr0_get<char>(char_ptr)

          // result of a split points to a non-null view
          extern
          praxi ptr_splat {l0:addr}{m:nat} (!bytes_v(l0, m)) : [l0 != null] void

          var ret_file = case- char_val of
            | '\n' => let
              var bytes_remaining = bufsz - char_ptr_off
              var ret_file: file
              val () = if bytes_remaining > 0 then
                let
                  val next_ptr = bptr_succ(char_ptr)
                  prval (pf0, pf1) = bytes_v_split_at(pf | char_ptr_off + 1)
                  prval () = ptr_splat(pf1)
                  val () = ret_file := count_buf(pf1 | next_ptr, bytes_remaining - 1, st)
                  val () = ret_file.lines := ret_file.lines + 1
                  prval () = pf := bytes_v_unsplit(pf0,pf1)
                in end
              else
                ret_file := empty_file
            in
              ret_file
            end
            | '\\' => empty_file
            | '"' => empty_file
        in
          ret_file
        end
        | ~None_vt() => empty_file
    in
      ret
    end
