let prelude = https://hackage.haskell.org/package/ats-pkg/src/dhall/atspkg-prelude.dhall

in prelude.default ⫽
  { test =
    [ prelude.bin ⫽
      { src = "test/wc-bench.dats"
      , target = "${prelude.atsProject}/wc-bench"
      , gcBin = True
      }
    ]
  , bin =
    [ prelude.bin ⫽
      { src = "src/wc-demo.dats"
      , target = "${prelude.atsProject}/wc-demo"
      }
    ]
  , dependencies = prelude.mapPlainDeps [ "ats-bench" ]
  , cflags = [ "-O2", "-flto" ]
  }
