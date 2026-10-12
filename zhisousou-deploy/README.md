# 智搜搜 部署包

## 部署步骤（服务器上执行）
1. 上传整个目录到服务器：scp -r zhisousou-deploy root@<服务器IP>:/opt/
2. 登录服务器：ssh root@<服务器IP>
3. 修改 deploy.sh 中的 EMAIL
4. 执行：cd /opt/zhisousou-deploy && bash deploy.sh

## 前提
- 域名 www.zhisousou.com / zhisousou.com 已 A 记录解析到服务器 IP
- 服务器安全组放行 80 / 443 端口
- 国内服务器需完成 ICP 备案

## 目录说明
- html/index.html   网站主文件（更新内容直接替换它即可）
- nginx/nginx.conf  Nginx 配置（HTTPS、Gzip、缓存）
- docker-compose.yml
- deploy.sh         一键部署 + SSL 签发 + 自动续期
