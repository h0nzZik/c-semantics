ARG BASE
From ${BASE}

# Install K dependencies
ARG DISTRO
COPY ./scripts/${DISTRO}-install-k-dependencies.sh /app/scripts/kdeps.sh
RUN /app/scripts/kdeps.sh

# The root of everything
ENV APP_ROOT /app
WORKDIR /app

# Configuration files
COPY ./scripts/settings.sh /app/scripts/settings.sh
ENV SETTINGS /app/scripts/settings.sh

# Install K
COPY ./scripts/install_k.sh /app/scripts/install_k.sh
RUN /app/scripts/install_k.sh

# Prepare environment (ocaml, K etc)
COPY ./scripts/env.sh /app/scripts/env.sh
RUN echo "source /app/scripts/env.sh" >> ~/.bashrc

