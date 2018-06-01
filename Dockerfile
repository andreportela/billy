FROM python:3.6.5-alpine3.7
MAINTAINER André Portela <portela.eng@gmail.com>

ENV BASE_FOLDER /app

ENV DJANGO_PROJECT_NAME project

RUN mkdir ${BASE_FOLDER}

COPY requirements.txt postgres_ready.py ${BASE_FOLDER}/

RUN apk update && \
    apk upgrade && \
    apk add --no-cache --virtual postgres-build-deps \
        gcc=6.4.0-r5 \
        musl-dev=1.1.18-r3 \
        libffi-dev=3.2.1-r4 \
        python3-dev=3.6.3-r9 && \
    apk add --no-cache postgresql-dev=10.4-r0 && \
    pip3 install --no-cache-dir -r ${BASE_FOLDER}/requirements.txt && \
    apk del postgres-build-deps && \
    rm -rf /var/cache/apk/* && \
    addgroup -S django && \
    adduser -D -H -S django django && \
    chown -R django:django ${BASE_FOLDER} && \
    chmod +x ${BASE_FOLDER}/postgres_ready.py

WORKDIR ${BASE_FOLDER}
