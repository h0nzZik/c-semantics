ARG BASE
From ${BASE}

# Install K dependencies
ARG DISTRO
COPY ./src/deps-${DISTRO}.sh /app/scripts/deps.sh
RUN /app/scripts/deps.sh

# Install K
COPY ./src/install-k.sh /app/scripts/install-k.sh
RUN /app/scripts/install-k.sh /app/k


