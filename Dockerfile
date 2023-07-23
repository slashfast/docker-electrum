FROM python:3.10-alpine

ARG ELECTRUM_VERSION
ARG CHECKSUM_SHA512
ARG ELECTRUM_NETWORK

LABEL maintainer="slashcooperlive@gmail.com" \
	org.label-schema.vendor="slashfast" \
	org.label-schema.name="Electrum wallet (RPC enabled)" \
	org.label-schema.description="Electrum wallet with JSON-RPC enabled (daemon mode)" \
	org.label-schema.version=$VERSION \
	org.label-schema.vcs-url="https://github.com/slashfast/docker-electrum-daemon" \
	org.label-schema.usage="https://github.com/slashfast/docker-electrum-daemon#getting-started" \
	org.label-schema.license="MIT" \
	org.label-schema.url="https://electrum.org" \
	org.label-schema.docker.cmd='docker run -d --name electrum-daemon --publish 127.0.0.1:7000:7000 --volume /srv/electrum:/data slashfast/electrum-daemon' \
	org.label-schema.schema-version="1.0"

ENV ELECTRUM_VERSION $ELECTRUM_VERSION
ENV ELECTRUM_USER electrum
ENV ELECTRUM_PASSWORD electrumz		# XXX: CHANGE REQUIRED!
ENV ELECTRUM_HOME /home/$ELECTRUM_USER
ENV ELECTRUM_NETWORK mainnet


RUN adduser -D $ELECTRUM_USER

RUN mkdir -p /data ${ELECTRUM_HOME} && \
	ln -sf /data ${ELECTRUM_HOME}/.electrum && \
	chown ${ELECTRUM_USER} ${ELECTRUM_HOME}/.electrum /data

# IMPORTANT: always verify gpg signature before changing a hash here!
ENV ELECTRUM_CHECKSUM_SHA512 $CHECKSUM_SHA512

RUN apk add libsecp256k1 && \
	apk --no-cache add --virtual build-dependencies gcc musl-dev libsecp256k1 libsecp256k1-dev libressl-dev gpg gpg-agent dirmngr && \
    wget https://download.electrum.org/${ELECTRUM_VERSION}/Electrum-${ELECTRUM_VERSION}.tar.gz && \
    wget https://download.electrum.org/${ELECTRUM_VERSION}/Electrum-${ELECTRUM_VERSION}.tar.gz.asc && \
    wget https://raw.githubusercontent.com/spesmilo/electrum/master/pubkeys/ThomasV.asc && \
    gpg --import ThomasV.asc && \
    gpg --keyserver keyserver.ubuntu.com --recv-keys 637DB1E23370F84AFF88CCE03152347D07DA627C && \
    gpg --keyserver keyserver.ubuntu.com --recv-keys 0EEDCFD5CAFB459067349B23CA9EEEC43DF911DC &&\
    gpg --verify Electrum-${ELECTRUM_VERSION}.tar.gz.asc Electrum-${ELECTRUM_VERSION}.tar.gz && \
    echo -e "**************************\n GPG VERIFIED OK\n**************************" && \
    pip3 install cryptography==40.0.2 pycryptodomex Electrum-${ELECTRUM_VERSION}.tar.gz && \
    rm -f Electrum-${ELECTRUM_VERSION}.tar.gz && \
    apk del build-dependencies

RUN mkdir -p /data \
	    ${ELECTRUM_HOME}/.electrum/wallets/ \
	    ${ELECTRUM_HOME}/.electrum/testnet/wallets/ \
	    ${ELECTRUM_HOME}/.electrum/regtest/wallets/ \
	    ${ELECTRUM_HOME}/.electrum/simnet/wallets/ && \
    ln -sf ${ELECTRUM_HOME}/.electrum/ /data && \
	chown -R ${ELECTRUM_USER} ${ELECTRUM_HOME}/.electrum /data

USER $ELECTRUM_USER
WORKDIR $ELECTRUM_HOME
VOLUME /data
EXPOSE 7000

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
# CMD ["electrum"]
