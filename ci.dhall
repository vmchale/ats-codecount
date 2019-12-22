let atsCi =
      https://raw.githubusercontent.com/vmchale/github-actions-dhall/master/ats-ci.dhall sha256:9a34a7225b84d74ebddeee6cda8f1adc572a4947911cfbe44f12683667975cff

in    atsCi.atsSteps
        [ atsCi.checkout
        , atsCi.atspkgInstall
        , atsCi.atsBuild (None Text)
        , atsCi.atsTest (None Text)
        ]
    : atsCi.CI.Type
