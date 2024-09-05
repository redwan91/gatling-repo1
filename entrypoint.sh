#!/bin/bash
set -o pipefail
IFS=$'\n\t'

echo $BUILD | jq . - > /tmp/build-spec.json
cat /tmp/build-spec.json

cat /tmp/build-spec.json | jq -r '.spec.strategy.customStrategy.env | map([ "export " + .name, "\"" + .value + "\""] | join("=")) | join(" \n")' > /tmp/env-vars

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

export URL
GIT_USER="$(cat /var/run/secrets/openshift.io/source/username)"
GIT_PASS="$(cat /var/run/secrets/openshift.io/source/password)"
URL="$(echo $URL | sed -e s%://%://$GIT_USER:$GIT_PASS@%g)"
SOURCE_REPOSITORY="${URL}"
SOURCE_REF="${SOURCE_REF-master}"

if [ -n "${SOURCE_REF}" ]; then
  BUILD_DIR=$(mktemp -d)
  git clone --recursive "${SOURCE_REPOSITORY}" "${BUILD_DIR}"
  if [ $? != 0 ]; then
    echo "Error trying to fetch git source: ${SOURCE_REPOSITORY}"
    exit 1
  fi
  pushd "${BUILD_DIR}"
  git checkout "${SOURCE_REF}"
  if [ $? != 0 ]; then
    echo "Error trying to checkout branch: ${SOURCE_REF}"
    exit 1
  fi

  echo -- source-ref
  cd ${SOURCE_CONTEXT_DIR}
  ls -lah ./

  gatling.sh --run-description "${RUN_DESCRIPTION}" --simulation "simulations.MySimulation"

  export EXIT_CODE="$?"

  cd /opt/gatling/results/
  cd *
  for file in $(find ./ -type f); do
    curl -s -k -u $GO_USERNAME:$GO_PASSWORD $GO_SERVER_URL/files/$GO_PIPELINE_NAME/$GO_PIPELINE_COUNTER/$GO_STAGE_NAME/$GO_STAGE_COUNTER/$GO_JOB_NAME/${file:2} -F file=@${file:2} -H 'Confirm:true' > /dev/null
  done

  popd
else
  echo -- no source-ref
fi

exit "$EXIT_CODE"
