let atsCi =
        https://raw.githubusercontent.com/vmchale/github-actions-dhall/master/ats-ci.dhall sha256:d9fd2fb2228bc3471a652c296a93c0156c56172059309bfef4ff26c396dfa4aa
      ? https://raw.githubusercontent.com/vmchale/github-actions-dhall/master/ats-ci.dhall

in    atsCi.atsSteps
        [ atsCi.checkout
        , atsCi.atspkgInstall
        , atsCi.atsBuild (None Text)
        , atsCi.atsTest (None Text)
        ]
    : atsCi.CI.Type
