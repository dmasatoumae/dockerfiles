# versiion
ARG cuda_version=9.0
# ARG cudnn_version=7
ARG ubuntu_version=16.04
ARG nvidia_cudnn_version=7.1.3.16-1+cuda9.0

FROM nvidia/cudagl:${cuda_version}-devel-ubuntu${ubuntu_version}
# FROM nvidia/cuda:${cuda_version}-cudnn${cudnn_version}-devel-ubuntu16.04

# base image

# ENV LANG C.UTF-8
# ENV LC_ALL C.UTF-8

################################################################################

# Install the Nvidia cuDNN library missing in the parent image.
# https://gitlab.com/nvidia/cuda/blob/ubuntu16.04/10.1/devel/cudnn7/Dockerfile
ARG nvidia_cudnn_version
ENV NVIDIA_CUDNN_VERSION=${nvidia_cudnn_version}
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcudnn7=${NVIDIA_CUDNN_VERSION} \
    libcudnn7-dev=${NVIDIA_CUDNN_VERSION} \
    && apt-mark hold libcudnn7 \
    && rm -rf /var/lib/apt/lists/*

################################################################################

# Install ROS Kinetic Kame.
# http://wiki.ros.org/kinetic/Installation/Ubuntu
# Update the package list.
RUN echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list

# Add the package keys.
RUN apt-key adv --keyserver 'hkp://ha.pool.sks-keyservers.net:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# Install 'ros-kinetic-desktop-full' packages (including ROS, Rqt, Rviz, and more).
#ARG ros_desktop_version
#ENV ROS_DESKTOP_VERSION=${ros_desktop_version}

RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-kinetic-desktop-full \
    && rm -rf /var/lib/apt/lists/*

# Install ROS bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-rosdep \
    python-rosinstall \
    python-vcstools \
    python-rosinstall-generator \
    python-wstool

RUN rosdep init 
RUN rosdep update
RUN echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc

# gnome-terminal
RUN apt-get install -y dbus dbus-x11 language-pack-ja locales 
RUN locale-gen ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:jp
ENV LC_ALL ja_JP.UTF-8
RUN echo 'eval `dbus-launch --sh-syntax`' >> /root/.bashrc 


