Build docker
docker build -t ros_nvidia_image .

connect docker to outside

docker run -it --name gazebo_env --gpus=all --shm-size 8G -p 8888:8888 -p 5000:5000 -p 80:80 -p 11371:11371 -p 22:22 --env="DISPLAY" --env="QT_X11_NO_MITSHM=1" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" ros_nvidia_image /bin/bash

docker exec -it --user root gazebo_env /bin/bash

export ROS_MASTER_URI=http://localhost:11371/
Inside docker 

git clone https://github.com/opencv/opencv.git && git clone https://github.com/opencv/opencv_contrib.git && cd opencv && mkdir build && cd build
 
cmake .. -D BUILD_opencv_java=OFF -D BUILD_opencv_python=0  -D BUILD_opencv_python2=0 -D BUILD_opencv_python3=0 -DOPENCV_EXTRA_MODULES_PATH= ../../opencv_contrib/modules/ -D OPENCV_ENABLE_NONFREE=1

eval `ssh-agent -s`
chmod 700 ~/.ssh
chmod 600 .ssh/id_rsa.pub
chmod 600 .ssh/id_rsa
ssh-add ~/.ssh/id_rsa


Done. The new package has been installed and saved to

 /home/ubuntu/projects/opencv/build/opencv_4.5.2-1_amd64.deb

 You can remove it from your system anytime using: 

      dpkg -r opencv

# because I login as root so no need sudo in here:
# original : http://gazebosim.org/tutorials?tut=install_from_source&cat=install
sudo sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'

wget https://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
sudo apt-get update

wget https://raw.githubusercontent.com/ignition-tooling/release-tools/master/jenkins-scripts/lib/dependencies_archive.sh -O /tmp/dependencies.sh
GAZEBO_MAJOR_VERSION=9 ROS_DISTRO=melodic . /tmp/dependencies.sh
echo $BASE_DEPENDENCIES $GAZEBO_BASE_DEPENDENCIES | tr -d '\\' | xargs sudo apt-get -y install

# Main repository
sudo apt-add-repository ppa:dartsim
sudo apt-get update
sudo apt-get -y install libdart6-dev

# Optional DART utilities
sudo apt-get -y install libdart6-utils-urdf-dev

sudo apt-get -y install xsltproc

 Done. The new package has been installed and saved to

 /home/ubuntu/projects/gazebo/build/gazebo_9-1_amd64.deb

 You can remove it from your system anytime using: 

      dpkg -r gazebo


open image inside docker
in host/local machine (not inside docker)

xhost +local: $containerId
  example: xhost +local:8b54c57085fc
docker start $containerId
docker exec -it --user root $containerId /bin/bash

in side docker: run progame with cv2::imshow(someimg)

curl -sSL http://get.gazebosim.org | sh

# revoke 
xhost -local:root