#runオプション
#docker run -it --device=/dev/video0:/dev/video0 --device=/dev/video1:/dev/video1 --device=/dev/video2:/dev/video2 --device=/dev/video3:/dev/video3 --name ubuntu-rs -e DISPLAY=$DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix ubuntu-rs /bin/bash

#docker run -it --rm --privileged --name {name} -e DISPLAY=$DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix {image_name} /bin/bash

FROM ubuntu:16.04

RUN apt-get update
RUN apt-get upgrade
RUN apt-get install vim-gtk -y
RUN apt-get install libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev -y
RUN apt-get install git -y
RUN apt-get install sl -y
RUN apt-get install iputils-ping net-tools -y
RUN apt-get install xterm -y
RUN apt-get install firefox -y
RUN apt-get install udev -y
#ROSのインストール
#packages.ros.org からソフトウェアを受容するための設定

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' -y
RUN apt-key adv --keyserver 'hkp://ha.pool.sks-keyservers.net:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 
RUN apt-get update -y
#すべてのデスクトップ環境のインストール:(推奨): ROS、rqt、rviz、ロボットの一般的なライブラリ、2D/3Dシミュレータ、ナビゲーション、2D/3D認識
RUN apt-get install ros-kinetic-desktop-full -y
RUN rosdep init
RUN rosdep update
RUN ["/bin/bash", "-c", "source /opt/ros/kinetic/setup.bash"]
RUN apt-get install python-rosinstall -y
#librealsense v2.22.0 build
RUN apt-get install build-essential libgtk-3-dev -y
RUN cd /home  && \
      mkdir source  && \
      cd source && \
      git clone https://github.com/IntelRealSense/librealsense.git && \
      cd librealsense && \
      git checkout -b 2.22.0 refs/tags/v2.22.0 && \
      cp ./config/99-realsense-libusb.rules /etc/udev/rules.d/ && \
      #udevadm control --reload-rules && udevadm trigger && \
      #./scripts/patch-realsense-ubuntu-lts.sh && \
      apt-get update -y && \
      mkdir build && \
      cd build && \
      cmake .. && \
      make -j8 && \
      make install
#ワークスペースの作成とrealsense-ros-wrapperのビルド

RUN /bin/bash -c '. /opt/ros/kinetic/setup.bash; mkdir -p ~/catkin_ws/src && catkin_init_workspace && \
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

RUN /bin/bash -c '. /opt/ros/kinetic/setup.bash; cd ~/catkin_ws; catkin_make clean && \
      catkin_make -DCATKIN_ENABLE_TESTING=False -DCMAKE_BUILD_TYPE=Release && \
      catkin_make install && \
      source ~/catkin_ws/devel/setup.bash'


RUN echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
RUN echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
RUN ["/bin/bash", "-c", "source ~/.bashrc"] 
RUN apt-get install tmux -y



  
