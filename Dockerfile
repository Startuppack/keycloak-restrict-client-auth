ARG KEYCLOAK_VERSION=26.6.3

FROM docker.io/library/maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /build
COPY pom.xml .
RUN mvn -B dependency:go-offline -DskipTests
COPY src ./src
RUN mvn -B -DskipTests clean package

FROM quay.io/keycloak/keycloak:${KEYCLOAK_VERSION}
COPY --from=builder /build/target/keycloak-restrict-client-auth.jar /opt/keycloak/providers/
USER 1000
CMD ["start-dev"]
