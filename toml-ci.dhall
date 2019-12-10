let tomlCi =
      https://raw.githubusercontent.com/vmchale/github-actions-dhall/master/toml-ci.dhall

in  tomlCi.tomlCi [ ".atsfmt.toml", "bytecount/Cargo.toml" ]
