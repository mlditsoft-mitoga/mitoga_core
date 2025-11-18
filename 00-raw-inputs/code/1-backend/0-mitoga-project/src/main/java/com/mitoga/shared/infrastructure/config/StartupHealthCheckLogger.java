package com.mitoga.shared.infrastructure.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
// import org.springframework.beans.factory.annotation.Autowired; // Ya no se usa
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.ApplicationContext;
import org.springframework.context.event.EventListener;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.stereotype.Component;

import javax.sql.DataSource;
import java.sql.Connection;

/**
 * StartupHealthCheckLogger - Registra checklist de componentes al inicio
 * Verifica estado de: PostgreSQL, Redis, MinIO, Vault
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-16
 */
@Component
public class StartupHealthCheckLogger {

    private static final Logger log = LoggerFactory.getLogger(StartupHealthCheckLogger.class);

    private final DataSource dataSource;
    private final RedisConnectionFactory redisConnectionFactory;
    private final ApplicationContext applicationContext;

    @Value("${minio.enabled:true}")
    private boolean minioEnabled;

    @Value("${minio.endpoint:not-configured}")
    private String minioEndpoint;

    @Value("${minio.bucket-name:not-configured}")
    private String minioBucketName;

    @Value("${spring.cloud.vault.enabled:false}")
    private boolean vaultEnabled;

    @Value("${server.port}")
    private String serverPort;

    @Value("${spring.datasource.url:not-configured}")
    private String datasourceUrl;

    // @Autowired(required = false)
    // private
    // com.mitoga.autenticacion.infrastructure.adapter.storage.MinIOStorageAdapter
    // minioAdapter; // BC Autenticación eliminado

    public StartupHealthCheckLogger(
            DataSource dataSource,
            RedisConnectionFactory redisConnectionFactory,
            ApplicationContext applicationContext) {
        this.dataSource = dataSource;
        this.redisConnectionFactory = redisConnectionFactory;
        this.applicationContext = applicationContext;
    }

    @EventListener(ApplicationReadyEvent.class)
    public void logStartupChecklist() {
        log.info("═══════════════════════════════════════════════════════════════════════");
        log.info("🚀 MITOGA BACKEND - CHECKLIST DE COMPONENTES");
        log.info("═══════════════════════════════════════════════════════════════════════");

        // PostgreSQL
        checkPostgreSQL();

        // Redis
        checkRedis();

        // MinIO
        checkMinIO();

        // Vault
        checkVault();

        log.info("───────────────────────────────────────────────────────────────────────");
        log.info("✅ Servidor iniciado correctamente en puerto: {}", serverPort);
        log.info("📍 URL Base: http://localhost:{}", serverPort);
        log.info("📍 Actuator Health: http://localhost:{}/actuator/health", serverPort);
        log.info("📍 Swagger UI: http://localhost:{}/swagger-ui.html", serverPort);
        log.info("═══════════════════════════════════════════════════════════════════════");
    }

    private void checkPostgreSQL() {
        try (Connection connection = dataSource.getConnection()) {
            String dbVersion = connection.getMetaData().getDatabaseProductVersion();
            String dbUrl = connection.getMetaData().getURL();
            log.info("✅ PostgreSQL: CONECTADO");
            log.info("   └─ Versión: {}", dbVersion);
            log.info("   └─ URL: {}", maskPassword(dbUrl));
        } catch (Exception e) {
            log.error("❌ PostgreSQL: DESCONECTADO - {}", e.getMessage());
        }
    }

    private void checkRedis() {
        try {
            String ping = redisConnectionFactory.getConnection().ping();
            log.info("✅ Redis: CONECTADO");
            log.info("   └─ Respuesta ping: {}", ping);
        } catch (Exception e) {
            log.warn("⚠️  Redis: DESCONECTADO (opcional) - {}", e.getMessage());
        }
    }

    private void checkMinIO() {
        // Método deshabilitado - MinIOStorageAdapter pertenecía al BC Autenticación
        // eliminado
        log.warn("⚠️  MinIO: DESHABILITADO (BC Autenticación eliminado)");
        log.info("   └─ Storage de archivos no disponible");
        /*
         * if (!minioEnabled) {
         * log.warn("⚠️  MinIO: DESHABILITADO (minio.enabled=false)");
         * log.info("   └─ Storage de archivos no disponible");
         * return;
         * }
         * 
         * if (minioAdapter != null) {
         * if ("not-configured".equals(minioEndpoint)) {
         * log.warn("⚠️  MinIO: NO CONFIGURADO");
         * } else {
         * log.info("✅ MinIO: HABILITADO y CONECTADO");
         * log.info("   └─ Endpoint: {}", minioEndpoint);
         * log.info("   └─ Bucket: {}", minioBucketName);
         * log.info("   └─ Estado: Verificación realizada al inicio");
         * }
         * } else {
         * log.warn("⚠️  MinIO: HABILITADO pero DESCONECTADO");
         * log.info("   └─ Storage temporal no disponible (revisar configuración)");
         * }
         */
    }

    private void checkVault() {
        if (vaultEnabled) {
            log.info("✅ HashiCorp Vault: HABILITADO");
            log.info("   └─ Gestión centralizada de secrets activa");
        } else {
            log.info("⚠️  HashiCorp Vault: DESHABILITADO");
            log.info("   └─ Usando configuración local (desarrollo)");
        }
    }

    private String maskPassword(String url) {
        // Ocultar password en JDBC URL para logs
        if (url != null && url.contains("password=")) {
            return url.replaceAll("password=[^&]+", "password=****");
        }
        return url;
    }
}
