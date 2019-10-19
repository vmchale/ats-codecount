#!/usr/bin/env cabal
{- cabal:
build-depends: base, shake, shake-ats >= 1.10.2.3
default-language: Haskell2010
ghc-options: -Wall -threaded -rtsopts "-with-rtsopts=-I0 -qg -qb"
-}

import           Development.Shake     hiding ((*>))
import           Development.Shake.ATS

main :: IO ()
main = shakeArgs shakeOptions { shakeFiles = ".shake", shakeLint = Just LintBasic, shakeChange = ChangeModtimeAndDigestInput } $ do
    want [ "target/wc-bench", "target/wc-demo" ]

    "clean" ~> do
        unit $ cmd $ [ "rm", "-rf", "tags", "bytecount/rusty-tags.vi" ]
        cleanATS
        removeFilesAfter "target" ["//*"]
        removeFilesAfter "bytecount/target" ["//*"]
        removeFilesAfter ".shake" ["//*"]

    "bytecount/target/release/libbytecount_ffi.so" %> \_ ->
        need ["bytecount/src/lib.rs", "bytecount/Cargo.toml", "bytecount/Cargo.lock"] *>
        command [Cwd "bytecount", AddEnv "RUSTFLAGS" "-C target-cpu=native"] "cargo" ["build", "--release"]

    ["target/wc-bench", "target/wc-demo"] &%> \[out1, out2] -> do
        need ["atspkg.dhall", "test/wc-bench.dats", "SATS/wc.sats", "DATS/wc.dats"]
        command [] "atspkg" ["build", out1, out2]

    "bench" ~> do
        need ["target/wc-bench"]
        unit $ command [Cwd "bytecount", AddEnv "RUSTFLAGS" "-C target-cpu=native"] "cargo" ["bench"]
        command [AddEnv "LD_LIBRARY_PATH" "./bytecount/target/release"] "./target/wc-bench" []
