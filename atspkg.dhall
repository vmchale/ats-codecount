let prelude = https://hackage.haskell.org/package/ats-pkg/src/dhall/atspkg-prelude.dhall

in prelude.default ⫽
  { test =
    [ prelude.bin ⫽
      { src = "test/wc-bench.dats"
      , target = "${prelude.atsProject}/wc-bench"
      , gcBin = True
      }
    ]
  , dependencies = prelude.mapPlainDeps [ "ats-bench" ]
  }
