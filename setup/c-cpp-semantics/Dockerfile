ARG DISTRO=debian
From h0nzzik/kframework-${DISTRO}

ENV SCRIPTS /app/scripts
ENV SETTINGS /app/scripts/settings.sh

# Clang
COPY ./scripts/install-clang.sh /app/scripts/
RUN /app/scripts/install-clang.sh

# C/C++ semantics
COPY ./scripts/install-c-cpp-semantics.sh /app/scripts/
RUN /app/scripts/install-c-cpp-semantics.sh

RUN echo "Hello world"
