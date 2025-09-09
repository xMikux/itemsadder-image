FROM alpine:3 AS mc-monitor

ARG MC_MONITOR_VERSION=0.14.1

WORKDIR /download

RUN wget -O mc-monitor.tar.gz "https://github.com/itzg/mc-monitor/releases/download/${MC_MONITOR_VERSION}/mc-monitor_${MC_MONITOR_VERSION}_linux_$([[ "$(uname -m)" == "x86_64" ]] && echo "amd64" || echo "arm64").tar.gz" && \
    tar zxvf mc-monitor.tar.gz

FROM eclipse-temurin:21.0.4_7-jre-alpine

WORKDIR /app

COPY --from=mc-monitor /download/mc-monitor /bin/mc-monitor
COPY server-data/ entrypoint.sh /app/

ENTRYPOINT [ "/bin/sh", "/app/entrypoint.sh" ]
HEALTHCHECK --start-period=120s --retries=24 --interval=12s \
            CMD ["/bin/mc-monitor", "status"]
