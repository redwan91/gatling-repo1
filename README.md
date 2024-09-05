# Openshift Gatling Build

This is an example Openshift CustomBuild that pulls a git repo, and runs a specified Gatling simulation.

## Environment Variables:
- `SIMULATION`: The name of the Gatling simulation to run.
- `RUN_DESCRIPTION`: A description of the run.
- `SOURCE_REPOSITORY`: The git repository to pull the code from.
- `SOURCE_REF`: The branch or tag to use in the git repository (default: `master`).
- `BASE_URL`: The base URL for the Gatling simulation (default: `https://jsonplaceholder.typicode.com`).
- `USERS`: Number of users to inject for the simulation (default: `10`).

## Usage

1. Build the Docker image:
   ```bash
   docker build -t gatling-simulation .
   ```

2. Run the simulation with environment variables:
   ```bash
   docker run -e SIMULATION="MySimulation" -e RUN_DESCRIPTION="API Test" -e BASE_URL="https://your-api.com" -e USERS=20 gatling-simulation
   ```
