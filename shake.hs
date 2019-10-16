#!/usr/bin/env cabal
{- cabal:
build-depends: base, shake
default-language: Haskell2010
ghc-options: -Wall -threaded -rtsopts "-with-rtsopts=-I0 -qg -qb"
-}

import Development.Shake hiding ((*>))

main :: IO ()
main = shakeArgs shakeOptions { shakeFiles = ".shake", shakeLint = Just LintBasic, shakeChange = ChangeModtimeAndDigestInput } $ do
    want [ "target/wc-bench" ]

    "clean" ~> do
        unit $ cmd $ [ "rm", "-rf", "tags", "bytecount/rusty-tags.vi" ]
        removeFilesAfter "target" ["//*"]
        removeFilesAfter "bytecount/target" ["//*"]
        removeFilesAfter ".shake" ["//*"]
        removeFilesAfter ".atspkg" ["//*"]

    "bytecount/target/release/libbytecount_ffi.so" %> \_ ->
        need ["bytecount/src/lib.rs", "bytecount/Cargo.toml"] *>
        command [Cwd "bytecount"] "cargo" ["build", "--release"]

    "target/wc-bench" %> \out -> do
        need ["bytecount/target/release/libbytecount_ffi.so", "atspkg.dhall", "test/wc-bench.dats", "SATS/wc.sats", "DATS/wc.dats"]
        command [] "atspkg" ["build", out]

    "bench" ~> do
        need ["target/wc-bench"]
        command [AddEnv "LD_LIBRARY_PATH" "./bytecount/target/release"] "./target/wc-bench" []
