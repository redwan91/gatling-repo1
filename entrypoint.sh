
#!/bin/bash
set -o pipefail

# Check if required environment variables are set
if [[ -z "$SOURCE_REPOSITORY" || -z "$RUN_DESCRIPTION" ]]; then
  echo "Error: SOURCE_REPOSITORY or RUN_DESCRIPTION is not set."
  exit 1
fi

# Clone the source repository
BUILD_DIR=$(mktemp -d)
git clone --recursive "$SOURCE_REPOSITORY" "$BUILD_DIR"
cd "$BUILD_DIR"

# Ensure results directory exists
SIMULATION_RESULTS_DIR="/opt/gatling/user-files/simulations/results"
mkdir -p "$SIMULATION_RESULTS_DIR"

# Run the custom Gatling script
/run-gatling.sh
