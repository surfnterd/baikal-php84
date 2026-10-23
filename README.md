# baikal-php84

[Baïkal](https://github.com/sabre-io/Baikal) 0.10.1 (CalDAV/CardDAV server) on the official `php:8.4-fpm-alpine` image.

The usual community image, `ckulka/baikal`, ships PHP 8.1. PHP 8.1 is end of life and did not get the October 2026 PHP fixes (CVE-2026-109618 / CVE-2026-109619, fixed in 8.4.27). This repo keeps the Baïkal code from that image unchanged and swaps the runtime underneath it.

## How it works

- Stage 1 pulls the Baïkal app code out of `ckulka/baikal:nginx`, pinned by digest.
- Stage 2 is `php:8.4-fpm-alpine` plus nginx, using the same nginx rules as the ckulka image.
- PHP-FPM runs as an unprivileged `baikal` user (uid 101, same as ckulka) and listens on 127.0.0.1 only.
- `php.ini-production` is used and `expose_php` is off.

## Use

```sh
docker compose up -d --build
```

Then open `http://127.0.0.1:8802/` and run the Baïkal installer, or reuse your existing data.

### Moving from ckulka/baikal

Mount the same two folders. The uid is the same, so no permission changes are needed.

| Host | Container |
|---|---|
| `./config` | `/var/www/baikal/config` |
| `./data` | `/var/www/baikal/Specific` |

Back both folders up first.

## Keeping PHP patched

```sh
docker compose build --pull && docker compose up -d
```

That pulls the latest `php:8.4-fpm-alpine`. Check with `docker exec baikal php -v`.

To move to a newer Baïkal release, change the digest on the first `FROM` line once ckulka publishes it.

## Notes

- The port is bound to localhost in the example. Don't expose plain HTTP; put Caddy, nginx or Traefik in front for TLS.
- Running in production with Baïkal 0.10.1 on PHP 8.4.27 since October 2026.
- Not affiliated with Baïkal or ckulka.

## Licence

MIT for the files in this repo. Baïkal itself is GPL-3.0.
