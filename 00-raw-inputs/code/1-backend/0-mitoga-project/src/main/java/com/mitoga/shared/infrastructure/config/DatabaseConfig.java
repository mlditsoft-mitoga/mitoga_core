package com.mitoga.shared.infrastructure.config;

import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.transaction.annotation.EnableTransactionManagement;

/**
 * Configuración de JPA y base de datos PostgreSQL.
 * 
 * <p>
 * <b>Características configuradas:</b>
 * </p>
 * <ul>
 * <li>Entity scan en todos los bounded contexts</li>
 * <li>Repository scan para interfaces JPA</li>
 * <li>Gestión transaccional (@Transactional)</li>
 * </ul>
 * 
 * <p>
 * <b>Convención de base de datos:</b>
 * </p>
 * <ul>
 * <li>Schema único: appmatch_schema (todas las tablas del sistema)</li>
 * <li>Tablas con prefijo pkid_{tabla} para PKs</li>
 * <li>creation_date, expiration_date para auditoría y soft delete</li>
 * <li>Flyway gestiona migraciones (V001__crear_tabla_perfiles.sql,
 * V002__crear_tabla_informacion_basica.sql, etc.)</li>
 * <li>FK naming: fk_pkid_{tabla} para columnas,
 * fk_{tabla_origen}_{tabla_destino} para constraints</li>
 * </ul>
 * 
 * <p>
 * <b>Nueva estructura de tablas (V001-V005):</b>
 * </p>
 * <ul>
 * <li>appmatch_schema.perfiles - Catálogo de tipos de perfil (APRENDIZ, TUTOR,
 * ADMIN)</li>
 * <li>appmatch_schema.informacion_basica - Datos personales (nombres, fecha
 * nacimiento, ubicación, etc.)</li>
 * <li>appmatch_schema.perfil_informacion_basica - Relación N:M entre perfiles e
 * información básica</li>
 * <li>appmatch_schema.usuarios - Credenciales de autenticación (email,
 * password, estado cuenta)</li>
 * <li>appmatch_schema.archivos - Almacenamiento de archivos por perfil</li>
 * </ul>
 * 
 * <p>
 * <b>Nota:</b> JPA Auditing se habilitará cuando se implementen entidades
 * con @CreatedDate/@LastModifiedDate
 * </p>
 * 
 * @author Backend Java Developer Senior - ZNS-METHOD
 * @version 2.0 - Refactorizado para schema único appmatch_schema
 * @date 2025-11-16
 */
@Configuration
@EnableJpaRepositories(basePackages = "com.mitoga")
@EntityScan(basePackages = "com.mitoga")
@EnableTransactionManagement
public class DatabaseConfig {

    // Configuración manejada por application.yml
    // HikariCP pool configuration
    // Hibernate dialect: PostgreSQLDialect
    // Batch processing optimizations
}
