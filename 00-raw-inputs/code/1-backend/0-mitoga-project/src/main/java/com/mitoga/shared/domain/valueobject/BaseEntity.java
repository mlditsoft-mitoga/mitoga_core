package com.mitoga.shared.domain.valueobject;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Entidad base con campos comunes - SHARED KERNEL
 * Basado en estándares de BD V4/V5/V5.1
 * Autor: Backend Java Developer Senior - ZNS-METHOD
 * Fecha: 2025-11-14
 * 
 * ARQUITECTURA HEXAGONAL - SHARED KERNEL
 * - Value Object base compartido entre todos los módulos
 * - Define comportamientos y propiedades comunes de auditoría
 * - Sigue principios DDD para entities y value objects
 */
@MappedSuperclass
@EntityListeners(AuditingEntityListener.class)
@Data
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
public abstract class BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @EqualsAndHashCode.Include
    protected UUID id;

    @CreatedDate
    @Column(name = "creation_date", nullable = false, updatable = false)
    protected LocalDateTime creationDate;

    @LastModifiedDate
    @Column(name = "updated_at")
    protected LocalDateTime updatedAt;

    @Column(name = "expiration_date")
    protected LocalDateTime expirationDate;

    @PrePersist
    protected void onCreate() {
        if (creationDate == null) {
            creationDate = LocalDateTime.now();
        }
        if (updatedAt == null) {
            updatedAt = LocalDateTime.now();
        }
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    /**
     * Verifica si la entidad está activa (no expirada)
     */
    public boolean isActive() {
        return expirationDate == null || expirationDate.isAfter(LocalDateTime.now());
    }

    /**
     * Marca la entidad como expirada (soft delete)
     */
    public void expire() {
        this.expirationDate = LocalDateTime.now();
    }
}