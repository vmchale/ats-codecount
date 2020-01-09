let dhallCi =
      https://raw.githubusercontent.com/vmchale/github-actions-dhall/master/dhall-ci.dhall sha256:0ef11bbce3ff55ed7c0320be282e4a547844539b0a7de3c54eb3fdec84090c8b

in    dhallCi.dhallSteps
        [ dhallCi.dhallYamlInstall
        , dhallCi.checkDhallYaml
            [ "dhall-ci.dhall", "ci.dhall", "toml-ci.dhall" ]
        ]
    : dhallCi.CI
