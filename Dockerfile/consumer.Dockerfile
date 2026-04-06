FROM rust:bookworm AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates coreutils cmake \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src

# Cache deps (dummy main)
COPY services/stream-consumer/Cargo.toml Cargo.lock ./
RUN mkdir -p src && printf "fn main() {}\n" > src/main.rs
RUN cargo build --release
RUN rm -rf src

# Build real source
COPY services/stream-consumer ./
RUN rm -rf target
RUN cargo build --release --bin stream-consumer

FROM debian:bookworm-slim

COPY --from=builder /src/target/release/stream-consumer /usr/local/bin/stream-consumer
# ENTRYPOINT ["/usr/local/bin/stream-consumer"]