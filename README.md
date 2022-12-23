## Docker Infrastructure as Code CI Image

A container for using in continuous integration where you need tools to deploy
infrastructure code.

This container starts with the ansible image from https://github.com/willhallonline/docker-ansible
and adds Helm and Kubectl.

### Use
`docker pull bowens/docker-iac-builder`