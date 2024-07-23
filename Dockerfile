FROM	debian:12-slim as build

ARG	GITHUB_USER=""
ARG	GITHUB_REPO=""
ARG	GITHUB_COMMIT=""
ARG	GITHUB_ARCHIVE="https://github.com/$GITHUB_USER/$GITHUB_REPO/archive/$GITHUB_COMMIT.tar.gz"

ARG	PACKAGES="file checkinstall dpkg-dev dumb-init"
ARG	PACKAGES_CLEAN=""

SHELL	["/bin/bash", "-o", "pipefail", "-c"]

# Install packages
ARG	DEBIAN_FRONTEND=noninteractive
#RUN	echo 'deb http://deb.debian.org/debian buster-backports main' > /etc/apt/sources.list.d/buster-backports.list
RUN	apt-get update \
&&	apt-get -y upgrade \
&&	apt-get -y --no-install-recommends install $PACKAGES \
&&	rm -rf /var/lib/apt/lists/*
RUN	apk upgrade --no-cache \
&&	apk add --no-cache $PACKAGES

# Download source
WORKDIR	/$GITHUB_REPO
ADD	$GITHUB_ARCHIVE /
RUN	tar --strip-component 1 -xzvf /$GITHUB_COMMIT.tar.gz && rm /$GITHUB_COMMIT.tar.gz
# Get source
WORKDIR	/$GITHUB_REPO
RUN	wget -O - "$GITHUB_ARCHIVE" | tar --strip-component 1 -xzv


# Copy root filesystem
COPY	rootfs /

# do stuff
ARG	MAKEFLAGS=""
RUN	make

# Create debian package with checkinstall
ARG	APP="foo"
ARG	GROUP="admin"
ARG	MAINTAINER="casperklein@docker-foo-builder"
ARG	VERSION="unknown"
RUN	echo 'Foo is a nice app which does great things' > description-pak \
# fstrans=no since debian12 -->  https://bugs.launchpad.net/ubuntu/+source/checkinstall/+bug/976380
&&	checkinstall -y --fstrans=no             \
			--install=no             \
			--pkgname=$APP           \
			--pkgversion=$VERSION    \
			--maintainer=$MAINTAINER \
			--pkggroup=$GROUP

# Move debian package to /mnt on container start
CMD	mv ${APP}_*.deb /mnt

# Cleanup
RUN	apt-get -y purge $PACKAGES_CLEAN \
&&	apt-get -y autoremove
RUN	apk del $PACKAGES_CLEAN

# Build final image
# cat Dockerfile | grep -i -e ^ARG -e ^CMD -e ^ENTRYPOINT -e ^ENV -e ^EXPOSE -e ^HEALTHCHECK -e ^LABEL -e ^VOLUME -e ^WORKDIR | sort
# cat Dockerfile | grep -iv -e '^$' -e '^#' -e '^&&' -e ^ADD -e ^ARG -e ^COPY -e ^FROM -e ^RUN -e ^SHELL | sort
# docker inspect XXX | jq '.[].Config | {Cmd, Entrypoint, Env, ExposedPorts, Healthcheck, Labels, Volumes, WorkingDir}'
FROM	scratch

ARG	VERSION="unknown"

LABEL	org.opencontainers.image.description="Just a template"
LABEL	org.opencontainers.image.source="https://github.com/casperklein/docker-template/"
LABEL	org.opencontainers.image.title="docker-template"
LABEL	org.opencontainers.image.version="$VERSION"

ENTRYPOINT ["dumb-init", "--"]
CMD	["/run.sh"]

EXPOSE	80

HEALTHCHECK --interval=30s --timeout=3s --retries=1 CMD bash -c '</dev/tcp/127.0.0.1/80' || exit 1 # Must only return 0 or 1
HEALTHCHECK --interval=30s --timeout=3s --retries=1 CMD curl -f -A 'Docker: Health-Check' http://127.0.0.1/ || exit 1 # Must only return 0 or 1
# docker inspect CONTAINER | jq -r '.[].State.Health.Status'

COPY	--from=build / /
