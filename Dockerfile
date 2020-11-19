ARG FROM=eventdrivenrobotics/yarp:focal_v3.4.1_opengl

FROM $FROM

ARG SOURCE_FOLDER=/usr/local/src
ARG GAZEBO_YARP_PLUGINS_BRANCH=v3.5.0
ARG ICUB_MAIN_VERSION=1.17.0

RUN apt update && \
	apt install -y \
	curl \
	git \
	gnupg2 \
     coinor-libipopt-dev \
     openssh-server \
     openssh-client \
     && apt-get autoremove \
     && apt-get clean \
     && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*


RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list && \
     wget https://packages.osrfoundation.org/gazebo.key -O - | apt-key add - && \
     apt update && \
     apt install -y \
     gazebo9 \
     libgazebo9-dev \
     && apt-get autoremove \
     && apt-get clean \
     && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

RUN cd $SOURCE_FOLDER && \
     git clone https://github.com/robotology/icub-main.git && \
     cd icub-main && \
     git checkout v$ICUB_MAIN_VERSION && \
     mkdir build && \
     cd build/ && \
     cmake .. -DENABLE_icubmod_cartesiancontrollerclient=ON \
              -DENABLE_icubmod_cartesiancontrollerserver=ON \
              -DENABLE_icubmod_gazecontrollerclient=ON && \
     make -j `nproc` install

RUN cd $SOURCE_FOLDER && \
     git clone https://github.com/robotology/gazebo-yarp-plugins.git && \
     cd gazebo-yarp-plugins && \
     git checkout $GAZEBO_YARP_PLUGINS_BRANCH && \
     mkdir build && \
     cd build/ && \
     cmake .. && \
     make -j `nproc` install

RUN cd $SOURCE_FOLDER && \
     git clone https://github.com/robotology/icub-models.git && \
     cd icub-models && \
     git checkout v$ICUB_MAIN_VERSION && \
     mkdir build && \
     cd build/ && \
     cmake .. && \
     make -j `nproc` install

COPY models /usr/local/share/models
COPY worlds /usr/local/share/worlds
ENV GAZEBO_MODEL_PATH /usr/local/share/:/usr/local/share/models

COPY actionsRenderingEngineGazebo.xml /usr/local/share/yarp/applications/
