FROM eventdrivenrobotics/yarp:v3.3.2

ARG SOURCE_FOLDER=/usr/local/src
ARG GAZEBO_YARP_PLUGINS_BRANCH=event-driven-skin
ARG ICUB_MAIN_VERSION=1.16.0

RUN apt update && \
	apt install -y \
	curl \
	git \
	gnupg2

RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list && \
     wget https://packages.osrfoundation.org/gazebo.key -O - | apt-key add - && \
     apt update && \
     apt install -y \
     gazebo9 \
     libgazebo9-dev

RUN cd $SOURCE_FOLDER && \
     git clone https://github.com/robotology/icub-main.git && \
     cd icub-main && \
     git checkout v$ICUB_MAIN_VERSION && \
     mkdir build && \
     cd build/ && \
     cmake .. && \
     make -j 8 install

RUN cd $SOURCE_FOLDER && \
     git clone https://github.com/event-driven-robotics/gazebo-yarp-plugins.git && \
     cd gazebo-yarp-plugins && \
     git checkout $GAZEBO_YARP_PLUGINS_BRANCH && \
     mkdir build && \
     cd build/ && \
     cmake .. && \
     make -j 8 install

RUN cd $SOURCE_FOLDER && \
     git clone https://github.com/robotology/icub-gazebo.git && \
     cd icub-gazebo && \
     git remote add experimental https://github.com/xenvre/icub-gazebo.git && \
     git fetch experimental && \
     git checkout impl/fingers && \
     mkdir build && \
     cd build/ && \
     cmake .. && \
     make -j 8 install


RUN cd $SOURCE_FOLDER && \
     git clone https://github.com/xEnVrE/vision-based-manipulation-simulation.git && \
     cd vision-based-manipulation-simulation && \
     git checkout old_icub_gazebo && \
     mkdir build && \
     cd build/ && \
     cmake .. && \
     make -j 8 install
