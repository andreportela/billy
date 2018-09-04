FROM python:3.6.5-alpine3.7
MAINTAINER André Portela <portela.eng@gmail.com>

ENV BASE_FOLDER /app

ENV DJANGO_PROJECT_NAME project

RUN mkdir ${BASE_FOLDER}

COPY postgres_ready.py /

COPY requirements.txt requirements_test.txt ${BASE_FOLDER}/

RUN apk update && \
    apk upgrade && \
    apk add --no-cache --virtual postgres-build-deps \
        gcc=6.4.0-r5 \
        musl-dev=1.1.18-r3 \
        libffi-dev=3.2.1-r4 \
        python3-dev=3.6.5-r0 && \
    apk add --no-cache postgresql-dev=10.5-r0 && \
    pip3 install --upgrade pip && \
    pip3 install --no-cache-dir -r ${BASE_FOLDER}/requirements.txt && \
    pip3 install --no-cache-dir -r ${BASE_FOLDER}/requirements_test.txt && \
    apk del postgres-build-deps && \
    rm -rf /var/cache/apk/* && \
    addgroup -S django && \
    adduser -D -H -S django django && \
    chown -R django:django ${BASE_FOLDER} && \
    chmod +x /postgres_ready.py

WORKDIR ${BASE_FOLDER}
