#!/bin/bash
set -o pipefail
IFS=$'\n\t'

# Check if required environment variables are set
if [[ -z "$SOURCE_REPOSITORY" || -z "$RUN_DESCRIPTION" ]]; then
  echo "Error: SOURCE_REPOSITORY or RUN_DESCRIPTION is not set."
  exit 1
fi

echo $BUILD | jq . - > /tmp/build-spec.json
cat /tmp/build-spec.json

# Fix jq command syntax issue
cat /tmp/build-spec.json | jq -r '.spec.strategy.customStrategy.env[] | "export \(.name)=\(.value)"' > /tmp/env-vars

source /tmp/env-vars
cat /tmp/env-vars
echo --

if [[ "$DEBUG" = "true" ]]; then
    set -x
fi

if [[ "${SOURCE_REPOSITORY}" != "git://"* ]] && [[ "${SOURCE_REPOSITORY}" != "git@"* ]]; then
  URL="${SOURCE_REPOSITORY}"
  if [[ "${URL}" != "http://"* ]] && [[ "${URL}" != "https://"* ]]; then
    URL="https://${URL}"
  fi
fi

# Use the public repository URL
SOURCE_REPOSITORY="${URL}"

# Proceed with cloning
if [ -n "${SOURCE_REF}" ]; then
  BUILD_DIR=$(mktemp -d)
  git clone --recursive "${SOURCE_REPOSITORY}" "${BUILD_DIR}"
  if [ $? != 0 ]; then
    echo "Error: Unable to clone the git repository: ${SOURCE_REPOSITORY}"
    exit 1
  fi

  pushd "${BUILD_DIR}" > /dev/null
  git checkout "${SOURCE_REF}"
  if [ $? != 0 ]; then
    echo "Error: Unable to checkout branch: ${SOURCE_REF}"
    exit 1
  fi

  echo -- source-ref
  cd ${SOURCE_CONTEXT_DIR}
  ls -lah ./

  # Ensure gatling.sh has the correct executable permissions
  if [ -f "/opt/gatling/bin/gatling.sh" ]; then
    chmod +x /opt/gatling/bin/gatling.sh
    /opt/gatling/bin/gatling.sh --run-description "${RUN_DESCRIPTION}" --simulation "simulations.MySimulation"
  else
    echo "Error: gatling.sh not found!"
    exit 1
  fi

  export EXIT_CODE="$?"

  # Check if the results directory exists and process it
  if [ -d "/opt/gatling/results/" ]; then
    cd /opt/gatling/results/
    if [ "$(ls -A .)" ]; then
      cd *
      for file in $(find ./ -type f); do
        curl -s -k -u $GO_USERNAME:$GO_PASSWORD $GO_SERVER_URL/files/$GO_PIPELINE_NAME/$GO_PIPELINE_COUNTER/$GO_STAGE_NAME/$GO_STAGE_COUNTER/$GO_JOB_NAME/${file:2} -F file=@${file:2} -H 'Confirm:true' > /dev/null
      done
    else
      echo "No files found in the results directory."
    fi
  else
    echo "Results directory not found."
  fi

  popd > /dev/null
else
  echo "Error: No source-ref provided."
  exit 1
fi

exit "$EXIT_CODE"
