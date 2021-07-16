# https://github.com/turlucode/ros-docker-gui/tree/master/nvidia/noetic/cuda11.1
FROM nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04
MAINTAINER Athanasios Tasoglou <athanasios@tasoglou.net>
LABEL Description="ROS-Noetic-Desktop with CUDA 10.2 support (Ubuntu 18.04)" Vendor="TurluCode" Version="1.0"

# Install packages without prompting the user to answer any questions
ENV DEBIAN_FRONTEND noninteractive 

# Install packages
RUN apt-get update && apt-get install -y \
locales \
lsb-release \
mesa-utils \
git \
subversion \
nano \
terminator \
xterm \
wget \
curl \
htop \
libssl-dev \
build-essential \
dbus-x11 \
software-properties-common \
gdb valgrind && \
apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt purge -y python2.7-minimal && apt-get update

# Install cmake 3.18.4
RUN git clone https://gitlab.kitware.com/cmake/cmake.git && \
cd cmake && git checkout tags/v3.18.4 && ./bootstrap --parallel=8 && make -j8 && make install && \
cd .. && rm -rf cmake

# Install tmux 3.1
RUN apt-get update && apt-get install -y automake autoconf pkg-config libevent-dev libncurses5-dev bison && \
apt-get clean && rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/tmux/tmux.git && \
cd tmux && git checkout tags/3.1 && ls -la && sh autogen.sh && ./configure && make -j8 && make install

# Install new paramiko (solves ssh issues)
RUN apt-add-repository universe
RUN apt-get update && apt-get install -y python3-pip python3 build-essential && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN /usr/bin/yes | pip3 install --upgrade pip
RUN /usr/bin/yes | pip3 install --upgrade virtualenv
RUN /usr/bin/yes | pip3 install --upgrade paramiko
RUN /usr/bin/yes | pip3 install --ignore-installed --upgrade numpy protobuf

RUN apt-get update \
  && apt-get install -y -qq --no-install-recommends \
    libglvnd0 \
    libgl1 \
    libglx0 \
    libegl1 \
    libxext6 \
    libx11-6 \
  && rm -rf /var/lib/apt/lists/*

# RUN apt-get install libxext-dev libX11-dev x11proto-gl-dev
# RUN apt-get install libxext-dev libx11-dev x11proto-gl-dev

# Locale
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# Install OhMyZSH
RUN apt-get update && apt-get install -y zsh && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
#RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
RUN chsh -s /usr/bin/zsh root
RUN git clone https://github.com/sindresorhus/pure /root/.oh-my-zsh/custom/pure
RUN ln -s /root/.oh-my-zsh/custom/pure/pure.zsh-theme /root/.oh-my-zsh/custom/
RUN ln -s /root/.oh-my-zsh/custom/pure/async.zsh /root/.oh-my-zsh/custom/
RUN sed -i -e 's/robbyrussell/refined/g' /root/.zshrc
RUN sed -i '/plugins=(/c\plugins=(git git-flow adb pyenv tmux)' /root/.zshrc

# # Terminator Config
# RUN mkdir -p /root/.config/terminator/
# COPY assets/terminator_config /root/.config/terminator/config 
# COPY assets/terminator_background.png /root/.config/terminator/background.png

# Install ROS
RUN apt-get update -q && \
    apt-get upgrade -yq && \
    apt-get install -yq wget curl git build-essential vim sudo lsb-release locales bash-completion
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -k https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | sudo apt-key add -
RUN apt-get update -q && \
    apt-get install -y ros-melodic-desktop-full python-rosdep &&\
    rm -rf /var/lib/apt/lists/*
RUN rosdep init
RUN locale-gen en_US.UTF-8
RUN useradd -m -d /home/ubuntu ubuntu -p `perl -e 'print crypt("ubuntu", "salt"),"\n"'` && \
    echo "ubuntu ALL=(ALL) ALL" >> /etc/sudoers
# USER ubuntu
WORKDIR /home/ubuntu
ENV HOME=/home/ubuntu \
    CATKIN_SHELL=bash
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8
RUN rosdep update
RUN mkdir -p ~/catkin_ws/src \
    && /bin/bash -c '. /opt/ros/melodic/setup.bash; catkin_init_workspace $HOME/catkin_ws/src' \
    && /bin/bash -c '. /opt/ros/melodic/setup.bash; cd $HOME/catkin_ws; catkin_make'
RUN echo 'source /opt/ros/melodic/setup.bash' >> ~/.bashrc \
    && echo 'source ~/catkin_ws/devel/setup.bash' >> ~/.bashrc

RUN cd ~/
RUN mkdir -p ~/projects/

# Launch terminator
CMD ["terminator"]
