#docker run --gpus all --privileged --name test -it -v $HOME/work/projects:/projects -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY -e XAUTHORITY -e NVIDIA_DRIVER_CAPABILITIES=all dmasatoumae/use-rs-ros

FROM nvidia/cuda:10.1-devel-ubuntu18.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y
RUN apt-get upgrade -y

RUN apt-get install vim-gtk -y
RUN apt-get install libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev -y
RUN apt-get install iputils-ping net-tools -y
RUN apt-get install xterm -y
RUN apt-get install udev -y
RUN apt-get install curl -y
RUN apt-get install build-essential -y

# librealsense v2.37.0 build
RUN apt-get install libgtk-3-dev -y
RUN apt-get install tzdata -y
RUN apt-get install git -y
RUN apt-get install cmake -y
RUN apt-get install libusb-1.0-0-dev -y
RUN apt-get install libglfw3-dev libgl1-mesa-dev libglu1-mesa-dev -y

RUN cd /home  && \
      mkdir source  && \
      cd source && \
      git clone https://github.com/IntelRealSense/librealsense.git && \
      cd librealsense && \
      git checkout -b 2.37.0 refs/tags/v2.37.0 && \
      cp ./config/99-realsense-libusb.rules /etc/udev/rules.d/ && \
      apt-get update -y && \
      mkdir build && \
      cd build && \
      cmake .. && \
      make -j8 && \
      make install

# PointCloudLibrary build
RUN apt-get install libeigen3-dev -y
RUN apt-get install libflann-dev -y
RUN apt-get install libboost-all-dev -y
RUN apt-get install linux-libc-dev libudev-dev mpi-default-dev openmpi-bin openmpi-common libvtk6.3-qt libvtk6.3 libvtk6-dev libqhull* libgtest-dev freeglut3-dev pkg-config libxmu-dev libxi-dev mono-complete libqt4-dev openjdk-8-jdk openjdk-8-jre -y
RUN cd /home/source && \
      git clone https://github.com/PointCloudLibrary/pcl.git && \
      cd pcl && \
      git checkout -b 1.11.1 refs/tags/pcl-1.11.1 && \
      mkdir build && cd build && cmake .. && make -j8 && make install

#ROSのインストール
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros-latest.list' -y
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 
RUN curl -sSL 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' | apt-key add -
RUN apt-get update -y && apt-get upgrade -y && apt-get install ros-melodic-desktop -y
RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
RUN ["/bin/bash", "-c", "source /opt/ros/melodic/setup.bash"]

RUN apt install python-rosdep python-rosinstall python-rosinstall-generator python-wstool  -y
RUN rosdep init
RUN rosdep update -y
RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
RUN ["/bin/bash", "-c", "source /opt/ros/melodic/setup.bash"]
RUN apt-get install python-rosinstall python-rosinstall-generator python-wstool -y

RUN /bin/bash -c '. /opt/ros/melodic/setup.bash; mkdir -p ~/catkin_ws/src && catkin_init_workspace && cd ~/catkin_ws/ && catkin_make '

RUN chmod +x /opt/ros/melodic/setup.bash


RUN /bin/bash -c '. /opt/ros/melodic/setup.bash; cd ~/catkin_ws; catkin_make clean && \
      catkin_make -DCATKIN_ENABLE_TESTING=False -DCMAKE_BUILD_TYPE=Release && \
      catkin_make install && \
      source ~/catkin_ws/devel/setup.bash'


RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
RUN echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
# ros-pcl
RUN apt-get install ros-melodic-pcl-msgs -y
RUN apt-get install ros-melodic-tf2-eigen -y

RUN cd ~/catkin_ws/src/ && \
      git clone https://github.com/ros-perception/perception_pcl.git 
RUN ["/bin/bash", "-c", "source ~/.bashrc" ]

#RUN cd ~/catkin_ws/ && catkin_make && catkin_make install

# realsense-ros-wrapper
RUN apt-get install ros-melodic-ddynamic-reconfigure -y
RUN cd /root/catkin_ws/src/ && \
      git clone https://github.com/IntelRealSense/realsense-ros.git && \
      cd realsense-ros/ && \
      git checkout -b v2.2.16 refs/tags/2.2.16
RUN cd ~/catkin_ws/src/ && git clone https://github.com/dmasatoumae/mpu6050_serial_to_imu.git
RUN cd ~/catkin_ws/src/ && git clone https://github.com/wjwwood/serial.git
#RUN cd ~/catkin_ws/ && catkin_make && catkin_make install
      

RUN ["/bin/bash", "-c", "source ~/.bashrc"]


WORKDIR ~/

