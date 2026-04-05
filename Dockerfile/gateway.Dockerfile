FROM rust:bookworm AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates coreutils cmake \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src

# Cache deps (dummy main)
COPY services/stream-gateway/Cargo.toml Cargo.lock ./
RUN mkdir -p src && printf "fn main() {}\n" > src/main.rs
RUN cargo build --release
RUN rm -rf src

# Build real source
COPY services/stream-gateway ./
RUN rm -rf target
RUN cargo build --release --bin stream-gateway

FROM debian:bookworm-slim

COPY --from=builder /src/target/release/stream-gateway /usr/local/bin/stream-gateway
# ENTRYPOINT ["/usr/local/bin/stream-gateway"]