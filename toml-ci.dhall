let tomlCi =
      https://raw.githubusercontent.com/vmchale/github-actions-dhall/master/toml-ci.dhall sha256:a0500ac365974199b7cd6864d6401609eddab2d10596c123ef890dd5b5dd188a

in  tomlCi.tomlCi [ ".atsfmt.toml", "bytecount/Cargo.toml" ]
