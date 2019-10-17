#define MAX_SIZE 18446744073709551615

staload "SATS/memchr.sats"

implement memchr2 (pf | p, c0, c1, bufsz) =
  let
    var res = memchr2_rs(pf | p, c0, c1, bufsz)
  in
    if res = MAX_SIZE then
      None_vt
    else
      Some_vt(res)
  end

implement memchr3 (pf | p, c0, c1, c2, bufsz) =
  let
    var res = memchr3_rs(pf | p, c0, c1, c2, bufsz)
  in
    if res = MAX_SIZE then
      None_vt
    else
      Some_vt(res)
  end
