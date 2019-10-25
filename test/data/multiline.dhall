{- a block comment -}
let str = "not beginning of multiline \" string''"
in

let foo =
      ''
      docker login -u "$DOCKER_USER" -p "$DOCKER_PASS"
      doesn't
      -- not a comment
      {- not the beginning of a comment
      ''' escaped tick

      docker build -f frontend/Dockerfile-prod \
        --build-arg OAUTH_GITHUB_CLIENT_ID=''${OAUTH_GITHUB_CLIENT_ID-""} \
        --build-arg OAUTH_GITLAB_CLIENT_ID=''${OAUTH_GITLAB_CLIENT_ID-""} \
        --build-arg OAUTH_GOOGLE_CLIENT_ID=''${OAUTH_GOOGLE_CLIENT_ID-""}
      ''

-- not the beginning of a multiline string: ''
-- a comment
in foo {- a block
comment -}
