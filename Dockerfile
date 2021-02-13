FROM	debian:10-slim as build

ENV	GIT_USER=""
ENV	GIT_REPO=""
ENV	GIT_COMMIT=""
ENV	GIT_ARCHIVE="https://github.com/$GIT_USER/$GIT_REPO/archive/$GIT_COMMIT.tar.gz"

ENV	PACKAGES="file checkinstall dpkg-dev dumb-init"
ENV	PACKAGES_CLEAN=""

SHELL	["/bin/bash", "-o", "pipefail", "-c"]

# Install packages
ENV	DEBIAN_FRONTEND=noninteractive
RUN	echo 'deb http://deb.debian.org/debian buster-backports main' > /etc/apt/sources.list.d/buster-backports.list
RUN	apt-get update \
&&	apt-get -y upgrade \
&&	apt-get -y --no-install-recommends install $PACKAGES \
&&	rm -rf /var/lib/apt/lists/*
RUN	apk upgrade --no-cache \
&&	apk add --no-cache $PACKAGES \

# Download source
WORKDIR	/$GIT_REPO
ADD	$GIT_ARCHIVE /
RUN	tar --strip-component 1 -xzvf /$GIT_COMMIT.tar.gz && rm /$GIT_COMMIT.tar.gz

# Copy root filesystem
COPY	rootfs /

# do stuff
ARG     MAKEFLAGS=""
RUN	make

# Create debian package with checkinstall
ENV	APP="foo"
ENV	MAINTAINER="casperklein@docker-foo-builder"
ENV	GROUP="admin"
ARG	VERSION
RUN	echo 'Foo is a nice app which does great things' > description-pak \
&&	checkinstall -y --install=no			\
			--pkgname=$APP			\
			--pkgversion=$VERSION		\
			--maintainer=$MAINTAINER	\
			--pkggroup=$GROUP

# Move debian package to /mnt on container start
CMD	mv ${APP}_*.deb /mnt

# Cleanup
RUN	apt-get -y purge $PACKAGES_CLEAN \
&&	apt-get -y autoremove
RUN	apk del $PACKAGES_CLEAN

# Build final image
# cat Dockerfile | grep -i -e ^CMD -e ^ENTRYPOINT -e ^ENV -e ^EXPOSE -e ^HEALTHCHECK -e ^LABEL -e ^VOLUME -e ^WORKDIR | sort
# cat Dockerfile | grep -iv -e '^$' -e '^#' -e '^&&' -e ^ADD -e ^ARG -e ^COPY -e ^FROM -e ^RUN -e ^SHELL | sort
# docker inspect XXX | jq '.[].Config | {Cmd, Entrypoint, Env, ExposedPorts, Healthcheck, Labels, Volumes, WorkingDir}'
FROM	scratch

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD	["/run.sh"]

EXPOSE	80

HEALTHCHECK --interval=30s --timeout=3s --retries=1 CMD bash -c '</dev/tcp/127.0.0.1/80' || exit 1 # Must only return 0 or 1
HEALTHCHECK --interval=30s --timeout=3s --retries=1 CMD curl -f -A 'Docker: Health-Check' http://127.0.0.1/ || exit 1 # Must only return 0 or 1
# docker inspect CONTAINER | jq -r '.[].State.Health.Status'

COPY	--from=build / /
