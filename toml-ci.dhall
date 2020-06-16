let tomlCi =
      https://raw.githubusercontent.com/vmchale/github-actions-dhall/master/toml-ci.dhall sha256:e7712236b2eaab2e8916ebd0ef36c314a79a3d0fede89981ffaa92a5feac81cb

in  tomlCi.tomlCi [ ".atsfmt.toml", "bytecount/Cargo.toml" ]
