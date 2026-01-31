### NOTE: This is just an Azure function Dockerfile template. I will change this later

# ---------- Build stage ----------
FROM rust:1.76-bookworm AS builder

# Optional: if you depend on openssl via crates, you may need:
# RUN apt-get update && apt-get install -y pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*

WORKDIR /src

# Cache deps first
COPY Cargo.toml Cargo.lock ./
# If you have a workspace, also copy workspace manifests here.
RUN mkdir -p src && echo "fn main() {}" > src/main.rs
RUN cargo build --release
RUN rm -rf src

# Now copy real source
COPY . .
RUN cargo build --release

# ---------- Runtime stage ----------
# Use an Azure Functions base image. Node is commonly used for custom handlers.
# (You can use the -appservice variant to enable SSH/remote debugging on App Service if you want.)
FROM mcr.microsoft.com/azure-functions/node:4.0

# Required env vars for Functions in containers
ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true

# Copy function app files (host.json, function.json, etc.)
WORKDIR /home/site/wwwroot
COPY host.json ./
COPY local.settings.json ./local.settings.json
# Copy all function folders (each contains function.json)
COPY MyHttpFunction/ ./MyHttpFunction/

# Copy the Rust binary to where host.json will point the custom handler
# (match the path you configure under customHandler -> description -> defaultExecutablePath)
COPY --from=builder /src/target/release/my_rust_handler /home/site/wwwroot/my_rust_handler

# Functions host listens on 80 inside the container by default
EXPOSE 80
