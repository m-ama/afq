# Create Docker container that can run afq analysis.

# Start with the Matlab r2013b runtime container
FROM vistalab/mcr-v82

LABEL maintainer="Siddhartha Dhiman (dhiman@musc.edu)"
LABEL org.label-schema.schema-version="1.0.0-rc1"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="dmri/afq"
LABEL org.label-schema.description="AFQ Pipeline for Docker"
LABEL org.label-schema.url="https://github.com/m-ama/"
LABEL org.label-schema.vcs-url="https://github.com/m-ama/afq.git"
LABEL org.label-schema.vcs-ref=$VCS_REF
LABEL org.label-schema.vendor="MAMA"

# Install XVFB and other dependencies
RUN apt-get update && apt-get install -y \
    zip \
    unzip \
    python \
    imagemagick \
    wget \
    subversion \
    mrtrix \
    ants

# Install mrtrix and ants
RUN apt-get update && apt-get install -y \
  mrtrix \
  ants

# ADD the dtiInit Matlab Stand-Alone (MSA) into the container.
COPY src/bin/AFQ_StandAlone_QMR /usr/local/bin/AFQ

# ADD the control data to the container
COPY src/data/qmr_control_data.mat /opt/qmr_control_data.mat

# Ensure that the executable files are executable
RUN chmod +x /usr/local/bin/AFQ

# Handle AFQ and mrD templates via svn mad-hackery
ENV TEMPLATES /templates
RUN mkdir $TEMPLATES
RUN svn export --force https://github.com/yeatmanlab/AFQ.git/trunk/templates/ $TEMPLATES
RUN svn export --force https://github.com/vistalab/vistasoft.git/trunk/mrDiffusion/templates/ $TEMPLATES

# Add entrypoint for AFQ
ENTRYPOINT [ "AFQ" ]
