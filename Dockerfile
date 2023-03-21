FROM kasmweb/core-ubuntu-focal:1.12.0
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386 \
    && apt-get update -yq \
    && apt-get install -yq --no-install-recommends \
        curl xz-utils libc6:i386 libdbus-1-3 libasound2 libsm6 libxfixes3 \
        libdbus-1-3:i386 libasound2:i386 libexpat1:i386 libfontconfig1:i386 \
        libfreetype6:i386 libjpeg62:i386 libpng12-0:i386 libsm6:i386 \
        libxdamage1:i386 libxext6:i386 libxfixes3:i386 libxinerama1:i386 \
        libxrandr2:i386 libxrender1:i386 libxtst6:i386 zlib1g:i386 \
    && curl -fSL -o /tmp/teamviewer_i386.tar.xz "http://download.teamviewer.com/download/teamviewer_i386.tar.xz" \
    && tar xf /tmp/teamviewer_i386.tar.xz -C /opt/ \
    && rm /tmp/teamviewer_i386.tar.xz \
    && rm -rf /var/lib/apt/lists/*

VOLUME ["/tmp/.X11-unix"]

RUN echo "/usr/bin/desktop_ready && /opt/teamviewer/teamviewer &" > $STARTUPDIR/custom_startup.sh \
&& chmod +x $STARTUPDIR/custom_startup.sh

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000
