FROM node:18.18.1-alpine3.18 AS builder

ENV NODE_ENV=production
WORKDIR /misskey

RUN apk add --no-cache \
    autoconf automake file git g++ gcc libc-dev libtool make \
    nasm pkgconfig python3 tzdata zlib-dev \
    && cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && corepack enable pnpm

COPY package.json pnpm-lock.yaml ./

RUN pnpm i --frozen-lockfile && npx update-browserslist-db@latest

COPY .eslintrc.json .mocharc.json .npmrc .swcrc gulpfile.js index.js ormconfig.js tsconfig.json webpack.config.js ./
COPY assets/ ./assets/
COPY locales/ ./locales/
COPY src/ ./src/
RUN pnpm build

#########################################
FROM node:18.18.1-alpine3.18 AS runner

WORKDIR /misskey

# Install runtime dependencies
RUN apk add --no-cache tini ffmpeg
RUN corepack enable pnpm

# Add local user
RUN addgroup -g 60002 misskey && adduser -S -s /bin/false -u 60002 -h /misskey -G misskey misskey \
    && chmod 700 /misskey && chown misskey:misskey /misskey

COPY --from=builder /etc/localtime /etc/localtime
COPY --from=builder --chown=misskey:misskey /misskey/node_modules ./node_modules
COPY --from=builder --chown=misskey:misskey /misskey/built ./built
COPY --chown=misskey:misskey locales/ ./locales/
COPY --chown=misskey:misskey migration/ ./migration/
COPY --chown=misskey:misskey LICENSE docker-entrypoint.sh gulpfile.js index.js ormconfig.js package.json pnpm-lock.yaml renovate.json ./

USER misskey
ENV NODE_ENV=production
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["./docker-entrypoint.sh"]
