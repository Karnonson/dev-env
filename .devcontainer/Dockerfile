# syntax=docker/dockerfile:1.7

FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04 AS base

ENV DEBIAN_FRONTEND=noninteractive \
    DEVCONTAINER_PROFILE=base

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash-completion \
        bubblewrap \
        build-essential \
        ca-certificates \
        curl \
        git \
        jq \
        less \
        pkg-config \
        shellcheck \
        socat \
        unzip \
        yamllint \
    && rm -rf /var/lib/apt/lists/*