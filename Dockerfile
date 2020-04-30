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
RUN apt-get update && apt-get install -y xvfb \
    xfonts-100dpi \
    xfonts-75dpi \
    xfonts-cyrillic \
    zip \
    unzip \
    python \
    imagemagick \
    wget \
    subversion

# Configure neurodebian repo
RUN wget -O- http://neuro.debian.net/lists/trusty.us-tn.full | sudo tee /etc/apt/sources.list.d/neurodebian.sources.list
RUN apt-key adv --recv-keys --keyserver hkp://pgp.mit.edu:80 0xA5D32F012649A5A9

# Install mrtrix and ants
RUN apt-get update && apt-get install -y \
  mrtrix \
  ants

# Add mrtrix and ants to the system path
ENV PATH /usr/lib/ants:/usr/lib/mrtrix/bin:$PATH

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
