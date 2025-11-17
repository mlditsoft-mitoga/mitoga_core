package com.mitoga.shared.infrastructure.config;

import org.springframework.boot.actuate.health.Health;
import org.springframework.boot.actuate.health.HealthIndicator;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.data.redis.connection.RedisConnectionFactory;

/**
 * HealthCheckConfig - Configuración de Health Checks
 * 
 * PROBLEMA RESUELTO:
 * - Redis es OPCIONAL en la arquitectura (solo cache)
 * - Por defecto, Spring Boot marca la app como DOWN si Redis falla
 * - Esta configuración convierte Redis en un componente NO crítico
 * 
 * SOLUCIÓN:
 * - Redis health check retorna siempre UP (con warning si no conecta)
 * - Solo PostgreSQL es crítico para el health check
 * - La aplicación puede funcionar perfectamente sin Redis
 * 
 * @author Backend Team - MI-TOGA
 * @version 1.0.0
 * @since 2025-11-15
 */
@Configuration
public class HealthCheckConfig {

    /**
     * Redis Health Indicator customizado que NO falla la aplicación.
     * 
     * Retorna:
     * - UP si Redis está disponible
     * - UP (con warning) si Redis no está disponible
     * 
     * Esto permite que /actuator/health retorne UP incluso sin Redis.
     */
    @Bean(name = "redisHealthIndicator")
    @Primary
    @ConditionalOnProperty(name = "spring.data.redis.host")
    public HealthIndicator redisHealthIndicator(RedisConnectionFactory redisConnectionFactory) {
        return () -> {
            try {
                // Intentar obtener conexión
                redisConnectionFactory.getConnection().ping();

                return Health.up()
                        .withDetail("redis", "available")
                        .withDetail("host", redisConnectionFactory.getConnection().toString())
                        .build();

            } catch (Exception e) {
                // Si falla, retornar UP con warning (Redis es opcional)
                return Health.up()
                        .withDetail("redis", "unavailable")
                        .withDetail("message", "Redis is optional - application continues without cache")
                        .withDetail("error", e.getMessage())
                        .build();
            }
        };
    }
}
