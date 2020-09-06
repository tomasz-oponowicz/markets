FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    devscripts \
    # Dependencies:
    valac \
    meson \
    libgtk-3-dev \
    libglib2.0-dev \
    libhandy-0.0-dev \
    libgee-0.8-dev \
    libsoup2.4-dev \
    libjson-glib-dev \
&& rm -rf /var/lib/apt/lists/*

CMD ["/usr/bin/debuild", "-b", "-uc", "-us", "--lintian-opts", "-vi"]
WORKDIR /app

# Build:
# $ docker build -t bitstower-markets .
#
# Run:
# $ docker run --rm -v <workspace absolute path>:/app bitstower-markets
