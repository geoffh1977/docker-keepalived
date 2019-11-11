# Keepalived Docker Image
![Keepalived Logo](https://github.com/geoffh1977/docker-keepalived/raw/master/files/keepalived.png  "Keepalived Logo")

![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/geoffh1977/keepalived.svg?style=plastic) ![Keepalived Badge](https://img.shields.io/badge/Keepalived-v2.0.19-eba935.svg?style=plastic)

## Description
This repository is the home of my Keepalived image, a self configuring image which has been setup for use with both Docker and Kubernetes clusters. As my personal intention is to use this image with Raspberry Pi architecture to setup a bare metal multi host master kubernetes cluster, the repository contains configurations for multiple ARM and x86 CPU architectures.

The github repository contains a Kubernetes manifest which is an example of how to execute the container. The manifest will run the container on all Master nodes in the cluster in an attempt to share the Kubernetes API.

## How Does It Work
When image is run, a script is executed which determines the Primary Network Interface of the machine/instance by checking the network routing table (searchingfor the 0.0.0.0 route). After retriving the IP address of the interface, a Virtual Route ID is set for Keepalived along with a randomly generated password and a Virtual IP.

All these details are placed in a templated kubealived config file and the service is executed.

## Configuration
A Kubernetes manifest is contained within the Github repository with an example of how to set up the container. The container has 4 configurable Environment variables, each of which will be populated automtically if they re not set at runtime. The variables are:

- **INTERFACE -** The interface which keepalived will be running on. If not populated, the primary interface (routing 0.0.0.0) will be selected.
- **ROUTE_ID -** The Virtual Router ID for keepalived, a number between 1 and 255. The 4th number of the IP address will be used if not set.
- **PASSWORD -** The password keepalived uses to sync on the network. This should be set the same for all the keepalived instances in a cluster. A random password is generated if not set.
- **VIRTUAL_IP -** The Virtual IP to use on with keepalived. This is simply set to 192168.1.250 by default.

For a cluster to be formed correctly, the **PASSWORD** variable (at a minimum) must be set so the cluster can operate. An example of a docker command to run keepalived work look something like:

	docker run -d -e PASSWORD=sharepwd -e VIRTUAL_IP=10.10.10.1 geoffh1977/keepalived

## Feedback and Comments
If you have any comment or queries feel free to leave a comment on Github.

