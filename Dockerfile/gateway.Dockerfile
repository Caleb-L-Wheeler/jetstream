FROM rust:bookworm AS builder
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
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates coreutils \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /src/target/release/stream-gateway /usr/local/bin/stream-gateway
ENTRYPOINT ["/usr/local/bin/stream-gateway"]