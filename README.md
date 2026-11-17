[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/tronbyt-1?utm_medium=integration&utm_source=button&utm_campaign=tronbyt)

# Tronbyt on Railway

A Railway template for the [Tronbyt server](https://github.com/tronbyt/server), the self-hosted replacement for the Tidbyt cloud. It renders Pixlet apps for Tidbyt Gen1/Gen2, Tronbyt S3 and other 64x32 LED displays and serves the frames to your devices, with no dependence on Tidbyt's servers.

## What it deploys

| Service | Source | Notes |
|---|---|---|
| **Tronbyt** | this repo (`Dockerfile`) | `ghcr.io/tronbyt/server:2.6.1`, pinned by digest. Web UI and device API on port 8000 (public domain). Health check `/health`. |

All state lives on a Railway volume mounted at `/app/data`: the SQLite database (users, devices, installed apps, settings), the community app catalogue, firmware images and uploaded apps. A redeploy or restart loses nothing.

## Variables

| Variable | Default | Why |
|---|---|---|
| `PORT` | `8000` | Port Railway routes the public domain to. |

No prompts. Fixed settings are baked into the `Dockerfile`: database at `/app/data/tronbyt.db`, `PRODUCTION=true` (firmware and app catalogue updates on), `ENABLE_USER_REGISTRATION=false`, `SINGLE_USER_AUTO_LOGIN=false`.

Optional settings you can add as service variables later (see upstream's [`.env.example`](https://github.com/tronbyt/server/blob/v2.6.1/.env.example)):

- `ENABLE_USER_REGISTRATION=true` lets anyone with the URL sign up. Leave it off unless you want that.
- `SYSTEM_APPS_AUTO_REFRESH=true` pulls the app catalogue every 12 hours (also a switch in the admin settings).
- `GITHUB_TOKEN` raises GitHub's rate limit for catalogue and firmware downloads.
- `REDIS_URL` moves the Pixlet HTTP cache to Redis (add a Railway Redis and use `${{Redis.REDIS_URL}}`). The built-in memory cache is fine for a few displays.
- `PIXLET_HTTP_BLOCK_PRIVATE_IPS=true` stops apps from calling private addresses.
- OIDC sign-in: `OIDC_ENABLED`, `OIDC_ISSUER_URL`, `OIDC_CLIENT_ID`, `OIDC_CLIENT_SECRET`.

## After deploy

1. Open the service's Railway URL. The first page asks you to create the `admin` user: do it right away, with a strong password. That account can build firmware that contains your Wi-Fi password.
2. Click **New Tronbyt**, name the device and pick its hardware type, then **Add App** to install apps from the catalogue.
3. For a real device, open **Firmware** on it, enter your Wi-Fi details and download the image. Flash it (for example with the ESPHome web flasher). The firmware points the device at `https://YOUR-DOMAIN`.

More users: the admin adds them from the admin page. Open sign-up stays off.

## Updates

The service builds from this repo. When we bump the pinned version on `main`, Railway shows an "update available" notice on your project, and you choose when to apply it. Tronbyt migrates its database on start. Read [CHANGELOG.md](CHANGELOG.md) before you apply an update.

## Local test

```sh
docker compose -f local-test/compose.yaml up -d --build
# open http://localhost:41376 and create the admin user
```

Tronbyt server is licensed under the [Apache License 2.0](https://github.com/tronbyt/server/blob/main/LICENSE); this wrapper only adds Railway settings.
