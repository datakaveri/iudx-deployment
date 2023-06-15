# Advance Monitoring Stack
Docker image for advance monitoring stack. The purpose of this code is to perform automated API testing and monitoring. It includes functions to handle API requests, obtain authentication tokens, and send requests with various parameters such as headers, payloads, and files. The code utilizes the `requests` library for making HTTP requests and `prometheus_client` for collecting and exposing metrics.

The `AMS` function executes API tests based on the provided configuration. It handles different types of API tests, such as private authentication-based tests and tests that check for specific conditions in the response. The function measures and collects metrics like HTTP status codes, response times (RTT), and the time the API request was made.

The code loads the configuration from a JSON file (`adv-mon-stack-conf.json`) and sets up Prometheus metrics for tracking the status codes, RTT, and request time of the API tests. It uses the `schedule` library to schedule the execution of the `AMS` function at specified intervals.


The source code is present at ``src/`` folder.
## Build Docker Image
```sh
docker build -t ghcr.io/datakaveri/ams:4.0.0-4.
```
