#!/bin/bash

FALLBACKS="@leon-inf @Y-Rookie @apecloud/kb-reviewers"

function codeowners_content() {
  cat <<-EOF
# GENERATED BY $(basename $0), DO NOT EDIT!

* $FALLBACKS
.github/ @JashBook @ahjing99 $FALLBACKS
examples/ @ahjing99 @shanshanying $FALLBACKS

# GitHub IDs in following rules are extracted from Chart.yaml files.
# Some IDs may be invalid or lack necessary permissions. Please ignore them.
EOF

  for d in $(find ./addons -type d -maxdepth 1 -not -name "kblib" | sort); do
    if [[ ! -f "$d/Chart.yaml" ]]; then
      continue
    fi
    local addon=$(basename "$d")
    local maintainers=$(yq e '["@" + (.maintainers[].name | sub(" "; "_"))] | join(" ")' "$d/Chart.yaml")
    echo ""
    echo "addons/$addon/ $maintainers $FALLBACKS"
    echo "addons-cluster/$addon/ $maintainers $FALLBACKS"
  done
}

CURR_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$CURR_DIR/.."
codeowners_content > .github/CODEOWNERS
