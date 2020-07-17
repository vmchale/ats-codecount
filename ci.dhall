let atsCi =
      https://raw.githubusercontent.com/vmchale/github-actions-dhall/master/ats-ci.dhall sha256:525f3b497516a6334caa03ed853dc12f3b5f7c46e4cc5f052101cc611e988f28

in    atsCi.atsSteps
        [ atsCi.checkout
        , atsCi.atspkgInstall
        , atsCi.atsBuild (None Text)
        , atsCi.atsTest (None Text)
        ]
    : atsCi.CI.Type
