FROM node:18.18.1-alpine3.18 AS builder

ENV NODE_ENV=production
WORKDIR /misskey

RUN apk add --no-cache \
    autoconf automake file g++ gcc libc-dev libtool make \
    nasm pkgconfig python3 zlib-dev

COPY package.json pnpm-lock.yaml ./

RUN corepack enable pnpm

RUN pnpm i --frozen-lockfile

COPY . ./
RUN pnpm build

#########################################
FROM node:18.18.1-alpine3.18 AS runner

WORKDIR /misskey

# Install runtime dependencies
RUN apk add --no-cache tini ffmpeg
RUN corepack enable pnpm

COPY --from=builder /misskey/node_modules ./node_modules
COPY --from=builder /misskey/built ./built
COPY assets/ ./assets/
COPY locales/ ./locales/
COPY migration/ ./migration/
COPY LICENSE gulpfile.js index.js ormconfig.js package.json pnpm-lock.yaml renovate.json ./

ENV NODE_ENV=production
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["pnpm", "migrateandstart"]
