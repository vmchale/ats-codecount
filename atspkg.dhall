let prelude = https://hackage.haskell.org/package/ats-pkg/src/dhall/atspkg-prelude.dhall sha256:33e41e509b6cfd0b075d1a8a5210ddfd1919372f9d972c2da783c6187d2298ba

in prelude.default ⫽
  { bench =
    [ prelude.bin ⫽
      { src = "bench/wc-bench.dats"
      , target = "${prelude.atsProject}/wc-bench"
      , gcBin = True
      }
    ]
  , test =
    [ prelude.bin ⫽
      { src = "test/spec.dats"
      , target = "${prelude.atsProject}/spec"
      , gcBin = True
      }
    ]
  , bin =
    [ prelude.bin ⫽
      { src = "src/wc-demo.dats"
      , target = "${prelude.atsProject}/wc-demo"
      }
    ]
  , dependencies = prelude.mapPlainDeps [ "ats-bench", "specats" ]
  , cflags = [ "-O2", "-flto" ]
  , atsLib = False
  }
