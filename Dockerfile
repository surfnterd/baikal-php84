# Baikal 0.10.1 on the official PHP 8.4 image (21 Oct 2026, PHP2Shell fix).
# ckulka's image ships PHP 8.1, which is end of life and won't get the fix.
# App code is copied unchanged from the pinned ckulka image.
# To bump PHP: rebuild with `docker compose build --pull && docker compose up -d`.
FROM ckulka/baikal:nginx@sha256:1a901125d121a3e414cda87c617bd322c57ae86b9d2aedbff7b3a7ac84bb23aa AS src

FROM php:8.4-fpm-alpine
RUN addgroup -g 101 -S baikal && adduser -S -D -H -u 101 -G baikal baikal \
 && apk add --no-cache nginx \
 && cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
 && sed -i 's/^expose_php = .*/expose_php = Off/' "$PHP_INI_DIR/php.ini"
COPY --from=src --chown=101:101 /var/www/baikal /var/www/baikal
COPY nginx.conf /etc/nginx/http.d/default.conf
COPY fpm-pool.conf /usr/local/etc/php-fpm.d/zzz-baikal.conf
COPY --chmod=755 start.sh /start.sh
EXPOSE 80
CMD ["/start.sh"]
