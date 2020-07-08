FROM eventdrivenrobotics/yarp:v3.3.2

ARG SOURCE_FOLDER=/usr/local/src
ARG GAZEBO_YARP_PLUGINS_BRANCH=event-driven-skin
ARG ICUB_MAIN_VERSION=1.16.0

RUN apt update && \
	apt install -y \
	curl \
	git \
	gnupg2

RUN curl -sSL http://get.gazebosim.org | sh

RUN cd $SOURCE_FOLDER && \
     git clone https://github.com/event-driven-robotics/gazebo-yarp-plugins.git && \
     cd gazebo-yarp-plugins && \
     git checkout $GAZEBO_YARP_PLUGINS_BRANCH && \
     mkdir build && \
     cd build/ && \
     cmake .. && \
     make -j 8 install

RUN cd $SOURCE_FOLDER && \
     git clone https://github.com/robotology/icub-main.git && \
     cd icub-main && \
     git checkout v$ICUB_MAIN_VERSION && \
     mkdir build && \
     cd build/ && \
     cmake .. && \
     make -j 8 install

RUN cd $SOURCE_FOLDER && \
     git clone https://github.com/robotology/icub-gazebo.git && \
     cd icub-gazebo && \
     git checkout v$ICUB_MAIN_VERSION && \
     mkdir build && \
     cd build/ && \
     cmake .. && \
     make -j 8 install


RUN cd $SOURCE_FOLDER && \
     git clone https://github.com/robotology/vision-based-manipulation-simulation.git && \
     cd vision-based-manipulation-simulation && \
     mkdir build && \
     cd build/ && \
     cmake .. && \
     make -j 8 install
