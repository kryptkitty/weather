#!/usr/bin/env nix-shell
#! nix-shell -p findutils -p gnused -p git -i bash
  cd "$(dirname "$0")"

  PROJNAME_AUTO="${PWD##*/}"
  AUTHOR_AUTO="$(git config --get user.name)"
  REPO_AUTO="$PWD"

  read -erp "$(printf "%30s: " "project name [$PROJNAME_AUTO]")" PROJNAME_IN
  read -erp "$(printf "%30s: " "author [$AUTHOR_AUTO]")" AUTHOR_IN
  read -erp "$(printf "%30s: " "github org [enter to use local paths]")" GITHUB_ORG_IN

  PROJNAME="$PROJNAME_AUTO"
  [ x"$PROJNAME_IN" != x ] && PROJNAME="$PROJNAME_IN"

  AUTHOR="$AUTHOR_AUTO"
  [ x"$AUTHOR_IN" != x ] && AUTHOR="$AUTHOR_IN"
  
  REPO="$REPO_AUTO"
  [ x"GITHUB_ORG_IN" != x ] && REPO="github:$GITHUB_ORG_IN/$PROJNAME"

  find . -type f -exec sed -i -E -e '
    s#@PACKAGE@#'"$PROJNAME"'#g
    s#@AUTHOR@#'"$AUTHOR"'#g
    s#@REPO@#'"$REPO"'#g
  ' {} \;
  mv @PACKAGE@.nix "$PROJNAME".nix
  1>&2 echo "all done.  removing init-template.sh."
  rm init-template.sh

