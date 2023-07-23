# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- ELECTRUM_VERSION build argument to docker-compose.yml

### Changed
- Alpine udpate to version 3.18 @slashfast
- Electrum udpate to version 4.4.5 @slashfast
- Py3-cryptography udpate to version 40.0.2 @slashfast

### Removed
- Removed deprecated (?) flag --mainnet

### Fix
- libsecp256k1 library failed to load @slashfast
