FROM --platform=linux/amd64 debian:12-slim as builder

RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    libssl-dev \
    libpcre3-dev \
    zlib1g-dev

WORKDIR /tmp

RUN git clone https://git.suckless.org/quark

WORKDIR /tmp/quark

RUN make

RUN chmod +x quark

FROM --platform=linux/amd64 debian:12-slim as runner

COPY --from=builder /tmp/quark/quark /usr/local/bin/quark

# Define the entrypoint
ENTRYPOINT ["/usr/local/bin/quark"]

# Allow arguments to be passed to the entrypoint
CMD ["-p", "8080", "-d", "/var/www/html", "-h", "0.0.0.0"]
