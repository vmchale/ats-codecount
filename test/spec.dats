#include "share/atspre_staload.hats"
#include "share/atspre_staload_libats_ML.hats"
#include "$PATSHOMELOCS/specats-0.4.0/mylibies.hats"
#include "DATS/file.dats"
#include "DATS/pointer.dats"
#include "DATS/lang/common.dats"
#include "DATS/lang/assembly.dats"
#include "DATS/lang/c.dats"
#include "DATS/lang/dhall.dats"
#include "DATS/lang/haskell.dats"
#include "DATS/lang/idris.dats"
#include "DATS/lang/python.dats"
#include "DATS/lang/rust.dats"

fn {a:vt@ype} file_test(expected : file, fp : string) : bool =
  let
    var pre_actual = file$lang<a>(fp)
  in
    case+ pre_actual of
      | ~Some_vt (actual) => actual = expected
      | ~None_vt() => false
  end

fn test_ctx() : bool =
  let
    var expected = @{ lines = 1612, blanks = 213, comments = 161, doc_comments = 0 } : file
  in
    file_test<parse_state_idr>(expected, "test/data/Context.idr")
  end

fn test_idr() : bool =
  let
    var expected = @{ lines = 15, blanks = 7, comments = 3, doc_comments = 1 } : file
  in
    file_test<parse_state_idr>(expected, "test/data/Pathological.idr")
  end

fn test_py() : bool =
  let
    var expected = @{ lines = 16, blanks = 3, comments = 1, doc_comments = 0 } : file
  in
    file_test<parse_state_py>(expected, "test/data/pathological.py")
  end

fn test_asm() : bool =
  let
    var expected = @{ lines = 22, blanks = 10, comments = 5, doc_comments = 0 } : file
  in
    file_test<parse_state_as>(expected, "test/data/pathological.S")
  end

fn test_instr() : bool =
  let
    var expected = @{ lines = 957, blanks = 53, comments = 225, doc_comments = 0 } : file
  in
    file_test<parse_state_as>(expected, "test/data/instr.asm")
  end

fn test_dhall() : bool =
  let
    var expected = @{ lines = 16, blanks = 2, comments = 4, doc_comments = 0 } : file
  in
    file_test<parse_state_dhall>(expected, "test/data/multiline.dhall")
  end

fn test_pkg_set_dhall() : bool =
  let
    var expected = @{ lines = 3874, blanks = 369, comments = 59, doc_comments = 0 } : file
  in
    file_test<parse_state_dhall>(expected, "bench/data/pkg-set.dhall")
  end

fn test_c() : bool =
  let
    var expected = @{ lines = 18, blanks = 7, comments = 5, doc_comments = 0 } : file
  in
    file_test<parse_state_c>(expected, "test/data/pathological.c")
  end

fn test_hs() : bool =
  let
    var expected = @{ lines = 7, blanks = 7, comments = 8, doc_comments = 0 } : file
  in
    file_test<parse_state_hs>(expected, "test/data/Pathological.hs")
  end

fn test_setup_hs() : bool =
  let
    var expected = @{ lines = 1877, blanks = 283, comments = 257, doc_comments = 0 } : file
  in
    file_test<parse_state_hs>(expected, "test/data/Setup.hs")
  end

fn test_rs() : bool =
  let
    var expected = @{ lines = 18, blanks = 4, comments = 6, doc_comments = 0 } : file
  in
    file_test<parse_state_rs>(expected, "test/data/pathological.rs")
  end

implement main0 () =
  {
    var n0 = @{ test_name = "dhall", test_result = test_dhall() }
    var n1 = @{ test_name = "c", test_result = test_c() }
    var n2 = @{ test_name = "haskell", test_result = test_hs() }
    var n3 = @{ test_name = "setup_hs", test_result = test_setup_hs() }
    var n4 = @{ test_name = "pkg_set_dhall", test_result = test_pkg_set_dhall() }
    var n5 = @{ test_name = "rust", test_result = test_rs() }
    var n6 = @{ test_name = "asm", test_result = test_asm() }
    var n7 = @{ test_name = "instr_asm", test_result = test_instr() }
    var n8 = @{ test_name = "context_idr", test_result = test_ctx() }
    var n9 = @{ test_name = "idris", test_result = test_idr() }
    var xs = n9 :: n8 :: n7 :: n6 :: n5 :: n4 :: n3 :: n2 :: n1 :: n0 :: nil
    var total = list_vt_length(xs)
    val g = @{ group = "filecount", leaves = xs } : test_tree
    val () = iterate_list(g, 0, total)
  }
