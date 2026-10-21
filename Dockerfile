# Zircon Mir3 Server (皓石传奇三) container image.
# Upstream publishes prebuilt server zips as release assets; this image just
# fetches the linux asset and runs it on the .NET 8 ASP.NET runtime.
#
# NOTE: the required map/运营 data (~800 MB) is NOT bundled — upstream only
# distributes it via netdisk links. Mount it into /zircon/datas before starting.
FROM mcr.microsoft.com/dotnet/aspnet:8.0

ARG UPSTREAM_REPO=raphaelcheung/zircon-legend-server
ARG UPSTREAM_TAG=v1.14.0
ARG TARGETARCH

WORKDIR /zircon

RUN apt-get update \
 && apt-get install -y --no-install-recommends curl ca-certificates tzdata \
 && rm -rf /var/lib/apt/lists/*

# amd64 -> linux-x64, arm64 -> linux-arm64
RUN set -eux; \
    case "${TARGETARCH:-amd64}" in \
      amd64) ASSET="Server-${UPSTREAM_TAG}-linux-x64.zip" ;; \
      arm64) ASSET="Server-${UPSTREAM_TAG}-linux-arm64.zip" ;; \
      *) echo "unsupported arch: ${TARGETARCH}" >&2; exit 1 ;; \
    esac; \
    url="https://github.com/${UPSTREAM_REPO}/releases/download/${UPSTREAM_TAG}/${ASSET}"; \
    echo "downloading ${url}"; \
    curl -fsSL --retry 3 "$url" -o /tmp/pkg.zip; \
    apt-get update && apt-get install -y --no-install-recommends unzip && rm -rf /var/lib/apt/lists/*; \
    unzip -q /tmp/pkg.zip -d /zircon; \
    rm /tmp/pkg.zip; \
    chmod +x /zircon/Server; \
    mkdir -p /zircon/datas /zircon/Map

ENV TZ=Asia/Shanghai
EXPOSE 7000 3000 7080
WORKDIR /zircon
ENTRYPOINT ["./Server"]
