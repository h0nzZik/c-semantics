ARG DISTRO=debian
From h0nzzik/kframework-${DISTRO}

ARG DISTRO=debian
COPY ./src/deps-${DISTRO}.sh /app/scripts/deps.sh
RUN /app/scripts/deps.sh

# C/C++ semantics
COPY ./src/install-c-cpp-semantics.sh /app/scripts/
RUN /app/scripts/install-c-cpp-semantics.sh /app

