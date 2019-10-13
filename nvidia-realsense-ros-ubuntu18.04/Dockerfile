#runオプション

#docker run --runtime=nvidia --privileged --name {name} -it -v $HOME/work/projects:/projects -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY -e XAUTHORITY -e NVIDIA_DRIVVER_CAPABILITIES=all nvidia/cuda:10.1-devel-ubuntu18.04

FROM nvidia/cuda:10.1-devel-ubuntu18.04
#インタラクティブな設定をしなくなる（＝入力待ちでブロックしなくなる）ので、自動インストールの際には便利

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install vim-gtk -y
RUN apt-get install libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev -y
RUN apt-get install iputils-ping net-tools -y
RUN apt-get install xterm -y
RUN apt-get install firefox -y
RUN apt-get install udev -y
RUN apt-get install tmux -y

#ROSのインストール
#packages.ros.org からソフトウェアを受容するための設定
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros-latest.list' -y
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN apt install curl -y
RUN curl -sSL 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' | apt-key add -
RUN apt-get update -y

#すべてのデスクトップ環境のインストール:(推奨): ROS、rqt、rviz、ロボットの一般的なライブラリ、2D/3Dシミュレータ、ナビゲーション、2D/3D認識
RUN apt install ros-melodic-desktop-full -y
RUN rosdep init
RUN rosdep update -y
RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
RUN ["/bin/bash", "-c", "source /opt/ros/melodic/setup.bash"]
RUN apt install python-rosinstall python-rosinstall-generator python-wstool build-essential -y

#librealsense v2.22.0 build
RUN apt-get install libgtk-3-dev -y
RUN apt-get install tzdata -y
RUN apt-get install git -y
RUN cd /home  && \
      mkdir source  && \
      cd source && \
      git clone https://github.com/IntelRealSense/librealsense.git && \
      cd librealsense && \
      git checkout -b 2.22.0 refs/tags/v2.22.0 && \
      cp ./config/99-realsense-libusb.rules /etc/udev/rules.d/ && \
      apt-get update -y && \
      mkdir build && \
      cd build && \
      cmake .. && \
      make -j4 && \
      make install
#ワークスペースの作成とrealsense-ros-wrapperのビルド

RUN /bin/bash -c '. /opt/ros/melodic/setup.bash; mkdir -p ~/catkin_ws/src && catkin_init_workspace && \
      cd ~/catkin_ws/ && catkin_make '
#root/catkin_ws/src'

RUN cd .. && \
      mkdir -p ~/catkin_ws/src/ && \
      cd ~/catkin_ws/src/ && \
#git clone https://github.com/pal-robotics/ddynamic_reconfigure.git && \
      git clone https://github.com/IntelRealSense/realsense-ros.git && \
      cd realsense-ros/ && \
      git checkout -b 2.2.4 refs/tags/2.2.4 && \
      cd ..
RUN chmod +x /opt/ros/melodic/setup.bash
RUN /bin/bash -c '. /opt/ros/melodic/setup.bash; cd ~/catkin_ws; catkin_make clean && \
      catkin_make -DCATKIN_ENABLE_TESTING=False -DCMAKE_BUILD_TYPE=Release && \
      catkin_make install && \
      source ~/catkin_ws/devel/setup.bash'


RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
RUN echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc

#Point Cloud Library
WORKDIR /home/source/
RUN git clone https://github.com/PointCloudLibrary/pcl.git && \
      cd pcl && mkdir build/ && cd build/ && cmake .. && make -j4 && \
      make install



RUN ["/bin/bash", "-c", "source ~/.bashrc"] 
  
