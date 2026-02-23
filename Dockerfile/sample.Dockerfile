FROM debian:bullseye-slim

RUN apt update && apt install ffmpeg -y

CMD ["ffmpeg", "-version"]