ARG VERSION="0.0.1-SNAPSHOT"

FROM Alpine

WORKDIR /usr/share/app
COPY pom.xml .
COPY src src
RUN mvn clean package

FROM openjdk:11.0.7-jre-slim

ARG VERSION
ENV JAR="calc-${VERSION}-fat.jar"

WORKDIR /usr/share/app
COPY --from=builder /usr/share/app/target/${JAR} .
COPY launch-scripts/api-server.sh launch.sh

ENTRYPOINT ["./launch.sh"]
© 2020 GitHub, Inc.
