###########
# BUILDER #
###########

# Base Image
FROM python:3.10 as builder
# TOKEN is for github authentification usage
ARG TOKEN
ARG project='docker_cli_demo'

RUN apt-get update && \
    apt-get -y install sudo curl && \
    mkdir /root/${project} && \
    apt-get -y install git

COPY ${project} /root/${project}/${project}
COPY pyproject.toml /root/${project}/


RUN python -m pip install --upgrade pip && \
    pip install poetry && \
    # for poetry to communicate with git
    git config --global --add url."https://${TOKEN}:x-oauth-basic@github.com/".insteadOf "https://github.com/" && \
    cd /root/${project} && poetry install && mkdir /wheels && \
    poetry export -f requirements.txt --without-hashes > requirements.txt && \
    # dependencies
    pip wheel --no-cache-dir --no-deps --wheel-dir /wheels -r requirements.txt && \
    # current project build
    poetry build && cp /root/${project}/dist/*.whl /wheels


#########
# FINAL #
#########

# Base Image
FROM python:3.10-slim
MAINTAINER wluo-personal "luoweiforever@gmail.com"

# Install lib required
RUN apt-get update && \
    apt-get -y install sudo vim libpq-dev && \
    # for lightgbm, will remove later
    apt-get install libgomp1

# Set timezone
ENV TZ=America/New_York



# Install Requirements
COPY  --from=builder /wheels /wheels
COPY  --from=builder /etc/localtime /etc/localtime
COPY  --from=builder /etc/timezone /etc/timezone

RUN apt-get update && \
    apt-get -y install git && \
    pip install --upgrade pip && pip install --no-cache --no-deps /wheels/*

WORKDIR /root

# Change to the app user
ENTRYPOINT ["cli"]
CMD ["--help"]