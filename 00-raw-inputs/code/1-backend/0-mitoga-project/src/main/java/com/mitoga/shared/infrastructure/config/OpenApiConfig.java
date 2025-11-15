package com.mitoga.shared.infrastructure.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.servers.Server;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import io.swagger.v3.oas.models.Components;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

/**
 * Configuración de OpenAPI 3.0 (Swagger UI).
 * 
 * <p>
 * Documentación interactiva de la API REST disponible en:
 * </p>
 * <ul>
 * <li>Swagger UI: <a href=
 * "http://localhost:8082/swagger-ui.html">http://localhost:8082/swagger-ui.html</a></li>
 * <li>JSON Docs: <a href=
 * "http://localhost:8082/api-docs">http://localhost:8082/api-docs</a></li>
 * </ul>
 * 
 * @author MI-TOGA Development Team
 */
@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI mitogaOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("MI-TOGA Backend API")
                        .description(
                                """
                                        API REST del backend de MI-TOGA - Plataforma de tutorías en línea.

                                        **Arquitectura:** Hexagonal (Ports & Adapters) + Domain-Driven Design
                                        **Bounded Contexts:** Autenticación, Marketplace, Perfiles, Reservas, Pagos, Videollamadas, Notificaciones, Admin
                                        **Stack:** Java 21 LTS, Spring Boot 3.4.0, PostgreSQL 16, Redis 7

                                        **Autenticación:** JWT Bearer Token (obtener token en POST /auth/login)
                                        """)
                        .version("1.0.0")
                        .contact(new Contact()
                                .name("MI-TOGA Development Team")
                                .email("dev@mitoga.com"))
                        .license(new License()
                                .name("MIT License")
                                .url("https://opensource.org/licenses/MIT")))
                .servers(List.of(
                        new Server().url("http://localhost:8082").description("Local Development"),
                        new Server().url("https://api-dev.mitoga.com").description("Development Environment"),
                        new Server().url("https://api.mitoga.com").description("Production Environment")))
                .components(new Components()
                        .addSecuritySchemes("Bearer JWT", new SecurityScheme()
                                .type(SecurityScheme.Type.HTTP)
                                .scheme("bearer")
                                .bearerFormat("JWT")
                                .description("JWT token obtenido del endpoint /auth/login")))
                .addSecurityItem(new SecurityRequirement().addList("Bearer JWT"));
    }
}
