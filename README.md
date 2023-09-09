# docker-electrum-daemon

[![](https://images.microbadger.com/badges/image/osminogin/electrum-daemon.svg)](https://microbadger.com/images/osminogin/electrum-daemon) [![License: MIT](https://img.shields.io/badge/License-MIT-black.svg)](https://opensource.org/licenses/MIT)


**Electrum client running as a daemon in docker container with JSON-RPC enabled.**

[Electrum client](https://electrum.org/) is light bitcoin wallet software operates through supernodes (Electrum server instances actually).

Don't confuse with [Electrum server](https://github.com/spesmilo/electrum-server) that use bitcoind and full blockchain data.

Star this project on Docker Hub :star2: https://hub.docker.com/r/osminogin/electrum-daemon/

### Ports

* `7000` - JSON-RPC port.

### Volumes

* `/data` - user data folder (on host it usually has a path ``/home/user/.electrum``).


## Getting started

#### docker-compose

[docker-compose.yml](https://github.com/osminogin/docker-electrum-daemon/blob/master/docker-compose.yml) to see minimal working setup. When running in production, you can use this as a guide.

```bash
git clone -b docker-compose-tor https://github.com/slashfast/docker-electrum-daemon.git
cd docker-electrum-daemon
docker-compose up
docker-compose exec electrum electrum daemon status
docker-compose exec electrum electrum create
docker-compose exec electrum electrum daemon load_wallet
curl --data-binary '{"id":"1","method":"listaddresses"}' http://electrum:electrumz@localhost:7000
```

:exclamation:**Warning**:exclamation:

Always link electrum daemon to containers or bind to localhost directly and not expose 7000 port for security reasons.

## API

* [Electrum protocol specs](http://docs.electrum.org/en/latest/protocol.html)
* [API related sources](https://github.com/spesmilo/electrum/blob/master/lib/commands.py)

## License

See [LICENSE](https://github.com/osminogin/docker-electrum-daemon/blob/master/LICENSE)

