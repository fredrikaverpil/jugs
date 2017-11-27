FROM centos:7

# Add gcsfuse repo
RUN echo $'[gcsfuse] \n\
name=gcsfuse (packages.cloud.google.com) \n\
baseurl=https://packages.cloud.google.com/yum/repos/gcsfuse-el7-x86_64 \n\
enabled=1 \n\
gpgcheck=1 \n\
repo_gpgcheck=1 \n\
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg \n\
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg' > /etc/yum.repos.d/gcsfuse.repo

RUN \
    yum update -y && \
    yum install -y gcsfuse && \
    yum install -y wget tree bzip2

# gsutil rsync issue: unicode errors
# https://github.com/GoogleCloudPlatform/gsutil/issues/221#issuecomment-165353957
ENV LANG=en_US.UTF-8

# CentOS 7 issue: Default locale is set to en_US.UTF-8 but it's missing
# https://github.com/CentOS/sig-cloud-instance-images/issues/71#issuecomment-266959225
# RUN yum reinstall -y glibc-common
RUN localedef -i en_US -f UTF-8 en_US.UTF-8

# Test the LANG variable
# Expected output: ('en_US', 'UTF-8')
# RUN python -c "import locale; print locale.getdefaultlocale()"

RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    bash ~/miniconda.sh -b -p /root/miniconda

ENV PATH=/root/miniconda/bin:$PATH

RUN conda config --add channels conda-forge && \
    conda create -y -n jugs python=3.6 jupyter pandas numpy scipy plotly

ENV PATH=/root/miniconda/envs/jugs/bin:$PATH

RUN curl -sSL https://sdk.cloud.google.com | bash

ENV PATH=$PATH:/root/google-cloud-sdk/bin

# Trick to keep the container running
CMD ["tail", "-f", "/dev/null"]
