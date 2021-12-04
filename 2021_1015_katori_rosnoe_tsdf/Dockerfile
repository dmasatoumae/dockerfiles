FROM nvidia/cudagl:11.3.1-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y
RUN apt-get upgrade -y

RUN apt-get install -y  vim-gtk \
      net-tools \
      tmux \
      dirmngr\
      gnupg2

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN echo "deb http://packages.ros.org/ros/ubuntu focal main" > /etc/apt/sources.list.d/ros1-latest.list

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

ENV ROS_DISTRO noetic

RUN apt-get update && apt-get install -y --no-install-recommends \
      ros-noetic-desktop-full 
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
RUN ["/bin/bash", "-c", "source ~/.bashrc"]

RUN apt install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential -y

RUN rosdep init

RUN rosdep update

RUN apt install python3-pip -y
