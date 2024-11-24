ARG CONTAINER_IMAGE_REGISTRY

ARG BUILDER_CONTAINER_IMAGE=${CONTAINER_IMAGE_REGISTRY:+${CONTAINER_IMAGE_REGISTRY}/}tools-python-builder

ARG MAIN_SCRIPT_PATH=src/console/app.py

FROM ${BUILDER_CONTAINER_IMAGE} AS build

FROM ${CONTAINER_IMAGE_REGISTRY:+${CONTAINER_IMAGE_REGISTRY}/}alpine:3.20.3

COPY --from=build /var/workspace/dist/app /usr/bin/console

ARG CONTAINER_USER=default
ARG CONTAINER_USER_GROUP=default

RUN addgroup -S ${CONTAINER_USER_GROUP} \
  && adduser -S ${CONTAINER_USER} -G ${CONTAINER_USER_GROUP}

USER ${CONTAINER_USER}:${CONTAINER_USER_GROUP}

ARG PORT=80

ENV SERVICE_PORT=${PORT}

EXPOSE ${PORT}

ENTRYPOINT [ "console" ]
