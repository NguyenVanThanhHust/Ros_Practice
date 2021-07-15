Build docker
docker build -t ros_cuda_image .

connect docker to outside

docker run -it --name ros_container --shm-size 8G -p 8888:8888 -p 5000:5000 --env="DISPLAY" --env="QT_X11_NO_MITSHM=1" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" ros_cuda_image /bin/bash

