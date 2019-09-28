FROM    debian:10-slim as build

ENV	PACKAGES=""

# Install packages
RUN     apt-get update \
&&	apt-get -y install $PACKAGES
#&&	apt-get -y --no-install-recommends install $PACKAGES

# Copy root filesystem
COPY	rootfs /

# do stuff
# add/copy/run something

# Build final image
RUN	apt-get -y install dumb-init \
&&	rm -rf /var/lib/apt/lists/*
FROM	scratch
COPY	--from=build / /
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

#EXPOSE  80

CMD	["/run.sh"]
