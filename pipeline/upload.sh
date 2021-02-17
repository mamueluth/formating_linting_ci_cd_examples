#!/bin/bash

set -euo pipefail

version=2
algo_name=$(head -n 1 benchmark.csv | cut -d ' ' -f2)
algo_type=$(head -n 1 benchmark.csv | cut -d ' ' -f3)
score=$(awk 'BEGIN{ FS=","; s=0} NR>=3{ s+=$4*$5 } END {print s}' benchmark.csv)
echo "Final score (benchmark v$version):" $score
curl -X POST \
  -F token=$TRIGGER_TOKEN \
  -F variables[VERSION]=$version \
  -F variables[PROJECT_URL]=$CI_PROJECT_URL \
  -F variables[USER_NAME]=${CI_PROJECT_NAMESPACE##*/} \
  -F variables[COMMIT]=${CI_COMMIT_SHORT_SHA} \
  -F variables[ALGO_NAME]="${algo_name}" \
  -F variables[ALGO_TYPE]="${algo_type}" \
  -F variables[SCORE]=${score} \
  -F ref=master \
  "https://git.scc.kit.edu/api/v4/projects/21914/trigger/pipeline"
