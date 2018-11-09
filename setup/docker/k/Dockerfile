From fedora:29

# Updated system
RUN dnf update -y

# Very basic packages
RUN dnf install -y sudo git vim gcc make cmake

# K dependencies
RUN dnf install -y libxml2-devel mpfr-devel gmp-devel java-1.8.0-openjdk z3 z3-devel flex maven python3 libffi-devel

# K ocaml backend dependencies
RUN dnf install -y ocaml opam

# The root of everything
ENV APP_ROOT /app

COPY ./scripts/settings.sh /app/scripts/settings.sh
ENV SETTINGS /app/scripts/settings.sh

COPY ./scripts/install_k.sh /app/scripts/install_k.sh
RUN /app/scripts/install_k.sh

COPY ./scripts/env.sh /app/scripts/env.sh

WORKDIR /app

RUN echo "source /app/scripts/env.sh" >> ~/.bashrc
#ENTRYPOINT bash --init-file /app/scripts/env.sh

#COPY ./scripts /app/scripts

#ENV SCRIPTS /app/scripts




# RUN /app/bootstrap.sh
