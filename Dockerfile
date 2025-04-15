FROM node:22-alpine AS node

WORKDIR /app

COPY web ./web

RUN npm install -g pnpm && \
    cd web && \
    pnpm install --no-frozen-lockfile && \
    pnpm run build

FROM python:3.10.13-slim

WORKDIR /app

COPY . .

COPY --from=node /app/web/dist ./web/dist

RUN apt update \
    && apt install gcc -y \
    && python -m pip install -r requirements.txt \
    && touch /.dockerenv

CMD [ "python", "main.py" ]
