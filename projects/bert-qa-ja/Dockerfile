FROM nvidia/cuda:10.2-cudnn7-runtime AS base

# Avoid asking time zone settings during the build
# https://askubuntu.com/questions/909277/avoiding-user-interaction-with-tzdata-when-installing-certbot-in-a-docker-contai
ARG DEBIAN_FRONTEND=noninteractive

ARG PYTHON_VER=3.9

# Work directory is used to mount a local directory
ARG WORK_DIR=/work

ARG APP_DIR=/opt/app
ARG VENV_DIR=${APP_DIR}/venv
RUN mkdir ${APP_DIR} && mkdir ${VENV_DIR}

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    curl \
    vim \
    # Prerequisite for python3.9
    software-properties-common \ 
    locales \
    && localedef -f UTF-8 -i ja_JP ja_JP.UTF-8 \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get install -y python${PYTHON_VER} python3-pip python${PYTHON_VER}-dev python${PYTHON_VER}-venv \
    && ln -s /usr/bin/python${PYTHON_VER} /usr/bin/python \
    && rm -rf /var/lib/apt/lists/*

ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja_JP
ENV LC_ALL ja_JP.UTF-8
ENV TZ JST-9

# Install poetry and make it work with Python${PYTHON_VER} (linked to /usr/bin/python)
RUN python -m pip install poetry
ENV POETRY_VIRTUALENVS_PATH=${VENV_DIR}

### Dev stage ###
FROM base AS dev

ARG ENTRYPOINT=/usr/local/bin/entrypoint.sh
COPY entrypoint.sh ${ENTRYPOINT}
RUN chmod +x ${ENTRYPOINT}
# Note: Cannot use ARG in ENTRYPOINT (because ARG is an argument for build, not for the image...)
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

### Prod stage ###
FROM base AS prod

COPY ./bert_qa_ja ${APP_DIR}/
COPY ./pyproject.toml ${APP_DIR}
COPY ./poetry.lock ${APP_DIR}

WORKDIR ${APP_DIR}
RUN poetry install

# Install google cloud sdk
# https://github.com/GoogleCloudPlatform/cloudml-samples/blob/master/pytorch/containers/quickstart/mnist/Dockerfile-gpu
RUN wget -nv \
    https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz && \
    mkdir /root/tools && \
    tar xvzf google-cloud-sdk.tar.gz -C /root/tools && \
    rm google-cloud-sdk.tar.gz && \
    /root/tools/google-cloud-sdk/install.sh --usage-reporting=false \
    --path-update=false --bash-completion=false \
    --disable-installation-options && \
    rm -rf /root/.config/* && \
    ln -s /root/.config /config && \
    # Remove the backup directory that gcloud creates
    rm -rf /root/tools/google-cloud-sdk/.install/.backup

# Path configuration
ENV PATH $PATH:/root/tools/google-cloud-sdk/bin
# Make sure gsutil will use the default service account
RUN echo '[GoogleCompute]\nservice_account = default' > /etc/boto.cfg
