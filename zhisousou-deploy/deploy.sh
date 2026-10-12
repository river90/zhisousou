#!/bin/bash
set -e
DOMAIN="zhisousou.com"
EMAIL="admin@zhisousou.com"   # 改成你的邮箱
DIR="$(cd "$(dirname "$0")" && pwd)"

echo "== 部署智搜搜 =="

# 安装 Docker（如缺失）
if ! command -v docker >/dev/null 2>&1; then
  curl -fsSL https://get.docker.com | sh
  systemctl enable --now docker
fi

cd "$DIR"

# 首次：无证书时先临时用 HTTP 配置签发证书
if [ ! -d "$DIR/ssl/live/$DOMAIN" ]; then
  echo "== 首次签发 SSL 证书 =="
  docker run -d --name tmp-web -p 80:80 -v "$DIR/html:/usr/share/nginx/html:ro" nginx:alpine
  docker run --rm -v "$DIR/ssl:/etc/letsencrypt" certbot/certbot certonly --webroot \
    -w /usr/share/nginx/html -d $DOMAIN -d www.$DOMAIN \
    --agree-tos --no-eff-email -m $EMAIL
  docker rm -f tmp-web
fi

docker compose up -d

# 证书自动续期
(crontab -l 2>/dev/null | grep -v certbot; echo "0 3 * * * docker run --rm -v $DIR/ssl:/etc/letsencrypt -v $DIR/html:/var/www/certbot certbot/certbot renew --quiet --webroot -w /var/www/certbot && docker restart zhisousou-web") | crontab -

echo "== 完成！访问 https://$DOMAIN =="
