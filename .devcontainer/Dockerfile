# syntax=docker/dockerfile:1.7

FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04 AS base

ENV DEBIAN_FRONTEND=noninteractive \
    DEVCONTAINER_PROFILE=base

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash-completion \
        build-essential \
        ca-certificates \
        curl \
        git \
        jq \
        less \
        pkg-config \
        unzip \
    && rm -rf /var/lib/apt/lists/*

FROM base AS python

ENV DEVCONTAINER_PROFILE=python

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libffi-dev \
        libpq-dev \
        libssl-dev \
        sqlite3 \
    && rm -rf /var/lib/apt/lists/*

FROM base AS typescript

ENV DEVCONTAINER_PROFILE=typescript

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libgbm1 \
        libgtk-3-0 \
        libnss3 \
        xdg-utils \
    && rm -rf /var/lib/apt/lists/*

FROM base AS fullstack

ENV DEVCONTAINER_PROFILE=fullstack

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libffi-dev \
        libpq-dev \
        libssl-dev \
        sqlite3 \
        libgbm1 \
        libgtk-3-0 \
        libnss3 \
        xdg-utils \
    && rm -rf /var/lib/apt/lists/*