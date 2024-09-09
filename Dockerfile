FROM eclipse-temurin:21.0.4_7-jre-alpine

WORKDIR /app

COPY server-data/ entrypoint.sh /app/

ENTRYPOINT [ "/bin/sh", "/app/entrypoint.sh" ]