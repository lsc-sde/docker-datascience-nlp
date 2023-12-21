ARG OWNER=vvcb
ARG BASE_CONTAINER=jupyter/minimal-notebook
FROM $BASE_CONTAINER

LABEL maintainer="vvcb"
LABEL image="datascience-nlp"

COPY ./environment.yaml environment.yaml
USER root

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    gcc build-essential && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mamba env update --quiet -f environment.yaml \
    && mamba clean --all -f -y \
    && rm environment.yaml \
    && fix-permissions "${CONDA_DIR}" \
    && fix-permissions "/home/${NB_USER}"

RUN apt-get uninstall --yes build-essential

USER ${NB_USER}