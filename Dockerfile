FROM	debian:10-slim as build

ENV	GIT_USER=""
ENV	GIT_REPO=""
ENV	GIT_COMMIT=""
ENV	GIT_ARCHIVE="https://github.com/$GIT_USER/$GIT_REPO/archive/$GIT_COMMIT.tar.gz"

ENV	PACKAGES="file checkinstall dpkg-dev"
ENV	PACKAGES_CLEAN=""

SHELL	["/bin/bash", "-o", "pipefail", "-c"]

# Install packages
ENV	DEBIAN_FRONTEND=noninteractive
RUN	echo 'deb http://deb.debian.org/debian buster-backports main' > /etc/apt/sources.list.d/buster-backports.list
RUN	apt-get update \
&&	apt-get -y upgrade \
&&	apt-get -y install $PACKAGES
#&&	apt-get -y --no-install-recommends install $PACKAGES

# Download source
#WORKDIR	/$GIT_REPO
#ADD	$GIT_ARCHIVE /
#RUN	tar --strip-component 1 -xzvf /$GIT_COMMIT.tar.gz && rm /$GIT_COMMIT.tar.gz

# Copy root filesystem
COPY	rootfs /

# do stuff
# add/copy/run something

# Create debian package with checkinstall
RUN	echo 'Foo is a nice app which does great things' > description-pak
ENV	APP="foo"
ARG	VERSION
ENV	MAINTAINER="casperklein@docker-foo-builder"
ENV	GROUP="admin"
RUN	checkinstall -y --install=no			\
			--pkgname=$APP			\
			--pkgversion=$VERSION		\
			--maintainer=$USER@$NAME	\
			--pkggroup=$GROUP

# Move tmux debian package to /mnt on container start
CMD	mv ${APP}_$VERSION$TMUX_DEV-1_*.deb /mnt

# Cleanup
RUN	apt-get -y purge $PACKAGES_CLEAN \
&&	apt -y autoremove

# Build final image
# cat Dockerfile | grep -i -e CMD -e ENTRYPOINT -e ENV -e EXPOSE -e LABEL -e VOLUME -e WORKDIR | sort
# cat Dockerfile | grep -i -v -e ^$ -e ADD -e COPY -e FROM -e RUN -e SHELL | sort
# docker inspect XXX | jq '.[].Config | {Entrypoint,Cmd,Env,WorkingDir,Labels,ExposedPorts,Healthcheck}'
RUN	apt-get -y install dumb-init \
&&	rm -rf /var/lib/apt/lists/*
FROM	scratch

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD	["/run.sh"]

#EXPOSE	80

#HEALTHCHECK --interval=30s --timeout=3s --retries=1 CMD bash -c '</dev/tcp/127.0.0.1/80' || exit 1 # Must only return 0 or 1
#HEALTHCHECK --interval=30s --timeout=3s --retries=1 CMD curl -f -A 'Docker: Health-Check' http://127.0.0.1/ || exit 1 # Must only return 0 or 1

COPY	--from=build / /
