let prelude =
      https://hackage.haskell.org/package/ats-pkg/src/dhall/atspkg-prelude.dhall sha256:69bdde38a8cc01c91a1808ca3f45c29fe754c9ac96e91e6abd785508466399b4

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
