# Copyright (c) 2022 Open Technologies for Integration
# Licensed under the MIT license (see LICENSE for details)
#
# docker build -t ace-shared-classes .
# 
# docker run -e LICENSE=accept --rm -ti ace-shared-classes:latest
#

# See https://github.com/ot4i/ace-docker#pre-built-containers for other versions
FROM cp.icr.io/cp/appc/ace:12.0.6.0-r1
LABEL "maintainer"="trevor.dolby@ibm.com"

# Copy in and deploy the demo application into the work directory
#
# Note that trivial application builds would generally be expected to have
# unit tests, and we skip this here because this demo is intended to show
# Java shared classes usage.
WORKDIR /tmp/build-dir
ADD --chown=aceuser DemoApplication /tmp/build-dir/DemoApplication
ADD --chown=aceuser DemoApplicationJava /tmp/build-dir/DemoApplicationJava
RUN bash -c "export LICENSE=accept && \
             . /opt/ibm/ace-12/server/bin/mqsiprofile && \
             ibmint deploy --input-path /tmp/build-dir \
                           --output-work-directory /home/aceuser/ace-server \
                           --project DemoApplicationJava \
                           --project DemoApplication"

# Copy the pre-built shared JAR file into place
RUN mkdir /home/aceuser/ace-server/shared-classes
COPY SharedJava.jar /home/aceuser/ace-server/shared-classes/

# The base image already has the server set to start automatically