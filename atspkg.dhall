let prelude =
      https://hackage.haskell.org/package/ats-pkg/src/dhall/atspkg-prelude.dhall sha256:c04fe26a86f2e2bd5c67c17f213ee30379d520f5fad11254a8f17e936250e27e

in  prelude.compilerMod
      prelude.gcc
      (   prelude.default
        ⫽ { bench =
            [   prelude.bin
              ⫽ { src = "bench/wc-bench.dats"
                , target = "${prelude.atsProject}/wc-bench"
                , gcBin = True
                }
            ]
          , test =
            [   prelude.bin
              ⫽ { src = "test/spec.dats"
                , target = "${prelude.atsProject}/spec"
                , gcBin = True
                }
            ]
          , bin =
            [   prelude.bin
              ⫽ { src = "src/wc-demo.dats"
                , target = "${prelude.atsProject}/wc-demo"
                }
            ]
          , dependencies = prelude.mapPlainDeps [ "ats-bench", "specats" ]
          , compiler = [ 0, 4, 2 ]
          , version = [ 0, 4, 2 ]
          , atsLib = False
          }
      )
