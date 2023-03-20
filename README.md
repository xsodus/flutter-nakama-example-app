# Flutter & Nakama Example App

This is the example project to demonstrate how we can write the flutter app and communicate with Nakama server.

## Prerequisites

These are required tool. That should be installed before writing the integration tests.

- Flutter v2.19.2 to v3.0.0
- Node v16.19
- Docker v4.16.2

## How to run

Please see more detail at README.md in both `frontend` and `backend` directory.

## Limitation

1. The flutter Nakama SDK cannot communicate with authoritative multiplayer service.
   It only create a game room and comminate with relayed multiplayer service.
   Ref: https://github.com/obrunsmann/flutter_nakama/issues/40
