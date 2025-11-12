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
 * <li>Schema por Bounded Context (autenticacion_schema, reservas_schema,
 * etc.)</li>
 * <li>Tablas con prefijo pkid_{tabla} para PKs</li>
 * <li>creation_date, expiration_date para auditoría y soft delete</li>
 * <li>Flyway gestiona migraciones (V1__init_schema.sql)</li>
 * </ul>
 * 
 * <p>
 * <b>Nota:</b> JPA Auditing se habilitará cuando se implementen entidades
 * con @CreatedDate/@LastModifiedDate
 * </p>
 * 
 * @author MI-TOGA Development Team
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
