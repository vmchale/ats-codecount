let tomlCi =
      https://raw.githubusercontent.com/vmchale/github-actions-dhall/master/toml-ci.dhall sha256:7798f59809cbce8a287e475ecf996dee26b6ed234a27fb411e595604a578fbf4

in  tomlCi.tomlCi [ ".atsfmt.toml", "bytecount/Cargo.toml" ]
