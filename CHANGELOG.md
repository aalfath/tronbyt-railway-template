# Changelog

Breaking changes are listed first in each entry.

## 2.6.1 (2026-11-17)

- First release of this template: Tronbyt server `2.6.1` (`ghcr.io/tronbyt/server:2.6.1@sha256:279af92ffaece6f2e7259fbfd8bd82487dc1135ba705727a2f8f27c2fa2a67b1`).
- One service built from this repo, SQLite and all other data on a Railway volume at `/app/data`, health check `/health`.
- Open registration off: the first visitor creates the `admin` account, after that only an admin can add users.
