FROM	debian:10-slim as build

ENV	USER="casperklein"
ENV	NAME="template"
ENV	VERSION="0.1"

ENV	PACKAGES=""
ENV	PACKAGES_CLEAN=""

SHELL	["/bin/bash", "-o", "pipefail", "-c"]

# Install packages
#ENV	DEBIAN_FRONTEND=noninteractive
RUN	apt-get update \
&&	apt-get -y upgrade \
&&	apt-get -y install $PACKAGES
#&&	apt-get -y --no-install-recommends install $PACKAGES

# Copy root filesystem
COPY	rootfs /

# do stuff
# add/copy/run something

# Cleanup
RUN	apt-get -y purge $PACKAGES_CLEAN \
&&	apt -y autoremove

# Build final image
# cat Dockerfile | grep -i -e CMD -e ENTRYPOINT -e ENV -e EXPOSE -e LABEL -e VOLUME -e WORKDIR | sort
# cat Dockerfile | grep -i -v -e ^$ -e ADD -e COPY -e FROM -e RUN -e SHELL | sort
RUN	apt-get -y install dumb-init \
&&	rm -rf /var/lib/apt/lists/*
FROM	scratch
COPY	--from=build / /
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

#EXPOSE	80
#HEALTHCHECK --retries=1 CMD curl -f -A 'Docker: Health-Check' http://127.0.0.1/ || exit 1
#HEALTHCHECK --retries=1 CMD bash -c "</dev/tcp/localhost/80"

CMD	["/run.sh"]
