# K8s cluster in AWS using Rancher
Following is a brief documentation on to setup cluster autoscalable K8s cluster using Rancher.
The K8s cluster setup is tested out in a single Availabilty zone in AWS. 

## Design
1. Architecture: Diagram descibing k8s cluster architecture used to setup.
2. **HA of K8s cluster** : The controler plane and etcd is deployed in three nodes setup. The etcd data store is backed up to S3 using Rancher.
## Pre-requisites
These elements are required to follow this guide:
- The Rancher server is up and running. [Refer](../../README.md)
- You have an AWS EC2 user with proper permissions to create virtual machines, auto scaling groups, and IAM profiles and roles
- A VPC with atleast one subnet in AWS

## Installation
Installation of K8s cluster in aws with cluster auto-scale integration. This is done using launchung of K8s cluster from Rancher using custom nodes. Following docs was used to setup the K8s cluster in aws : https://rancher.com/docs/rancher/v2.5/en/cluster-admin/cluster-autoscaler/amazon/

## Notes

## ToDO
Write extensive docs on bringing up cluster 