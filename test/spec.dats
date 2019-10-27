#include "share/atspre_staload.hats"
#include "share/atspre_staload_libats_ML.hats"
#include "$PATSHOMELOCS/specats-0.4.0/mylibies.hats"
#include "DATS/file.dats"
#include "DATS/pointer.dats"
#include "DATS/lang/common.dats"
#include "DATS/lang/c.dats"
#include "DATS/lang/dhall.dats"
#include "DATS/lang/haskell.dats"
#include "DATS/lang/rust.dats"

fn {a:vt@ype} file_test(expected : file, fp : string) : bool =
  let
    val pre_actual = file$lang<a>(fp)
  in
    case+ pre_actual of
      | ~Some_vt (actual) => actual = expected
      | ~None_vt() => false
  end

fn test_dhall() : bool =
  let
    val expected = @{ lines = 16, blanks = 2, comments = 4, doc_comments = 0 } : file
  in
    file_test<parse_state_dhall>(expected, "test/data/multiline.dhall")
  end

fn test_pkg_set_dhall() : bool =
  let
    val expected = @{ lines = 3874, blanks = 369, comments = 59, doc_comments = 0 } : file
  in
    file_test<parse_state_dhall>(expected, "test/data/pkg-set.dhall")
  end

fn test_c() : bool =
  let
    val expected = @{ lines = 18, blanks = 7, comments = 5, doc_comments = 0 } : file
  in
    file_test<parse_state_c>(expected, "test/data/pathological.c")
  end

fn test_hs() : bool =
  let
    val expected = @{ lines = 7, blanks = 7, comments = 8, doc_comments = 0 } : file
  in
    file_test<parse_state_hs>(expected, "test/data/Pathological.hs")
  end

fn test_setup_hs() : bool =
  let
    val expected = @{ lines = 1877, blanks = 283, comments = 257, doc_comments = 0 } : file
  in
    file_test<parse_state_hs>(expected, "test/data/Setup.hs")
  end

fn test_rs() : bool =
  let
    val expected = @{ lines = 18, blanks = 4, comments = 6, doc_comments = 0 } : file
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
    var xs = n5 :: n4 :: n3 :: n2 :: n1 :: n0 :: nil
    var total = list_vt_length(xs)
    val g = @{ group = "filecount", leaves = xs } : test_tree
    val () = iterate_list(g, 0, total)
  }
