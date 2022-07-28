FROM python:3.7.11-slim-stretch as base

RUN apt-get update \
    && apt-get -y install git python3-pip python3-dev tzdata \
    && rm -rf /var/lib/apt/lists/*

ENV WHEEL_DIR=/svc/wheels

COPY requirements.txt /
RUN pip3 install wheel \
  && pip3 wheel --requirement /requirements.txt --wheel-dir=${WHEEL_DIR}

FROM python:3.7.11-slim-stretch as prod

COPY --from=base /svc /svc

RUN apt-get update \
    && apt-get -y install git kbtin software-properties-common network-manager python3-pip\
    #add public key for the multiverse repo which has nikto
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32 \
    && add-apt-repository 'deb http://archive.ubuntu.com/ubuntu bionic multiverse' \
    && add-apt-repository 'deb http://archive.ubuntu.com/ubuntu bionic-security multiverse' \
    && add-apt-repository 'deb http://archive.ubuntu.com/ubuntu bionic-updates multiverse' \
    && apt-get update -y \
    && apt-get install -y nikto \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install --no-index /svc/wheels/* \
    && rm -rf /svc 
