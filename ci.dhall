let atsCi =
      https://raw.githubusercontent.com/vmchale/github-actions-dhall/master/ats-ci.dhall sha256:208edfab1ddd9473b96787f3226c84b551c9b0f9a79422c79c4b7afb52f933d5

in    atsCi.atsSteps
        [ atsCi.checkout
        , atsCi.atspkgInstall
        , atsCi.atsBuild (None Text)
        , atsCi.atsTest (None Text)
        ]
    : atsCi.CI.Type
