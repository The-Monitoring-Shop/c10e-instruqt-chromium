ARG BASE_IMAGE="c10e-instruqt-core"
ARG BASE_TAG="latest"
FROM themonitoringshop/$BASE_IMAGE:$BASE_TAG

USER root

ENV HOME=/home/kasm-default-profile
ENV STARTUPDIR=/dockerstartup
ENV INST_SCRIPTS=$STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

# Update the desktop environment to be optimized for a single application
RUN cp $HOME/.config/xfce4/xfconf/single-application-xfce-perchannel-xml/* $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/
RUN cp /usr/share/backgrounds/bg_kasm.png /usr/share/backgrounds/bg_default.png
RUN apt-get remove -y xfce4-panel

# Security modifications
COPY ./src/ubuntu/install/misc/single_app_security.sh $INST_SCRIPTS/misc/
RUN  bash $INST_SCRIPTS/misc/single_app_security.sh -t && rm -rf $INST_SCRIPTS/misc/

# Install Custom Certificate Authority
# COPY ./src/ubuntu/install/certificates $INST_SCRIPTS/certificates/
# RUN bash $INST_SCRIPTS/certificates/install_ca_cert.sh && rm -rf $INST_SCRIPTS/certificates/

ENV KASM_RESTRICTED_FILE_CHOOSER=1
COPY ./src/ubuntu/install/gtk/ $INST_SCRIPTS/gtk/
RUN bash $INST_SCRIPTS/gtk/install_restricted_file_chooser.sh

###############################################################################
###############################################################################
# Chronosphere modification

COPY ./src/ubuntu/install/misc/vnc_startup.sh $STARTUPDIR/
RUN chmod +x $STARTUPDIR/vnc_startup.sh

COPY ./src/ubuntu/install/chromium/custom_startup.sh $STARTUPDIR/custom_startup.sh
RUN chmod +x $STARTUPDIR/custom_startup.sh

COPY ./src/ubuntu/install/extensions /home/kasm-user/extensions/
RUN chown -R 1000:0 /home/kasm-user/extensions/

COPY ./src/common/chrome-managed-policies /etc/chromium/policies/managed/

# Setup the custom startup script that will be invoked when the container starts
# ENV LAUNCH_URL=https://university.chronosphere.io

### Install common tools
# COPY ./src/ubuntu/install/misc/install_tools.sh $INST_SCRIPTS/misc/
# RUN bash $INST_SCRIPTS/misc/install_tools.sh && rm -rf $INST_SCRIPTS/misc/

# Install Chromium
COPY ./src/ubuntu/install/chromium $INST_SCRIPTS/chromium/
RUN bash $INST_SCRIPTS/chromium/install_chromium.sh && rm -rf $INST_SCRIPTS/chromium/

###############################################################################
###############################################################################

######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME=/home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000
