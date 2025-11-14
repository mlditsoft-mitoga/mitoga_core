-- Inicialización de base de datos ZNS-METHOD
-- PostgreSQL v15+

\c zns_method;

-- Extensiones necesarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements";

-- Tabla de conversaciones
CREATE TABLE IF NOT EXISTS conversations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id VARCHAR(255) NOT NULL,
    agent_id VARCHAR(255) NOT NULL,
    user_message TEXT NOT NULL,
    assistant_message TEXT NOT NULL,
    context JSONB DEFAULT '{}',
    processing_time REAL DEFAULT 0,
    token_usage JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de sesiones
CREATE TABLE IF NOT EXISTS sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id VARCHAR(255) UNIQUE NOT NULL,
    user_id VARCHAR(255),
    project_id VARCHAR(255),
    agent_id VARCHAR(255),
    metadata JSONB DEFAULT '{}',
    last_activity TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMPTZ DEFAULT (CURRENT_TIMESTAMP + INTERVAL '7 days')
);

-- Tabla de métricas de agentes
CREATE TABLE IF NOT EXISTS agent_metrics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id VARCHAR(255) NOT NULL,
    session_id VARCHAR(255) NOT NULL,
    metric_type VARCHAR(50) NOT NULL, -- 'request', 'error', 'latency'
    value REAL NOT NULL,
    tags JSONB DEFAULT '{}',
    timestamp TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de logs de sistema
CREATE TABLE IF NOT EXISTS system_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    level VARCHAR(20) NOT NULL, -- 'DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL'
    service VARCHAR(50) NOT NULL,
    message TEXT NOT NULL,
    context JSONB DEFAULT '{}',
    timestamp TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Índices para rendimiento
CREATE INDEX IF NOT EXISTS idx_conversations_session_id ON conversations(session_id);
CREATE INDEX IF NOT EXISTS idx_conversations_agent_id ON conversations(agent_id);
CREATE INDEX IF NOT EXISTS idx_conversations_created_at ON conversations(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_sessions_session_id ON sessions(session_id);
CREATE INDEX IF NOT EXISTS idx_sessions_user_id ON sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_sessions_last_activity ON sessions(last_activity DESC);
CREATE INDEX IF NOT EXISTS idx_sessions_expires_at ON sessions(expires_at);

CREATE INDEX IF NOT EXISTS idx_agent_metrics_agent_id ON agent_metrics(agent_id);
CREATE INDEX IF NOT EXISTS idx_agent_metrics_timestamp ON agent_metrics(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_agent_metrics_type ON agent_metrics(metric_type);

CREATE INDEX IF NOT EXISTS idx_system_logs_timestamp ON system_logs(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_system_logs_level ON system_logs(level);
CREATE INDEX IF NOT EXISTS idx_system_logs_service ON system_logs(service);

-- Función para updated_at automático
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger para updated_at en sessions
DROP TRIGGER IF EXISTS update_sessions_updated_at ON sessions;
CREATE TRIGGER update_sessions_updated_at
    BEFORE UPDATE ON sessions
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Función de limpieza automática
CREATE OR REPLACE FUNCTION cleanup_expired_data()
RETURNS void AS $$
BEGIN
    -- Eliminar sesiones expiradas
    DELETE FROM sessions WHERE expires_at < CURRENT_TIMESTAMP;
    
    -- Eliminar conversaciones de sesiones eliminadas (últimos 30 días)
    DELETE FROM conversations 
    WHERE created_at < (CURRENT_TIMESTAMP - INTERVAL '30 days')
    AND session_id NOT IN (SELECT session_id FROM sessions);
    
    -- Eliminar métricas antiguas (últimos 7 días)
    DELETE FROM agent_metrics 
    WHERE timestamp < (CURRENT_TIMESTAMP - INTERVAL '7 days');
    
    -- Eliminar logs antiguos (últimas 72 horas)
    DELETE FROM system_logs 
    WHERE timestamp < (CURRENT_TIMESTAMP - INTERVAL '72 hours')
    AND level NOT IN ('ERROR', 'CRITICAL');
    
    RAISE NOTICE 'Limpieza de datos completada';
END;
$$ LANGUAGE plpgsql;

-- Vista de estadísticas por agente
CREATE OR REPLACE VIEW agent_stats AS
SELECT 
    agent_id,
    COUNT(*) as total_conversations,
    AVG(processing_time) as avg_processing_time,
    MIN(processing_time) as min_processing_time,
    MAX(processing_time) as max_processing_time,
    COUNT(DISTINCT session_id) as unique_sessions,
    DATE_TRUNC('day', created_at) as date,
    AVG(CAST(token_usage->>'total_tokens' AS INTEGER)) as avg_tokens
FROM conversations 
WHERE created_at >= (CURRENT_TIMESTAMP - INTERVAL '30 days')
GROUP BY agent_id, DATE_TRUNC('day', created_at)
ORDER BY date DESC, total_conversations DESC;

-- Vista de sesiones activas
CREATE OR REPLACE VIEW active_sessions AS
SELECT 
    s.session_id,
    s.user_id,
    s.agent_id,
    s.last_activity,
    s.created_at,
    COUNT(c.id) as message_count,
    MAX(c.created_at) as last_message_at
FROM sessions s
LEFT JOIN conversations c ON s.session_id = c.session_id
WHERE s.expires_at > CURRENT_TIMESTAMP
GROUP BY s.session_id, s.user_id, s.agent_id, s.last_activity, s.created_at
ORDER BY s.last_activity DESC;

-- Permisos para usuario de aplicación
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO zns_admin;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO zns_admin;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO zns_admin;

-- Configuraciones de rendimiento
ALTER SYSTEM SET shared_preload_libraries = 'pg_stat_statements';
ALTER SYSTEM SET max_connections = 200;
ALTER SYSTEM SET shared_buffers = '256MB';
ALTER SYSTEM SET effective_cache_size = '1GB';
ALTER SYSTEM SET maintenance_work_mem = '64MB';
ALTER SYSTEM SET checkpoint_completion_target = 0.7;
ALTER SYSTEM SET wal_buffers = '16MB';
ALTER SYSTEM SET default_statistics_target = 100;

-- Datos iniciales de ejemplo
INSERT INTO sessions (session_id, user_id, agent_id, metadata) VALUES 
('demo_session_001', 'demo_user', 'zns.context.consolidation', '{"demo": true, "purpose": "testing"}')
ON CONFLICT (session_id) DO NOTHING;

-- Log de inicialización
INSERT INTO system_logs (level, service, message, context) VALUES 
('INFO', 'postgresql', 'Base de datos ZNS-METHOD inicializada correctamente', '{"version": "2.0", "tables_created": 4, "views_created": 2}');

NOTIFY zns_init_complete, 'Base de datos ZNS-METHOD lista para usar';