let atsCi =
      https://raw.githubusercontent.com/vmchale/github-actions-dhall/master/ats-ci.dhall sha256:d5aac850c2d5d6e6d7eeb2cf46c8b27592e5da17003802d6943b75dc9ec072ed

in    atsCi.atsSteps
        [ atsCi.checkout
        , atsCi.atspkgInstall
        , atsCi.atsBuild (None Text)
        , atsCi.atsTest (None Text)
        ]
    : atsCi.CI.Type
