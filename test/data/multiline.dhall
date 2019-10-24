{- a block comment -}
let foo =
      ''
      docker login -u "$DOCKER_USER" -p "$DOCKER_PASS"
      -- not a comment
      docker build -f frontend/Dockerfile-prod \
        --build-arg OAUTH_GITHUB_CLIENT_ID=''${OAUTH_GITHUB_CLIENT_ID-""} \
        --build-arg OAUTH_GITLAB_CLIENT_ID=''${OAUTH_GITLAB_CLIENT_ID-""} \
        --build-arg OAUTH_GOOGLE_CLIENT_ID=''${OAUTH_GOOGLE_CLIENT_ID-""}
      ''

-- a comment
in foo {- a block
comment -}
