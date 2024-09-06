
#!/bin/bash

# Run Gatling with custom options
/opt/gatling/bin/gatling.sh --run-description "$RUN_DESCRIPTION" --simulation "simulations.MySimulation" --results-folder "/opt/gatling/user-files/simulations/results"
