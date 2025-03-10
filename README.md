# DOCKER ROS2 SETUP FOR REAL ROBOT

# ROS Docker

Provides an easy setup of ROS with the Dev Container extension of VS Code.
The setup was originally created using the [VS Code Docker Guide](https://docs.ros.org/en/humble/How-To-Guides/Setup-ROS-2-with-VSCode-and-Docker-Container.html) in the ROS 2 documentation, but has been modified.

## Prerequisites

You have to install VS Code, Docker, and the Dev Container extension for VS Code.
The installation of VS Code on Ubuntu is described [here](https://code.visualstudio.com/docs/setup/linux).
For a guide to set up dev containers, check out [this tutorial](https://code.visualstudio.com/docs/devcontainers/tutorial).
For installing docker on Ubuntu, you can use the docker apt repository, as described in the [docker docs](https://docs.docker.com/engine/install/ubuntu/).
The official docker packages of Ubuntu may also work, but may be older versions.

## NVIDIA GPU acceleration

To enable GPU acceleration in the containers, make sure you also install the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html). Note: If you already have the CUDA apt repository set up, it includes the nvidia-container-toolkit package, so you don't need to add the nvidia-container apt repository. Run:

```
sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

In devcontainer.json, make sure "--gpus", "all" is added to runArgs (this is already the case for the workspaces in this repository), or configure it to use a specific device.

## Workspace setup

The ros1 and ros2 folders contain a hidden .devcontainer folder with the configuration files for the container.
To start up the container, you can press F1 and search for "Dev Containers: Open Folder in Container...", then select either ros1 or ros2.
Alternatively, you can navigate to the folder in a terminal and open it with "code .".
VS Code should recognize the .devcontainer configuration and ask you if you want to reopen the folder in the container.
If it doesn't, you can also press F1 and search for "Dev Containers: Rebuild and Reopen in Container".
If you change your configuration while being inside of the container and need to rebuild it, select "Dev Containers: Rebuild Container".

You may want to modify the files for your setup:

### devcontainer.json

The entry point for the devcontainer.
You may want to change the DOCKER_REPO, ROS_DISTRO and IMAGE_SUFFIX variables.
More information on which base image to choose can be found in the README of the [OSRF docker images repository](https://github.com/osrf/docker_images).
It also by default mounts the .ssh directory from your home folder into the docker home directory, so that you can use your keys from within.
This may not be necessary depending on your use case (devcontainers also have a [built-in functionality](https://code.visualstudio.com/remote/advancedcontainers/sharing-git-credentials) to share git credentials and ssh keys).

### Dockerfile

Pulls the docker image for the specified distribution.
Note that there are different versions of docker images with preinstalled packages available, so depending on your use case, you might want to switch to one of those (see devcontainer.json).
Also installs some basic packages.
You can add additional packages or remove the ones you don't need.
Workspace dependencies will be installed via rosdep when the container is started via the postCreateCommand, but these packages might have to be reinstalled if you change the workspace and have additional dependencies.
So it could be worth it to manually check your dependencies and add those here.
These will then be cached by Docker, so as long as you don't change the Dockerfile, you will not need to reinstall them.

### initialize.sh

This file is executed on the host machine during initialization.
Currently not used.

### postCreate.sh

This file is executed after the container has been created.
It installs missing workspace dependencies via rosdep and gives the container user ownership of the mounted workspace folder.
It also initializes and builds the workspace.

## Usage

### Pre-requisites
- Clone the ros_docker repository on your local system
- Install VS Code IDE and the Docker Dev Container extension for the VS Code
- To use the respective ros1/ros2 environment:
### ROS 2
- Open the ros2 folder in VSCode. 
- Click the ´Reopen in Container´ or ´Rebuild the container´ popup given by Dev Container extension.
- Select the appropriate devcontainer.json file for your usage. 

## Create a workspace for a specific setup

This repository is meant to provide the base configurations to create a ROS workspace.
It is not meant to contain any packages.
To create a workspace for a specific setup, e.g. a robot or a set of packages, copy either the contents of ros1 or ros2 into a new git repository.
Then, you can add the required packages as submodules into the src folder of that directory.

### Installation of ROS middleware

The following command is used to install Cyclone-dds as middleware. As an alternate option 'fastrtps' can be used.

```sudo apt install ros-humble-rmw-cyclonedds-cpp```

Set it as environment variable.

```export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp```

To check the installation and setup use the following command.

```ros2 doctor --report```
