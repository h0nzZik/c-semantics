ARG BASE
From ${BASE}

# Install K dependencies
ARG DISTRO
COPY ./src/k-deps-${DISTRO}.sh /app/scripts/k-deps.sh
RUN /app/scripts/k-deps.sh

# Install K
COPY ./src/install-k.sh /app/scripts/install-k.sh
RUN /app/scripts/install-k.sh /app/k


