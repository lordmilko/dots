#!/usr/bin/env bash
source ~/.local/bin/contrib/shellscriptloader-0.1.1/loader.sh || exit 1

loader_addpath "$(dirname "${BASH_SOURCE[0]}")"

function bootstrap::finish {
  loader_finish
}
