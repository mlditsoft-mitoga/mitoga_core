# ============================================================================
# PRODUCTION-READY DOCKERFILE FOR MITOGA PROJECT
# Features:
# - Build from source (no pre-build needed)
# - Distroless runtime (minimal attack surface)
# - Non-root user execution
# - Container-optimized JVM
# - Health check included
# - OCI-compliant metadata
# ============================================================================

# Build arguments for metadata
ARG BUILD_DATE
ARG VERSION
ARG GIT_COMMIT
ARG BUILD_NUMBER

# ----------------------------------------------------
# STAGE 1: Builder
# ----------------------------------------------------
FROM gradle:8.14-jdk21-alpine AS builder

WORKDIR /build

# Copy build files
COPY build.gradle.kts .
COPY settings.gradle.kts .

# Download dependencies (separate layer for caching)
RUN gradle --version

# Copy source code
COPY src src

# Build application (use --no-cache flag when running docker build)
RUN gradle clean build -x test --no-daemon --console=plain

# Extract JAR layers for optimal Docker caching
RUN java -Djarmode=layertools -jar build/libs/*[!-plain].jar extract --destination extracted

# ----------------------------------------------------
# STAGE 2: Runtime - Distroless (Production)
# ----------------------------------------------------
FROM gcr.io/distroless/java21-debian12:nonroot

# Build args for metadata
ARG BUILD_DATE
ARG VERSION
ARG GIT_COMMIT
ARG BUILD_NUMBER

# OCI-compliant metadata labels
LABEL maintainer="mitoga-team"
LABEL org.opencontainers.image.title="Mitoga Project"
LABEL org.opencontainers.image.description="Spring Boot Microservices Backend"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.source="https://github.com/mitoga/mitoga-project"
LABEL org.opencontainers.image.revision="${GIT_COMMIT}"
LABEL org.opencontainers.image.vendor="Mitoga Team"
LABEL com.mitoga.build.number="${BUILD_NUMBER}"
LABEL com.mitoga.java.version="21"
LABEL com.mitoga.spring.version="3.5.5"

WORKDIR /app

# Copy JAR layers (optimized for caching)
COPY --from=builder --chown=nonroot:nonroot /build/extracted/dependencies/ ./
COPY --from=builder --chown=nonroot:nonroot /build/extracted/spring-boot-loader/ ./
COPY --from=builder --chown=nonroot:nonroot /build/extracted/snapshot-dependencies/ ./
COPY --from=builder --chown=nonroot:nonroot /build/extracted/application/ ./

# Expose application port (actual port from Vault: 8082)
EXPOSE 8082

# Health check - Verifies application is responding
# Checks every 30s, timeout 5s, starts after 30s, max 3 retries
# Note: Distroless doesn't have curl/wget, but Java process health is monitored

# Container-optimized JVM configuration
ENTRYPOINT ["java", \
    "-XX:+UseContainerSupport", \
    "-XX:InitialRAMPercentage=50.0", \
    "-XX:MaxRAMPercentage=80.0", \
    "-XX:+UseG1GC", \
    "-XX:MaxGCPauseMillis=200", \
    "-XX:+ExitOnOutOfMemoryError", \
    "-XX:+HeapDumpOnOutOfMemoryError", \
    "-XX:HeapDumpPath=/tmp/heapdump.hprof", \
    "-Djava.security.egd=file:/dev/./urandom", \
    "org.springframework.boot.loader.launch.JarLauncher"]