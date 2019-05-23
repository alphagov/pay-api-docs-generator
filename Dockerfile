# node:10-slim
FROM node@sha256:5177e5de0e87965ed102f5a84856e31c1434e479dd0d90cf8df21d61284c78f1

WORKDIR /app

CMD bash ./docker-startup.sh
