# Pipeline Readme

This repository contains a Jenkins pipeline script for performing Kubescape scans on different components of a Kubernetes deployment. The pipeline is designed to trigger scans based on changes detected in specific files or Jenkinsfiles.

## Pipeline Structure

The pipeline consists of the following stages:

- **Kubescape Scan for Resource Server (RS):** This stage triggers a Kubescape scan for the Resource Server component if any changes are detected in the related templates, values file, or the RS-Jenkinsfile.
- **Kubescape Scan for Auth Server (Auth):** This stage triggers a Kubescape scan for the Auth Server component if any changes are detected in the related templates, values file, or the Auth-Jenkinsfile.
- **Kubescape Scan for Catalogue (CAT):** This stage triggers a Kubescape scan for the Catalogue component if any changes are detected in the related templates, values file, or the Cat-Jenkinsfile.
- **Kubescape Scan for Latest Ingestion Pipeline (LIP):** This stage triggers a Kubescape scan for the Latest Ingestion Pipeline component if any changes are detected in the related templates, values file, or the LIP-Jenkinsfile.
- **Kubescape Scan for File Server (FS):** This stage triggers a Kubescape scan for the File Server component if any changes are detected in the related templates, values file, or the FS-Jenkinsfile.
- **Kubescape Scan for GIS Interface (GIS):** This stage triggers a Kubescape scan for the GIS Interface component if any changes are detected in the related templates, values file, or the GIS-Jenkinsfile.
- **Kubescape Scan for Data Ingestion (DI):** This stage triggers a Kubescape scan for the Data Ingestion component if any changes are detected in the related templates, values file, or the DI-Jenkinsfile.
- **Kubescape Scan for Auditing Server (Auditing):** This stage triggers a Kubescape scan for the Auditing Server component if any changes are detected in the related templates, values file, or the Auditing-Jenkinsfile.

## Usage

To use this pipeline, follow these steps:

1. Set up a Jenkins environment with the necessary plugins and agents.
2. Create a Jenkins pipeline job and configure it to use this pipeline script.
3. Ensure that the required Kubescape scan jobs (`kubescape-rs`, `kubescape-auth`, etc.) are available and properly configured in your Jenkins instance.
4. Make sure to provide the required parameters (`ghprbActualCommit` and `ghprbPullId`) when triggering the Kubescape scan jobs within the pipeline. These parameters represent the actual commit and pull request ID associated with the changes being scanned.
5. Commit your changes and push them to the repository.
6. The pipeline will automatically trigger the relevant Kubescape scans based on the detected changes.

Please note that the pipeline assumes a specific file structure and naming conventions for the Kubernetes deployment files and Jenkinsfiles. Make sure to update the pipeline script according to your project's structure if necessary.

## Contributing

Contributions to this pipeline script are welcome! If you have any suggestions, improvements, or bug fixes, feel free to submit a pull request.


