FROM heroiclabs/nakama-pluginbuilder:3.9.0 AS builder

WORKDIR /backend
COPY . .

FROM heroiclabs/nakama:3.9.0

COPY --from=builder /backend/build/*.js /nakama/data/modules/build/
COPY --from=builder /backend/local.yml /nakama/data/
