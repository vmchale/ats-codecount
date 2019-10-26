#include "share/atspre_staload.hats"
#include "share/atspre_staload_libats_ML.hats"
#include "$PATSHOMELOCS/specats-0.4.0/mylibies.hats"
#include "DATS/file.dats"
#include "DATS/pointer.dats"
#include "DATS/lang/common.dats"
#include "DATS/lang/dhall.dats"

fn test_dhall() : bool =
  let
    val expected = @{ lines = 16, blanks = 2, comments = 4, doc_comments = 0 } : file
    val pre_actual = file$lang<parse_state_dhall>("test/data/multiline.dhall")
  in
    case+ pre_actual of
      | ~Some_vt (actual) => actual = expected
      | ~None_vt() => false
  end

implement main0 () =
  {
    var n0 = @{ test_name = "dhall", test_result = test_dhall() }
    var xs = n0 :: nil
    var total = list_vt_length(xs)
    val g = @{ group = "filecount", leaves = xs } : test_tree
    val () = iterate_list(g, 0, total)
  }
