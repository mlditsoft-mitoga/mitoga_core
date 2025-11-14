"""
ZNS-METHOD API Gateway
FastAPI server para integrar agentes IA con frontend
Versión: 2.0
"""

import os
import uuid
import json
import asyncio
import logging
from datetime import datetime, timedelta
from typing import Dict, List, Optional, Any
from pathlib import Path

import aioredis
import asyncpg
import httpx
from fastapi import FastAPI, HTTPException, Depends, BackgroundTasks, Security, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.gzip import GZipMiddleware
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from fastapi.responses import StreamingResponse
from pydantic import BaseModel, Field
from celery import Celery
import prometheus_client
from prometheus_client import Counter, Histogram, Gauge

# Configuración
class Settings:
    DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://zns_admin:zns_secure_2025@localhost:5432/zns_method")
    REDIS_URL = os.getenv("REDIS_URL", "redis://:zns_cache_2025@localhost:6379/0")
    TEXTGEN_URL = os.getenv("TEXTGEN_URL", "http://localhost:5000/api/v1")
    SECRET_KEY = os.getenv("SECRET_KEY", "zns_secret_key_change_in_production")
    LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO")
    MAX_TOKENS = int(os.getenv("MAX_TOKENS", "4096"))
    RATE_LIMIT_PER_MINUTE = int(os.getenv("RATE_LIMIT_PER_MINUTE", "20"))

settings = Settings()

# Logging configuration
logging.basicConfig(
    level=getattr(logging, settings.LOG_LEVEL),
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger("zns-gateway")

# Prometheus metrics
REQUEST_COUNT = Counter('zns_requests_total', 'Total requests', ['agent', 'method', 'status'])
REQUEST_DURATION = Histogram('zns_request_duration_seconds', 'Request duration', ['agent'])
ACTIVE_SESSIONS = Gauge('zns_active_sessions', 'Active sessions')
AGENT_USAGE = Counter('zns_agent_usage_total', 'Agent usage', ['agent_id'])

# FastAPI app
app = FastAPI(
    title="ZNS-METHOD API Gateway",
    description="API Gateway para Metodología ZNS v2.0 - Zenapses Next-gen Software",
    version="2.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# Middleware
app.add_middleware(GZipMiddleware, minimum_size=1000)
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000",
        "http://localhost:3001", 
        "https://*.zenapses.com",
        "https://mitoga.local"
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Celery for background tasks
celery = Celery('zns_gateway')
celery.conf.update(
    broker_url=settings.REDIS_URL.replace('/0', '/1'),
    result_backend=settings.REDIS_URL.replace('/0', '/2'),
    task_serializer='json',
    accept_content=['json'],
    result_serializer='json',
    timezone='UTC',
    enable_utc=True,
)

# Pydantic Models
class AgentRequest(BaseModel):
    agent_id: str = Field(..., description="ID del agente ZNS (ej: zns.context.consolidation)")
    message: str = Field(..., min_length=10, max_length=8000, description="Mensaje del usuario")
    context: Dict[str, Any] = Field(default_factory=dict, description="Contexto adicional")
    session_id: Optional[str] = Field(None, description="ID de sesión para continuidad")
    stream: bool = Field(False, description="Respuesta en streaming")
    temperature: float = Field(0.7, ge=0.0, le=2.0, description="Creatividad del modelo")
    max_tokens: int = Field(2048, gt=0, le=8192, description="Máximo tokens de respuesta")

class AgentResponse(BaseModel):
    response: str
    agent_id: str
    session_id: str
    metadata: Dict[str, Any]
    timestamp: datetime
    processing_time: float
    token_usage: Dict[str, int]

class SessionInfo(BaseModel):
    session_id: str
    agent_id: str
    created_at: datetime
    message_count: int
    last_activity: datetime

class AgentInfo(BaseModel):
    id: str
    name: str
    description: str
    category: str
    version: str
    methodology: str
    status: str
    avg_response_time: Optional[float] = None

# Security
security = HTTPBearer(auto_error=False)

async def get_current_session(credentials: Optional[HTTPAuthorizationCredentials] = Security(security)):
    """Validación opcional de sesión"""
    if not credentials:
        return None
    
    # En producción, validar JWT aquí
    return {"user_id": "demo", "permissions": ["read", "write"]}

# Database connections
async def get_db():
    conn = await asyncpg.connect(settings.DATABASE_URL)
    try:
        yield conn
    finally:
        await conn.close()

async def get_redis():
    redis = await aioredis.from_url(settings.REDIS_URL, decode_responses=True)
    try:
        yield redis
    finally:
        await redis.close()

# Agent Manager
class ZNSAgentManager:
    def __init__(self):
        self.agents = {}
        self.load_agents()
    
    def load_agents(self):
        """Cargar agentes desde ZNS-METHOD"""
        agents_path = Path("/app/agents")
        chatmodes_path = Path("/app/chatmodes")
        
        # Mapeo de agentes ZNS v2.0
        agent_mapping = {
            "0.consolidation_context": {
                "id": "zns.context.consolidation",
                "name": "📋 Context Consolidation Master",
                "category": "analysis",
                "description": "Business Analyst + Software Architect + Requirements Engineer"
            },
            "1.obsolescence_analysis": {
                "id": "zns.analysis.obsolescence", 
                "name": "🔍 Technical Debt & Obsolescence Analyst",
                "category": "analysis",
                "description": "Platform Architect experto en modernización tecnológica"
            },
            "2.definition_of_architecture": {
                "id": "zns.solutions.architect",
                "name": "🏗️ Solutions Architect", 
                "category": "architecture",
                "description": "Cloud Architect + Enterprise Solutions Designer"
            },
            "10.database_engineer_senior": {
                "id": "zns.dba.database.engineer",
                "name": "🗄️ PostgreSQL Database Engineer",
                "category": "architecture", 
                "description": "Database Architect con DDD y performance tuning"
            },
            "11.frontend_senior_React_developer": {
                "id": "zns.dev.frontend",
                "name": "⚛️ Frontend Developer Senior",
                "category": "development",
                "description": "React + Next.js + TypeScript Expert"
            },
            "9.backend_senior_Java_developer": {
                "id": "zns.dev.backend", 
                "name": "☕ Backend Developer Senior",
                "category": "development",
                "description": "Java + Spring Boot + Hexagonal Architecture"
            },
            "12.devsecops_onpremise_senior": {
                "id": "zns.devsecops.onpremise",
                "name": "🔧 DevSecOps Engineer",
                "category": "infrastructure",
                "description": "K3s/K8s + CI/CD + Security Expert"
            },
            "5.frontend_audit": {
                "id": "zns.audit.frontend",
                "name": "🔍 Frontend Auditor", 
                "category": "quality",
                "description": "React Performance + Accessibility Expert"
            },
            "6.backend_audit": {
                "id": "zns.audit.backend",
                "name": "🔍 Backend Auditor",
                "category": "quality", 
                "description": "Java Spring Boot + Security Expert"
            },
            "4.validation_quality": {
                "id": "zns.quality.validation",
                "name": "✅ Quality Validator",
                "category": "quality",
                "description": "Documentation QA + Compliance Officer"
            },
            "7.product_owner_senior_y_business_analyst": {
                "id": "zns.po.business.analyst",
                "name": "📝 Product Owner & BA",
                "category": "product",
                "description": "Product Strategy + User Stories Expert"
            },
            "8.technical_user_stories": {
                "id": "zns.stories.technical", 
                "name": "⚙️ Technical Stories Engineer",
                "category": "product",
                "description": "HU → HUT transformation specialist"
            },
            "3.exporting_documents": {
                "id": "zns.export.documents",
                "name": "📄 Document Exporter",
                "category": "documentation", 
                "description": "Word/PDF generation + PlantUML compiler"
            }
        }
        
        for folder, info in agent_mapping.items():
            agent_id = info["id"]
            
            # Cargar prompt maestro
            prompt_files = list(agents_path.glob(f"{folder}/prompt-*.md"))
            system_prompt = ""
            
            if prompt_files:
                try:
                    with open(prompt_files[0], 'r', encoding='utf-8') as f:
                        system_prompt = f.read()
                except Exception as e:
                    logger.warning(f"Error cargando prompt {folder}: {e}")
            
            # Cargar chatmode si existe
            chatmode_file = chatmodes_path / f"{agent_id}.chatmode.md"
            chatmode_content = ""
            
            if chatmode_file.exists():
                try:
                    with open(chatmode_file, 'r', encoding='utf-8') as f:
                        chatmode_content = f.read()
                except Exception as e:
                    logger.warning(f"Error cargando chatmode {agent_id}: {e}")
            
            self.agents[agent_id] = {
                "info": info,
                "system_prompt": system_prompt,
                "chatmode": chatmode_content,
                "metadata": {
                    "methodology": "ZNS v2.0",
                    "version": "2.0",
                    "loaded_at": datetime.now(),
                    "folder": folder,
                    "status": "active" if system_prompt else "inactive"
                }
            }
        
        logger.info(f"Cargados {len(self.agents)} agentes ZNS")
    
    def get_agent(self, agent_id: str) -> Optional[Dict]:
        return self.agents.get(agent_id)
    
    def list_agents(self) -> List[AgentInfo]:
        return [
            AgentInfo(
                id=agent_id,
                name=agent["info"]["name"],
                description=agent["info"]["description"], 
                category=agent["info"]["category"],
                version=agent["metadata"]["version"],
                methodology=agent["metadata"]["methodology"],
                status=agent["metadata"]["status"]
            )
            for agent_id, agent in self.agents.items()
        ]

agent_manager = ZNSAgentManager()

# API Endpoints
@app.get("/", tags=["System"])
async def root():
    return {
        "service": "ZNS-METHOD API Gateway",
        "version": "2.0.0",
        "methodology": "Zenapses Next-gen Software v2.0",
        "agents_loaded": len(agent_manager.agents),
        "status": "operational",
        "timestamp": datetime.now()
    }

@app.get("/health", tags=["System"])
async def health_check():
    """Health check detallado"""
    try:
        # Test database
        async for db in get_db():
            await db.fetchval("SELECT 1")
            db_status = "healthy"
            break
    except Exception as e:
        db_status = f"error: {str(e)}"
    
    try:
        # Test Redis
        async for redis in get_redis():
            await redis.ping()
            cache_status = "healthy"
            break
    except Exception as e:
        cache_status = f"error: {str(e)}"
    
    try:
        # Test TextGen
        async with httpx.AsyncClient(timeout=5.0) as client:
            response = await client.get(f"{settings.TEXTGEN_URL}/model")
            llm_status = "healthy" if response.status_code == 200 else "degraded"
    except Exception as e:
        llm_status = f"error: {str(e)}"
    
    return {
        "status": "healthy",
        "timestamp": datetime.now(),
        "services": {
            "database": db_status,
            "cache": cache_status,
            "llm_engine": llm_status
        },
        "agents": {
            "total": len(agent_manager.agents),
            "active": len([a for a in agent_manager.agents.values() 
                          if a["metadata"]["status"] == "active"])
        }
    }

@app.get("/agents", response_model=List[AgentInfo], tags=["Agents"])
async def list_agents():
    """Listar todos los agentes ZNS disponibles"""
    return agent_manager.list_agents()

@app.get("/agents/{agent_id}", tags=["Agents"])
async def get_agent_info(agent_id: str):
    """Obtener información detallada de un agente"""
    agent = agent_manager.get_agent(agent_id)
    if not agent:
        raise HTTPException(404, f"Agente {agent_id} no encontrado")
    
    return {
        "agent": agent["info"],
        "metadata": agent["metadata"],
        "has_prompt": bool(agent["system_prompt"]),
        "has_chatmode": bool(agent["chatmode"]),
        "prompt_length": len(agent["system_prompt"]),
        "chatmode_length": len(agent["chatmode"])
    }

@app.post("/agents/chat", response_model=AgentResponse, tags=["Chat"])
async def chat_with_agent(
    request: AgentRequest,
    background_tasks: BackgroundTasks,
    session_info = Depends(get_current_session),
    db = Depends(get_db),
    redis = Depends(get_redis)
):
    """Endpoint principal para interactuar con agentes ZNS"""
    
    start_time = datetime.now()
    
    # Validar agente existe
    agent = agent_manager.get_agent(request.agent_id)
    if not agent:
        REQUEST_COUNT.labels(agent=request.agent_id, method="POST", status="404").inc()
        raise HTTPException(404, f"Agente {request.agent_id} no encontrado")
    
    if agent["metadata"]["status"] != "active":
        REQUEST_COUNT.labels(agent=request.agent_id, method="POST", status="503").inc()
        raise HTTPException(503, f"Agente {request.agent_id} no disponible")
    
    # Generar session_id
    session_id = request.session_id or f"zns_{uuid.uuid4().hex[:12]}"
    
    try:
        # Obtener contexto de sesión
        session_key = f"session:{session_id}"
        session_data = await redis.get(session_key)
        
        if session_data:
            session_context = json.loads(session_data)
        else:
            session_context = {
                "agent_id": request.agent_id,
                "messages": [],
                "created_at": datetime.now().isoformat(),
                "metadata": request.context
            }
        
        # Preparar mensajes para LLM
        system_prompt = agent["system_prompt"]
        if request.context:
            system_prompt += f"\n\nContexto adicional:\n{json.dumps(request.context, indent=2)}"
        
        messages = [
            {"role": "system", "content": system_prompt},
            *session_context["messages"],
            {"role": "user", "content": request.message}
        ]
        
        # Limitar historial (últimos 10 mensajes)
        if len(messages) > 21:  # system + 20 mensajes
            messages = [messages[0]] + messages[-20:]
        
        # Llamar a Text Generation WebUI
        payload = {
            "mode": "chat",
            "messages": messages,
            "max_tokens": min(request.max_tokens, settings.MAX_TOKENS),
            "temperature": request.temperature,
            "top_p": 0.9,
            "repetition_penalty": 1.1,
            "stop": ["Human:", "Assistant:", "Usuario:", "Agente:"]
        }
        
        async with httpx.AsyncClient(timeout=120.0) as client:
            response = await client.post(
                f"{settings.TEXTGEN_URL}/chat/completions",
                json=payload
            )
            response.raise_for_status()
            llm_response = response.json()
        
        assistant_message = llm_response["choices"][0]["message"]["content"]
        token_usage = llm_response.get("usage", {"total_tokens": 0, "prompt_tokens": 0, "completion_tokens": 0})
        
        # Actualizar sesión
        session_context["messages"].extend([
            {"role": "user", "content": request.message, "timestamp": datetime.now().isoformat()},
            {"role": "assistant", "content": assistant_message, "timestamp": datetime.now().isoformat()}
        ])
        
        # Guardar en Redis (TTL 2 horas)
        await redis.setex(session_key, 7200, json.dumps(session_context, default=str))
        
        # Calcular tiempo de procesamiento
        processing_time = (datetime.now() - start_time).total_seconds()
        
        # Métricas
        REQUEST_COUNT.labels(agent=request.agent_id, method="POST", status="200").inc()
        REQUEST_DURATION.labels(agent=request.agent_id).observe(processing_time)
        AGENT_USAGE.labels(agent_id=request.agent_id).inc()
        
        # Guardar en base de datos (background)
        background_tasks.add_task(
            save_conversation,
            session_id, request.agent_id, request.message, 
            assistant_message, request.context, processing_time, token_usage
        )
        
        response_data = AgentResponse(
            response=assistant_message,
            agent_id=request.agent_id,
            session_id=session_id,
            metadata={
                "agent_name": agent["info"]["name"],
                "methodology": "ZNS v2.0",
                "model": "textgen-webui",
                "temperature": request.temperature,
                "session_messages": len(session_context["messages"]) // 2
            },
            timestamp=datetime.now(),
            processing_time=processing_time,
            token_usage=token_usage
        )
        
        return response_data
        
    except httpx.HTTPError as e:
        REQUEST_COUNT.labels(agent=request.agent_id, method="POST", status="502").inc()
        logger.error(f"Error LLM: {e}")
        raise HTTPException(502, f"Error en motor LLM: {str(e)}")
    except Exception as e:
        REQUEST_COUNT.labels(agent=request.agent_id, method="POST", status="500").inc()
        logger.error(f"Error interno: {e}")
        raise HTTPException(500, f"Error interno: {str(e)}")

@celery.task
def save_conversation(session_id, agent_id, user_message, assistant_message, context, processing_time, token_usage):
    """Guardar conversación en base de datos (tarea asíncrona)"""
    import asyncio
    import asyncpg
    
    async def _save():
        conn = await asyncpg.connect(settings.DATABASE_URL)
        try:
            await conn.execute("""
                INSERT INTO conversations (
                    session_id, agent_id, user_message, assistant_message,
                    context, processing_time, token_usage, created_at
                ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
            """, session_id, agent_id, user_message, assistant_message,
                json.dumps(context), processing_time, json.dumps(token_usage), datetime.now()
            )
        finally:
            await conn.close()
    
    asyncio.run(_save())

@app.get("/sessions", response_model=List[SessionInfo], tags=["Sessions"])
async def list_sessions(redis = Depends(get_redis)):
    """Listar sesiones activas"""
    pattern = "session:*"
    keys = await redis.keys(pattern)
    
    sessions = []
    for key in keys[:50]:  # Limitar a 50 sesiones
        session_data = await redis.get(key)
        if session_data:
            data = json.loads(session_data)
            session_id = key.replace("session:", "")
            sessions.append(SessionInfo(
                session_id=session_id,
                agent_id=data.get("agent_id", "unknown"),
                created_at=datetime.fromisoformat(data.get("created_at", datetime.now().isoformat())),
                message_count=len(data.get("messages", [])) // 2,
                last_activity=datetime.now()  # Aproximado
            ))
    
    return sorted(sessions, key=lambda x: x.last_activity, reverse=True)

@app.delete("/sessions/{session_id}", tags=["Sessions"])
async def delete_session(session_id: str, redis = Depends(get_redis)):
    """Eliminar sesión específica"""
    session_key = f"session:{session_id}"
    deleted = await redis.delete(session_key)
    
    if deleted:
        return {"message": f"Sesión {session_id} eliminada"}
    else:
        raise HTTPException(404, f"Sesión {session_id} no encontrada")

@app.get("/metrics", tags=["System"])
async def get_metrics():
    """Métricas de Prometheus en formato texto"""
    return StreamingResponse(
        iter([prometheus_client.generate_latest().decode('utf-8')]),
        media_type="text/plain"
    )

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        app, 
        host="0.0.0.0", 
        port=8080,
        log_level=settings.LOG_LEVEL.lower(),
        access_log=True
    )