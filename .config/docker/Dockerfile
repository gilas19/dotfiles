# Base Image: Start with Debian Bookworm Slim
FROM debian:bookworm-slim

# System Setup
ARG type
ARG py_ver

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    gnupg2 \
    lsb-release \
    software-properties-common \
    vim \
    build-essential \ 
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# C/C++ Development Environment (Conditional)
RUN if [ "$type" = "gcc" ]; then \
    apt-get install -y --no-install-recommends \
        gcc \
        g++ \
        gdb \
        make \
        valgrind \
        && rm -rf /var/lib/apt/lists/* \
    ; fi

# Python Data Science Environment (Conditional)
RUN if [ "$type" = "python" ]; then \
    apt-get install -y --no-install-recommends \
        python${py_ver} \
        && rm -rf /var/lib/apt/lists/* \
    ; fi


# Install Python Dependencies (Conditional)
RUN if [ "$type" = "python" ]; then \
    if [ -f requirements.txt ]; then pip install --upgrade pip && pip install -r requirements.txt; fi \
    ; fi

# Clean Up
RUN apt-get clean
