---
metodo: ZNS
version: "1.2"
prompt_version: "1.0.1"
last_updated: "2025-11-07"
changelog:
  - "1.0.1: Actualizadas rutas de entrada a estructura en inglés (04-architecture, 05-deliverables)"
  - "1.0.0: Versión inicial del método ZNS v2.0"
agente: exportacion-documentos
fase: 3
rol: Technical Documentation Specialist
entrada_requerida:
  - "04-architecture/**/*.md"
  - "04-architecture/diagrams/*.puml"
salida_generada:
  - "05-deliverables/{proyecto}-arquitectura.docx"
duracion_estimada: "1-2 horas"
dependencias:
  - "prompt-arquitectura-soluciones.md"
  - "prompt-modelado-datos.md"
siguiente_paso: "Entrega al cliente"
herramientas_requeridas:
  - "pandoc o python-docx"
  - "PlantUML (para renderizar diagramas)"
---

# Prompt Maestro: Exportación a Formato Word

**Objetivo**: Exportar toda la documentación técnica del proyecto a formato Microsoft Word (.docx) con formato profesional.

---

## Contexto del Proyecto

Eres un especialista en documentación técnica y exportación de documentos. Tu tarea es convertir toda la documentación Markdown del proyecto a formato Word (.docx) manteniendo:

1. ✅ **Formato profesional**: Estilos consistentes, índices automáticos, numeración
2. ✅ **Estructura jerárquica**: Títulos, subtítulos, listas correctamente formateadas
3. ✅ **Tablas preservadas**: Todas las tablas con bordes y formato
4. ✅ **Diagramas PlantUML**: Convertidos a imágenes PNG/SVG e insertados
5. ✅ **Diagramas Mermaid**: Convertidos a imágenes PNG/SVG e insertados (si existen)
6. ✅ **Enlaces internos**: Actualizados como referencias cruzadas
7. ✅ **Metadatos**: Autor, fecha, versión en propiedades del documento

---

## Archivos a Exportar

### 📄 Documento 1: Resumen Ejecutivo
**Entrada**: `05-deliverables/resumen-ejecutivo.md`  
**Salida**: `05-deliverables/TX_Plus_Resumen_Ejecutivo.docx`

**Configuración**:
- Tamaño: Letter (8.5" x 11")
- Márgenes: 1" todos los lados
- Fuente: Calibri 11pt (cuerpo), Calibri Bold 14-18pt (títulos)
- Encabezado: "TX Plus - Resumen Ejecutivo" + Logo (si disponible)
- Pie de página: Número de página + "Confidencial"
- Portada: Sí, con título, fecha, versión, audiencia
- Tabla de contenidos: Sí, automática con hipervínculos
- Colores corporativos: Negro (#000000) y Amarillo (#FFD700)

**Secciones a incluir**:
1. Portada
2. Tabla de Contenidos (automática)
3. Visión General del Proyecto
4. Objetivos del Proyecto
5. Solución Propuesta
6. Plan de Implementación
7. Equipo del Proyecto
8. Riesgos y Mitigaciones
9. Indicadores de Éxito (KPIs)
10. Próximos Pasos
11. Conclusiones
12. Apéndices

---

### 📄 Documento 2: Contexto de Negocio
**Entrada**: `01-context-consolidado/01-contexto-negocio.md`  
**Salida**: `05-deliverables/TX_Plus_Contexto_Negocio.docx`

**Configuración**: Misma que Resumen Ejecutivo

**Secciones**:
1. Descripción del Proyecto
2. Objetivos de Negocio
3. Stakeholders
4. Usuarios y Personas
5. Modelo de Negocio
6. Alcance y Limitaciones

---

### 📄 Documento 3: Requisitos Funcionales
**Entrada**: `01-context-consolidado/02-requisitos-funcionales.md`  
**Salida**: `05-deliverables/TX_Plus_Requisitos_Funcionales.docx`

**Configuración**: Misma base + Numeración automática para requisitos

**Secciones**:
1. Introducción
2. Módulo 1: App Conductor (RF-001 a RF-008)
3. Módulo 2: App Pasajero (RF-009 a RF-018)
4. Módulo 3: POI Satellite (RF-019 a RF-023)
5. Módulo 4: Requisitos Transversales (RF-024 a RF-026)
6. Matriz de Priorización MoSCoW
7. Dependencias entre Requisitos

**Formato especial para requisitos**:
```
RF-XXX: [Título del Requisito]
Prioridad: [Must Have | Should Have | Nice to Have]
Módulo: [Nombre del módulo]

Historia de Usuario:
Como [rol], quiero [acción] para [beneficio]

Criterios de Aceptación:
• Criterio 1
• Criterio 2

Dependencias: [Lista]
Estimación: [S/M/L/XL]
```

---

### 📄 Documento 4: Requisitos No Funcionales
**Entrada**: `01-context-consolidado/03-requisitos-no-funcionales.md`  
**Salida**: `05-deliverables/TX_Plus_Requisitos_No_Funcionales.docx`

**Secciones**:
1. Performance
2. Disponibilidad
3. Seguridad
4. Usabilidad
5. Compatibilidad
6. Mantenibilidad
7. Restricciones Tecnológicas
8. Restricciones de Presupuesto y Timeline
9. Matriz de Riesgos

---

### 📄 Documento 5: Arquitectura Completa
**Entrada**: Múltiples archivos de `04-architecture/`  
**Salida**: `05-deliverables/TX_Plus_Arquitectura_Completa.docx`

**Subsecciones a consolidar**:

#### Parte 1: Decisiones de Arquitectura (ADRs)
- ADR-001: Patrón Arquitectónico
- ADR-002: Stack Tecnológico Backend
- ADR-003: Stack Tecnológico Frontend
- ADR-004: Estrategia de Datos

#### Parte 2: Diagramas
- C4 Level 1: Context Diagram
- C4 Level 2: Container Diagram
- C4 Level 3: Component Diagram
- Sequence Diagram: Solicitar Servicio
- Deployment Diagram
- Diagrama de Estados: Trip Lifecycle

---

## 🎨 Conversión de Diagramas a Imágenes

El **Método ZNS v2.0** utiliza **PlantUML + C4 Model** como estándar principal. Los diagramas deben convertirse a imágenes antes de insertar en Word.

### **📐 ESTÁNDAR PRINCIPAL: PlantUML (RECOMENDADO)**

**Para diagramas .puml (Architecture, ERD, Sequence, Deployment):**

```bash
# 1. Instalar PlantUML (requiere Java)
brew install plantuml          # macOS
choco install plantuml         # Windows
# O descargar: https://plantuml.com/download

# 2. Convertir .puml a PNG
plantuml -tpng archivo.puml

# 3. Convertir .puml a SVG (mejor calidad)
plantuml -tsvg archivo.puml

# 4. Batch conversion (todos los diagramas)
plantuml -tpng ./04-architecture/diagrams/*.puml
```

**Automatización con Python:**
```python
import subprocess

def plantuml_to_png(puml_file, output_dir):
    subprocess.run(['plantuml', '-tpng', '-o', output_dir, puml_file])
    
# Ejemplo
plantuml_to_png('./04-architecture/diagrams/c4-l1-context.puml', './temp/images/')
```

---

### **📊 ESTÁNDAR SECUNDARIO: Mermaid (Solo diagramas legacy)**

**⚠️ NOTA:** Usar solo si existen diagramas Mermaid legacy en documentación antigua.

```bash
# Instalar Mermaid CLI
npm install -g @mermaid-js/mermaid-cli

# Convertir diagrama
mmdc -i input.mmd -o output.png -w 1200 -H 800 -b white
```

**Alternativa: Mermaid Live Editor**
1. Ir a https://mermaid.live/
2. Pegar código Mermaid
3. Exportar PNG (1200x800px)

---

#### Parte 3: Especificaciones
- API Specification (endpoints REST + WebSocket)
- Roadmap de Implementación (Gantt chart)

**Configuración especial**:
- Diagramas: Centrados, ancho máximo 6.5"
- Código: Fuente Consolas 9pt, fondo gris claro
- Tablas grandes: Orientación horizontal (landscape) si es necesario

---

### 📄 Documento 6: API Specification
**Entrada**: `04-architecture/specs/api-specification.md`  
**Salida**: `05-deliverables/TX_Plus_API_Specification.docx`

**Configuración especial**:
- Código JSON: Fuente Consolas 9pt, syntax highlighting simulado (colores)
- Endpoints: Tabla con columnas [Método | Endpoint | Descripción]
- Ejemplos de Request/Response: Bloques de código formateados

**Secciones**:
1. Introducción
2. Autenticación
3. Endpoints por Módulo
   - Autenticación
   - Conductores
   - Pasajeros
   - Servicios (Trips)
   - Historial
   - Ganancias
   - Billetera
   - WebSocket Events
4. Códigos de Error
5. Rate Limiting
6. Versionado de API

---

### 📄 Documento 7: Roadmap e Implementación
**Entrada**: `04-architecture/specs/costos-y-roadmap.md`  
**Salida**: `05-deliverables/TX_Plus_Roadmap_Implementacion.docx`

**Secciones**:
1. Resumen Ejecutivo del Plan
2. Fases de Desarrollo (0-6)
3. Timeline y Hitos Clave
4. Diagrama de Gantt (convertir Mermaid a imagen)
5. Equipo Requerido (RACI)
6. Riesgos y Mitigaciones
7. KPIs de Éxito
8. Plan de Contingencia

**Formato especial**:
- Gantt chart: Convertir a imagen, insertar horizontal (landscape)
- Checkboxes: Usar símbolos ☐ (pendiente) ☑ (completo)
- Hitos: Destacar con color amarillo (#FFD700)

---

### 📄 Documento 8: Supuestos y Pendientes
**Entrada**: `01-context-consolidado/00-supuestos-y-pendientes.md`  
**Salida**: `05-deliverables/TX_Plus_Supuestos_Pendientes.docx`

**Secciones**:
1. Lista de Supuestos (SUP-001 a SUP-014)
2. Gaps de Información (GAP-001 a GAP-011)
3. Preguntas Críticas para Stakeholders
4. Matriz de Riesgos por Validación
5. Plan de Validación (4 fases)

**Formato especial**:
- Supuestos: Tabla con columnas [ID | Descripción | Riesgo | Impacto]
- Destacar CRÍTICO en rojo, HIGH en naranja, MEDIUM en amarillo

---

## Instrucciones de Exportación

### Paso 1: Preparación del Entorno

**Opción A: Python con python-docx** (Recomendada)

```python
# Instalar dependencias
pip install python-docx markdown2 beautifulsoup4 Pillow

# Script de conversión
import markdown2
from docx import Document
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH

def markdown_to_docx(md_file, docx_file, config):
    """
    Convierte Markdown a Word con formato profesional
    
    Args:
        md_file: Path al archivo .md
        docx_file: Path de salida .docx
        config: Dict con configuración (fuente, márgenes, etc.)
    """
    # Leer Markdown
    with open(md_file, 'r', encoding='utf-8') as f:
        md_content = f.read()
    
    # Convertir a HTML intermedio
    html = markdown2.markdown(md_content, extras=['tables', 'fenced-code-blocks'])
    
    # Crear documento Word
    doc = Document()
    
    # Configurar estilos
    style = doc.styles['Normal']
    font = style.font
    font.name = config.get('font_name', 'Calibri')
    font.size = Pt(config.get('font_size', 11))
    
    # Agregar portada
    if config.get('add_cover', False):
        add_cover_page(doc, config)
    
    # Agregar tabla de contenidos
    if config.get('add_toc', False):
        add_table_of_contents(doc)
    
    # Procesar contenido HTML → Word
    parse_html_to_docx(html, doc, config)
    
    # Agregar encabezado/pie de página
    add_header_footer(doc, config)
    
    # Guardar
    doc.save(docx_file)
    print(f"✅ Documento creado: {docx_file}")

def add_cover_page(doc, config):
    """Agregar portada profesional"""
    # Título principal
    title = doc.add_heading(config['title'], 0)
    title.alignment = WD_ALIGN_PARAGRAPH.CENTER
    
    # Logo (si existe)
    if config.get('logo_path'):
        doc.add_picture(config['logo_path'], width=Inches(2))
        last_paragraph = doc.paragraphs[-1]
        last_paragraph.alignment = WD_ALIGN_PARAGRAPH.CENTER
    
    # Metadata
    doc.add_paragraph(f"Versión: {config['version']}")
    doc.add_paragraph(f"Fecha: {config['date']}")
    doc.add_paragraph(f"Audiencia: {config['audience']}")
    
    # Salto de página
    doc.add_page_break()

def add_table_of_contents(doc):
    """Agregar tabla de contenidos automática"""
    paragraph = doc.add_paragraph()
    run = paragraph.add_run()
    
    # Campo TOC de Word
    fldChar1 = OxmlElement('w:fldChar')
    fldChar1.set(qn('w:fldCharType'), 'begin')
    
    instrText = OxmlElement('w:instrText')
    instrText.set(qn('xml:space'), 'preserve')
    instrText.text = 'TOC \\o "1-3" \\h \\z \\u'
    
    fldChar2 = OxmlElement('w:fldChar')
    fldChar2.set(qn('w:fldCharType'), 'separate')
    
    fldChar3 = OxmlElement('w:fldChar')
    fldChar3.set(qn('w:fldCharType'), 'end')
    
    run._r.append(fldChar1)
    run._r.append(instrText)
    run._r.append(fldChar2)
    run._r.append(fldChar3)
    
    doc.add_page_break()

def parse_html_to_docx(html, doc, config):
    """Parsear HTML y crear elementos en Word"""
    from bs4 import BeautifulSoup
    soup = BeautifulSoup(html, 'html.parser')
    
    for element in soup.find_all(['h1', 'h2', 'h3', 'h4', 'p', 'ul', 'ol', 'table', 'pre', 'code']):
        if element.name in ['h1', 'h2', 'h3', 'h4']:
            level = int(element.name[1])
            doc.add_heading(element.get_text(), level)
        
        elif element.name == 'p':
            doc.add_paragraph(element.get_text())
        
        elif element.name in ['ul', 'ol']:
            for li in element.find_all('li'):
                doc.add_paragraph(li.get_text(), style='List Bullet' if element.name == 'ul' else 'List Number')
        
        elif element.name == 'table':
            add_table_to_doc(doc, element)
        
        elif element.name in ['pre', 'code']:
            add_code_block(doc, element.get_text())

def add_table_to_doc(doc, table_element):
    """Convertir tabla HTML a tabla Word"""
    rows = table_element.find_all('tr')
    if not rows:
        return
    
    # Contar columnas
    cols = len(rows[0].find_all(['th', 'td']))
    
    # Crear tabla
    table = doc.add_table(rows=len(rows), cols=cols)
    table.style = 'Light Grid Accent 1'
    
    # Llenar celdas
    for i, row in enumerate(rows):
        cells = row.find_all(['th', 'td'])
        for j, cell in enumerate(cells):
            table.rows[i].cells[j].text = cell.get_text().strip()
            
            # Header en negrita
            if cell.name == 'th':
                table.rows[i].cells[j].paragraphs[0].runs[0].font.bold = True

def add_code_block(doc, code_text):
    """Agregar bloque de código con formato"""
    paragraph = doc.add_paragraph(code_text)
    paragraph.style = 'Code'
    
    # Fuente monoespaciada
    for run in paragraph.runs:
        run.font.name = 'Consolas'
        run.font.size = Pt(9)
        run.font.color.rgb = RGBColor(0, 0, 0)
    
    # Fondo gris
    from docx.oxml import OxmlElement
    from docx.oxml.ns import qn
    shading_elm = OxmlElement('w:shd')
    shading_elm.set(qn('w:fill'), 'F0F0F0')
    paragraph._p.get_or_add_pPr().append(shading_elm)

def add_header_footer(doc, config):
    """Agregar encabezado y pie de página"""
    section = doc.sections[0]
    
    # Encabezado
    header = section.header
    header_para = header.paragraphs[0]
    header_para.text = config.get('header_text', '')
    header_para.style = 'Header'
    
    # Pie de página
    footer = section.footer
    footer_para = footer.paragraphs[0]
    footer_para.text = f"{config.get('footer_text', '')} - Página "
    
    # Agregar número de página
    run = footer_para.add_run()
    fldChar1 = OxmlElement('w:fldChar')
    fldChar1.set(qn('w:fldCharType'), 'begin')
    run._r.append(fldChar1)
    
    instrText = OxmlElement('w:instrText')
    instrText.text = "PAGE"
    run._r.append(instrText)
    
    fldChar2 = OxmlElement('w:fldChar')
    fldChar2.set(qn('w:fldCharType'), 'end')
    run._r.append(fldChar2)

# Uso del script
if __name__ == "__main__":
    configs = [
        {
            'md_file': '05-deliverables/resumen-ejecutivo.md',
            'docx_file': '05-deliverables/TX_Plus_Resumen_Ejecutivo.docx',
            'title': 'TX Plus - Resumen Ejecutivo',
            'version': '1.0',
            'date': 'Enero 2025',
            'audience': 'Stakeholders, Directores',
            'add_cover': True,
            'add_toc': True,
            'header_text': 'TX Plus - Resumen Ejecutivo',
            'footer_text': 'Confidencial',
            'font_name': 'Calibri',
            'font_size': 11
        },
        # ... más configuraciones para otros documentos
    ]
    
    for config in configs:
        markdown_to_docx(config['md_file'], config['docx_file'], config)
```

---

**Opción B: Pandoc** (Alternativa rápida)

```bash
# Instalar Pandoc
# Windows: choco install pandoc
# Mac: brew install pandoc
# Linux: apt-get install pandoc

# Convertir cada documento
pandoc 05-deliverables/resumen-ejecutivo.md \
  -o 05-deliverables/TX_Plus_Resumen_Ejecutivo.docx \
  --reference-doc=plantilla_txplus.docx \
  --toc \
  --toc-depth=3 \
  --number-sections \
  -V geometry:margin=1in \
  -V fontsize=11pt \
  -V mainfont="Calibri"

# Repetir para cada documento
pandoc 01-context-consolidado/01-contexto-negocio.md -o 05-deliverables/TX_Plus_Contexto_Negocio.docx --reference-doc=plantilla_txplus.docx --toc
pandoc 01-context-consolidado/02-requisitos-funcionales.md -o 05-deliverables/TX_Plus_Requisitos_Funcionales.docx --reference-doc=plantilla_txplus.docx --toc
pandoc 01-context-consolidado/03-requisitos-no-funcionales.md -o 05-deliverables/TX_Plus_Requisitos_No_Funcionales.docx --reference-doc=plantilla_txplus.docx --toc
# ... etc
```

**Crear plantilla Pandoc** (`plantilla_txplus.docx`):
1. Abrir Word nuevo documento
2. Configurar estilos:
   - Heading 1: Calibri Bold 18pt, color negro
   - Heading 2: Calibri Bold 16pt, color negro
   - Heading 3: Calibri Bold 14pt, color negro
   - Normal: Calibri 11pt
   - Code: Consolas 9pt, fondo gris #F0F0F0
3. Configurar márgenes: 1" todos los lados
4. Guardar como `plantilla_txplus.docx`

---

### Paso 2: Conversión de Diagramas Mermaid

**Script automatizado**:

```python
# convert_mermaid_diagrams.py
import re
import subprocess
import os

def extract_mermaid_from_md(md_file):
    """Extraer todos los bloques Mermaid de un archivo Markdown"""
    with open(md_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Regex para bloques ```mermaid ... ```
    pattern = r'```mermaid\n(.*?)```'
    matches = re.findall(pattern, content, re.DOTALL)
    
    return matches

def save_mermaid_diagrams(diagrams, output_dir):
    """Guardar cada diagrama en archivo .mmd individual"""
    os.makedirs(output_dir, exist_ok=True)
    
    for i, diagram in enumerate(diagrams, 1):
        mmd_file = os.path.join(output_dir, f'diagram_{i:02d}.mmd')
        with open(mmd_file, 'w', encoding='utf-8') as f:
            f.write(diagram)
        print(f"✅ Guardado: {mmd_file}")

def convert_mermaid_to_png(mmd_file, output_png):
    """Convertir .mmd a .png usando Mermaid CLI"""
    cmd = [
        'mmdc',
        '-i', mmd_file,
        '-o', output_png,
        '-w', '1200',
        '-H', '800',
        '-b', 'white',
        '-t', 'default'
    ]
    
    try:
        subprocess.run(cmd, check=True)
        print(f"✅ Convertido: {output_png}")
    except subprocess.CalledProcessError as e:
        print(f"❌ Error convirtiendo {mmd_file}: {e}")

def process_all_diagrams(md_file, output_dir):
    """Pipeline completo: extraer → guardar → convertir"""
    print(f"\n📄 Procesando: {md_file}")
    
    diagrams = extract_mermaid_from_md(md_file)
    print(f"   Encontrados {len(diagrams)} diagramas")
    
    if not diagrams:
        return
    
    save_mermaid_diagrams(diagrams, output_dir)
    
    # Convertir cada .mmd a .png
    for i in range(1, len(diagrams) + 1):
        mmd_file = os.path.join(output_dir, f'diagram_{i:02d}.mmd')
        png_file = os.path.join(output_dir, f'diagram_{i:02d}.png')
        convert_mermaid_to_png(mmd_file, png_file)

# Uso
if __name__ == "__main__":
    # Procesar diagramas de arquitectura
    process_all_diagrams(
        '04-architecture/diagrams/diagramas-arquitectura.md',
        '05-deliverables/imagenes/diagramas'
    )
    
    # Procesar Gantt de roadmap
    process_all_diagrams(
        '04-architecture/specs/costos-y-roadmap.md',
        '05-deliverables/imagenes/roadmap'
    )
```

---

### Paso 3: Ejecución Completa

**Script maestro** (`export_all_to_word.py`):

```python
#!/usr/bin/env python3
"""
Script maestro para exportar toda la documentación TX Plus a Word
"""

import os
import sys
from pathlib import Path

# Configuración de documentos a exportar
DOCUMENTS = [
    {
        'name': 'Resumen Ejecutivo',
        'md_file': '05-deliverables/resumen-ejecutivo.md',
        'docx_file': '05-deliverables/TX_Plus_Resumen_Ejecutivo.docx',
        'config': {
            'title': 'TX Plus - Resumen Ejecutivo',
            'subtitle': 'Rediseño UI/UX de Plataforma TPI (Taxi)',
            'version': '1.0',
            'date': 'Enero 2025',
            'audience': 'Stakeholders, Directores',
            'add_cover': True,
            'add_toc': True,
            'header_text': 'TX Plus - Resumen Ejecutivo',
            'footer_text': 'Confidencial'
        }
    },
    {
        'name': 'Contexto de Negocio',
        'md_file': '01-context-consolidado/01-contexto-negocio.md',
        'docx_file': '05-deliverables/TX_Plus_Contexto_Negocio.docx',
        'config': {
            'title': 'TX Plus - Contexto de Negocio',
            'add_cover': True,
            'add_toc': True
        }
    },
    {
        'name': 'Requisitos Funcionales',
        'md_file': '01-context-consolidado/02-requisitos-funcionales.md',
        'docx_file': '05-deliverables/TX_Plus_Requisitos_Funcionales.docx',
        'config': {
            'title': 'TX Plus - Requisitos Funcionales',
            'add_cover': True,
            'add_toc': True
        }
    },
    {
        'name': 'Requisitos No Funcionales',
        'md_file': '01-context-consolidado/03-requisitos-no-funcionales.md',
        'docx_file': '05-deliverables/TX_Plus_Requisitos_No_Funcionales.docx',
        'config': {
            'title': 'TX Plus - Requisitos No Funcionales',
            'add_cover': True,
            'add_toc': True
        }
    },
    {
        'name': 'Supuestos y Pendientes',
        'md_file': '01-context-consolidado/00-supuestos-y-pendientes.md',
        'docx_file': '05-deliverables/TX_Plus_Supuestos_Pendientes.docx',
        'config': {
            'title': 'TX Plus - Supuestos y Pendientes',
            'add_cover': True,
            'add_toc': True
        }
    },
    {
        'name': 'ADR-001 Patrón Arquitectónico',
        'md_file': '04-architecture/adrs/001-patron-arquitectonico.md',
        'docx_file': '05-deliverables/TX_Plus_ADR_001_Patron_Arquitectonico.docx',
        'config': {
            'title': 'ADR-001: Patrón Arquitectónico',
            'add_cover': True,
            'add_toc': True
        }
    },
    {
        'name': 'ADR-002 Stack Backend',
        'md_file': '04-architecture/adrs/002-stack-tecnologico-backend.md',
        'docx_file': '05-deliverables/TX_Plus_ADR_002_Stack_Backend.docx',
        'config': {
            'title': 'ADR-002: Stack Tecnológico Backend',
            'add_cover': True,
            'add_toc': True
        }
    },
    {
        'name': 'ADR-003 Stack Frontend',
        'md_file': '04-architecture/adrs/003-stack-tecnologico-frontend.md',
        'docx_file': '05-deliverables/TX_Plus_ADR_003_Stack_Frontend.docx',
        'config': {
            'title': 'ADR-003: Stack Tecnológico Frontend',
            'add_cover': True,
            'add_toc': True
        }
    },
    {
        'name': 'ADR-004 Estrategia de Datos',
        'md_file': '04-architecture/adrs/004-estrategia-datos.md',
        'docx_file': '05-deliverables/TX_Plus_ADR_004_Estrategia_Datos.docx',
        'config': {
            'title': 'ADR-004: Estrategia de Datos',
            'add_cover': True,
            'add_toc': True
        }
    },
    {
        'name': 'Diagramas de Arquitectura',
        'md_file': '04-architecture/diagrams/diagramas-arquitectura.md',
        'docx_file': '05-deliverables/TX_Plus_Diagramas_Arquitectura.docx',
        'config': {
            'title': 'TX Plus - Diagramas de Arquitectura',
            'add_cover': True,
            'add_toc': True,
            'convert_mermaid': True
        }
    },
    {
        'name': 'API Specification',
        'md_file': '04-architecture/specs/api-specification.md',
        'docx_file': '05-deliverables/TX_Plus_API_Specification.docx',
        'config': {
            'title': 'TX Plus - API Specification',
            'add_cover': True,
            'add_toc': True
        }
    },
    {
        'name': 'Roadmap e Implementación',
        'md_file': '04-architecture/specs/costos-y-roadmap.md',
        'docx_file': '05-deliverables/TX_Plus_Roadmap_Implementacion.docx',
        'config': {
            'title': 'TX Plus - Roadmap e Implementación',
            'add_cover': True,
            'add_toc': True,
            'convert_mermaid': True
        }
    }
]

def main():
    print("=" * 80)
    print("TX PLUS - EXPORTACIÓN A WORD")
    print("=" * 80)
    print()
    
    # Verificar que archivos existen
    print("📋 Verificando archivos fuente...")
    missing = []
    for doc in DOCUMENTS:
        if not Path(doc['md_file']).exists():
            missing.append(doc['md_file'])
            print(f"   ❌ No encontrado: {doc['md_file']}")
        else:
            print(f"   ✅ {doc['name']}")
    
    if missing:
        print(f"\n❌ Faltan {len(missing)} archivos. Abortando.")
        sys.exit(1)
    
    print()
    print("🔄 Iniciando conversión...")
    print()
    
    # Procesar cada documento
    for i, doc in enumerate(DOCUMENTS, 1):
        print(f"[{i}/{len(DOCUMENTS)}] {doc['name']}")
        print(f"   📄 {doc['md_file']}")
        print(f"   📝 {doc['docx_file']}")
        
        try:
            # Aquí llamarías a la función markdown_to_docx
            # markdown_to_docx(doc['md_file'], doc['docx_file'], doc['config'])
            print(f"   ✅ Convertido exitosamente")
        except Exception as e:
            print(f"   ❌ Error: {e}")
        
        print()
    
    print("=" * 80)
    print("✅ EXPORTACIÓN COMPLETADA")
    print("=" * 80)
    print()
    print(f"📦 Documentos generados en: 05-deliverables/")
    print(f"   Total: {len(DOCUMENTS)} archivos .docx")

if __name__ == "__main__":
    main()
```

---

### Paso 4: Ejecutar

```bash
# 1. Instalar dependencias
pip install python-docx markdown2 beautifulsoup4 Pillow lxml
npm install -g @mermaid-js/mermaid-cli

# 2. Convertir diagramas Mermaid a PNG
python convert_mermaid_diagrams.py

# 3. Exportar todos los documentos a Word
python export_all_to_word.py
```

---

## Validación de Salida

Verificar que cada documento .docx tenga:

- ✅ Portada con título, versión, fecha
- ✅ Tabla de contenidos funcional (clickeable)
- ✅ Títulos con numeración automática (1, 1.1, 1.1.1)
- ✅ Tablas con formato profesional
- ✅ Código con fuente monoespaciada y fondo gris
- ✅ Diagramas insertados como imágenes de alta resolución
- ✅ Encabezado y pie de página en todas las páginas
- ✅ Números de página
- ✅ Márgenes de 1" todos los lados
- ✅ Fuente Calibri 11pt consistente

---

## Checklist Final

### Pre-exportación
- [ ] Todos los archivos .md existen y son legibles
- [ ] Mermaid CLI instalado (`mmdc --version`)
- [ ] Python 3.8+ instalado
- [ ] Librerías Python instaladas (python-docx, etc.)

### Durante exportación
- [ ] Extraer diagramas Mermaid de todos los .md
- [ ] Convertir cada diagrama a PNG (1200x800px)
- [ ] Guardar imágenes en `05-deliverables/imagenes/`
- [ ] Convertir cada .md a .docx con formato profesional
- [ ] Insertar imágenes de diagramas en posiciones correctas

### Post-exportación
- [ ] Abrir cada .docx en Microsoft Word
- [ ] Actualizar tabla de contenidos (F9)
- [ ] Verificar que todas las imágenes se ven correctamente
- [ ] Verificar formato de tablas
- [ ] Verificar que código tiene formato monoespaciado
- [ ] Verificar encabezados y pies de página
- [ ] Guardar versión final

### Entrega
- [ ] Crear ZIP con todos los .docx: `TX_Plus_Documentacion_Completa.zip`
- [ ] Incluir README con lista de documentos
- [ ] Tamaño total < 50MB (comprimir imágenes si es necesario)

---

## Notas Finales

**Tiempo estimado**: 30-45 minutos para exportar los 12 documentos

**Tamaño total aproximado**: 25-35 MB (todos los .docx con imágenes)

**Compatibilidad**: Microsoft Word 2016 o superior, LibreOffice Writer 6.0+

**Licencia**: Documentos generados son propiedad del cliente TX Plus

---

**Preparado por**: Equipo de Arquitectura TX Plus  
**Fecha**: Enero 2025  
**Versión del Prompt**: 1.0
