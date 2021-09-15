FROM ros:kinetic-robot

ARG USER_ID=1000
ARG GROUP_ID=1000
ARG USER_NAME=robot

# Stuff added by RKJ we'll always want
RUN apt-get update && apt-get install -y \
    nano \
    iproute2 \
    git \
    iputils-ping \
    sudo \
    terminator \
    pcmanfm \
    dbus \ 
    dbus-x11 \
    unzip \
    curl \
    wget \
    python-catkin-tools \
    less

WORKDIR /opt
# Eigen
ENV EIGEN_VERSION="3.1.0"
RUN echo Eigen version $EIGEN_VERSION
RUN curl -OJ https://gitlab.com/libeigen/eigen/-/archive/${EIGEN_VERSION}/eigen-${EIGEN_VERSION}.tar.gz
RUN tar -xf eigen-${EIGEN_VERSION}.tar.gz
WORKDIR eigen-${EIGEN_VERSION}
RUN mkdir build
WORKDIR build
RUN cmake ..
RUN make install

# Open CV
ENV OPENCV_VERSION=3.3.1
WORKDIR /opt
RUN wget -O opencv-${OPENCV_VERSION}.tar.gz https://github.com/opencv/opencv/archive/refs/tags/${OPENCV_VERSION}.tar.gz
RUN tar -xf opencv-${OPENCV_VERSION}.tar.gz
WORKDIR /opt/opencv-${OPENCV_VERSION}
RUN mkdir build
WORKDIR /opt/opencv-${OPENCV_VERSION}/build
RUN cmake ..
RUN make -j
RUN make install

RUN addgroup --gid ${GROUP_ID} ${USER_NAME}
RUN adduser --uid ${USER_ID} --gid ${GROUP_ID} --disabled-password --gecos "" ${USER_NAME}

# ROS setup
#RUN apt install -y ros-kinetic-cv-bridge
ENV ROS_WS /opt/R-VIO
RUN mkdir $ROS_WS
RUN chown ${USER_NAME}:${USER_NAME} $ROS_WS

USER ${USER_NAME}
RUN mkdir -p $ROS_WS/src

WORKDIR $ROS_WS
RUN git -C src clone https://github.com/rkent/R-VIO.git

# install ros package dependencies
RUN rosdep update --rosdistro=$ROS_DISTRO

USER root
RUN rosdep install -y --from-paths src/R-VIO --ignore-src

# build ros package source
USER ${USER_NAME}
RUN catkin config --extend /opt/ros/$ROS_DISTRO
RUN catkin build
#RUN rm -r /opt/R-VIO/src/R-VIO

# remove spurious error messages
RUN mkdir -p /home/${USER_NAME}/.config/terminator
ADD assets/terminator/config /home/${USER_NAME}/.config/terminator/config
RUN mkdir -p /home/${USER_NAME}/Templates
ENV NO_AT_BRIDGE=1

# source entrypoint setup
USER root
RUN sed --in-place --expression \
      '$iif [ -f "$ROS_WS/devel/setup.bash" ]; then source "$ROS_WS/devel/setup.bash"; fi' \
      /ros_entrypoint.sh
USER ${USER_NAME}