# Keepalived

## Description
This is currently just a placeholder file until I have more time to write a README file!

This is a Keepalived container which can be used with both Docker and Kubernetes configurations. There are multiple CPU architecture available for download. The continer contains a startup script with will attempt to automatically configure keepalived to the primary interface of the instance it is running.

My intention for building this is for it be run a Bare Metal kubernetes cluster with a Multi Master configuration. Once the image is created I will be writing a manifest so it will load on all Master nodes in a kubernetes cluster and create a HA IP address for accessing the Kubernetes API.

I'm planning on running the kubernetes masters on Raspberry Pis, so I've configured multi architectures. I will be using RPi 4, however, I added the other ARM processors as a bonus.

If you have any comment or queries feel free to leave a comment on Github.

