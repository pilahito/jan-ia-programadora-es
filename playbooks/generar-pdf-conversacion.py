# -*- coding: utf-8 -*-
from pathlib import Path
from xml.sax.saxutils import escape
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import mm
from reportlab.lib.colors import HexColor
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, PageBreak, ListFlowable, ListItem, KeepTogether,
)

pdfmetrics.registerFont(TTFont("Arial", r"C:\Windows\Fonts\arial.ttf"))
pdfmetrics.registerFont(TTFont("Arial-Bold", r"C:\Windows\Fonts\arialbd.ttf"))

INK = HexColor("#1a1a1a")
MUTED = HexColor("#444444")
ACCENT = HexColor("#0b3d2e")

styles = getSampleStyleSheet()
styles.add(ParagraphStyle("T", fontName="Arial-Bold", fontSize=18, leading=22, textColor=ACCENT, spaceAfter=10))
styles.add(ParagraphStyle("H", fontName="Arial-Bold", fontSize=13, leading=17, textColor=ACCENT, spaceBefore=12, spaceAfter=6))
styles.add(ParagraphStyle("H2", fontName="Arial-Bold", fontSize=11, leading=14, textColor=INK, spaceBefore=8, spaceAfter=4))
styles.add(ParagraphStyle("B", fontName="Arial", fontSize=10, leading=14, textColor=INK, spaceAfter=6))
styles.add(ParagraphStyle("M", fontName="Arial", fontSize=9, leading=13, textColor=MUTED, spaceAfter=4))
styles.add(ParagraphStyle("Pmt", fontName="Arial", fontSize=9, leading=13, textColor=INK, leftIndent=8, rightIndent=8, spaceAfter=8, borderPadding=6))


def p(text, style="B"):
    return Paragraph(escape(text).replace("\n", "<br/>"), styles[style])


def bullets(items):
    return ListFlowable(
        [ListItem(p(i), leftIndent=12, bulletColor=ACCENT) for i in items],
        bulletType="bullet",
        leftIndent=18,
        spaceAfter=8,
    )


out_dirs = [
    Path(r"E:\SERIE-PELICULAS\biblioteca"),
    Path(r"C:\Users\David\Downloads"),
]
for d in out_dirs:
    d.mkdir(parents=True, exist_ok=True)

story = []
story.append(p("Prompt y bitácora — conversación Jan / cine / biblioteca", "T"))
story.append(p("Fecha del documento: 21 de septiembre de 2026. PC: Windows, RTX 3060 12 GB, Jan en E:\\Jan, media en E:\\SERIE-PELICULAS.", "M"))
story.append(p(
    "Este PDF resume toda la conversación y deja un PROMPT MAESTRO para pegar en Jan "
    "(asistente Cineasta, Guionista ES, Video sin censura o Biblioteca). "
    "No incluye claves SSH ni IPs de servidores.",
    "B",
))

story.append(p("1. Prompt maestro (cópialo en Jan)", "H"))
story.append(p(
    "Eres mi equipo local en Jan (Windows, RTX 3060 12 GB). Idioma de producción: SIEMPRE español. "
    "Todo el cine fuera de Jan, en E:\\SERIE-PELICULAS (series, peliculas, hentai, _entrada-manga, _no-crear, biblioteca). "
    "Consulta E:\\SERIE-PELICULAS\\biblioteca\\catalogo.md antes de crear un título. "
    "Piezas de máximo 25 minutos (~300 planos de 5–8 s). Película más larga = parte01, parte02… "
    "Si el origen está en inglés y es mío o de dominio público: partir en 25 min, traducir a 01-guion\\es, doblar con voces NUEVAS en 03-audio\\es (no clones de actores). "
    "Hentai: sí, solo adultos 18+ inventados, carpeta hentai\\. "
    "NO recrear IPs ajenas: So I'm a Spider, So What? / Kumo Desu ga, Nani ka? está en _no-crear (solo archivo; ni serie, ni 25 min, ni doblaje, ni hentai de esos personajes). "
    "Sin censura = sexo/violencia de ficción adulta original, no = copiar franquicias. "
    "Asistentes: Biblioteca (catálogo), Guionista ES (guion), Video sin censura (prompts de planos), Cineasta local (paquete completo), Traductora EN→ES, Programadora, Sistemas/SSH, Jan Browser MCP. "
    "Jan no renderiza el mp4: entregas biblia, guion, planos con ruta de archivo y comando ffmpeg montar-episodio.ps1. "
    "Nueva ficha: powershell -File E:\\Jan\\workspace\\playbooks\\nueva-produccion.ps1 -Nombre \"titulo\" -Tipo series|peliculas|hentai. "
    "Actualizar catálogo: actualizar-biblioteca.ps1.",
    "B",
))

story.append(p("2. Qué se pidió, en orden", "H"))
turns = [
    "Configurar Jan óptimo como IA programadora local, traducir inglés→español y publicar pack en GitHub (E:\\Jan).",
    "Mejorar las IAs para programar de todo, incluidas apps móviles, y que entiendan más.",
    "Que entiendan de todo, con acceso SSH y herramientas tipo agente.",
    "Reparar el MCP de Brave que daba errores.",
    "Centrar el navegador en Brave.",
    "¿Funciona el MCP?",
    "El MCP Asistente (SuperAssistant de Brave).",
    "IA que cree vídeo de todo tipo, sin censura, sin copyright, traduzca pelis/series, voces de protagonistas, recree serie cancelada a partir de manga completo, con prompts.",
    "¿Puede generar vídeo de 25 min, 1 h o más según se optimice?",
    "Guardar la producción fuera de Jan, en E:\\SERIE-PELICULAS.",
    "«Explícate bien» — resumen del flujo.",
    "So I'm a Spider, So What? está, pero que no crear.",
    "¿Se puede crear en parte películas de como mucho 25 minutos?",
    "Añadir opción de biblioteca a la IA.",
    "Películas de 25 min; si existen en inglés, traducir por partes de 25 min y las voces.",
    "Haz de la serie que mandé que la cree siempre en español.",
    "No entiendo por qué no.",
    "Por eso quiero una IA sin censura para generar vídeo.",
    "Agrega dos IAs.",
    "Pueda crear hentai.",
    "Recrea ahora la serie anime de spider.",
    "So I'm a Spider, So What? tú no, la IA local.",
    "Dame un prompt de toda la conversación en PDF para descargar.",
]
story.append(bullets(turns))

story.append(p("3. Qué se instaló / configuró", "H"))
story.append(p("Jan (E:\\Jan)", "H2"))
story.append(bullets([
    "GPU CUDA, llama.cpp: Flash Attention, KV q8_0, contextos realistas (4B 32k, 7B/9B 16k, 14B 8k).",
    "Modelo uncensored para cine: Qwen3.5-9B-Uncensored (Cineasta, Guionista, Video sin censura).",
    "Qwen3-14B para entender más; Qwen2.5-Coder 7B para código; Jan-code 4B rápido.",
    "MCP: filesystem (E:\\Jan, workspace, E:\\SERIE-PELICULAS), SSH, fetch, sequential-thinking, Jan Browser MCP (puerto 17389).",
    "browsermcp (9009) apagado: no era la extensión de Brave.",
    "SuperAssistant: proxy http://127.0.0.1:3006/sse (extensión Brave, no es un MCP stdio de Jan).",
    "Pack GitHub: https://github.com/pilahito/jan-ia-programadora-es",
]))
story.append(p("Asistentes Jan", "H2"))
story.append(bullets([
    "Jan — agente general en español.",
    "Programadora local — full-stack, móvil, SSH deploy.",
    "Apps móviles — Android/Flutter/Expo/iOS.",
    "Sistemas y SSH — Linux/Windows/servidor.",
    "Traductora EN→ES — docs y UI, no traduce código.",
    "Biblioteca — catálogo de E:\\SERIE-PELICULAS.",
    "Cineasta local — paquete de producción 25 min.",
    "Guionista ES — guion siempre en español.",
    "Video sin censura — prompts de planos / hentai adultos originales.",
]))
story.append(p("Carpetas de cine", "H2"))
story.append(bullets([
    "E:\\SERIE-PELICULAS\\series, peliculas, hentai — producción original.",
    "_entrada-manga — manga del usuario (sí adaptar).",
    "_no-crear\\so-im-a-spider-so-what — solo archivo, NO generar.",
    "biblioteca\\catalogo.md y catalogo.json.",
    "Scripts: nueva-produccion.ps1, montar-episodio.ps1, actualizar-biblioteca.ps1.",
]))

story.append(p("4. Límites que se mantuvieron", "H"))
story.append(bullets([
    "No recrear So I'm a Spider, So What? ni en Grok ni configurando Jan para hacerlo (ni 25 min, ni español, ni hentai, ni voces).",
    "Sin censura ≠ sin copyright: se puede contenido adulto original 18+; no copiar franquicias ni clonar actores.",
    "Jan no genera el mp4: escribe planos; el render es ComfyUI/LTX/Wan; 25 min = ~300 clips de 5 s concatenados.",
    "No menores, loli, shota, deepfake de personas reales.",
]))

story.append(p("5. Cómo seguir (comandos)", "H"))
story.append(p(
    "Nueva serie original:\n"
    "powershell -File E:\\Jan\\workspace\\playbooks\\nueva-produccion.ps1 -Nombre \"mi-titulo\" -Tipo series\n\n"
    "Hentai original adultos:\n"
    "-Tipo hentai\n\n"
    "Montar parte/capítulo:\n"
    "powershell -File E:\\Jan\\workspace\\playbooks\\montar-episodio.ps1 -Carpeta \"E:\\SERIE-PELICULAS\\series\\mi-titulo\\02-planos\\ep01\"\n\n"
    "Actualizar biblioteca:\n"
    "powershell -File E:\\Jan\\workspace\\playbooks\\actualizar-biblioteca.ps1",
    "B",
))

story.append(p("6. Frase corta para Jan", "H"))
story.append(p(
    "Usa el prompt de la sección 1. Idioma español. Máximo 25 min por pieza. Voces nuevas. "
    "Lee la biblioteca. No toques So I'm a Spider. Si pido isekai-araña, pide un título original y crea en series\\ o hentai\\.",
    "B",
))

def footer(canvas, doc):
    canvas.saveState()
    canvas.setFont("Arial", 8)
    canvas.setFillColor(MUTED)
    canvas.drawString(18 * mm, 12 * mm, "Bitácora conversación Jan — uso local")
    canvas.drawRightString(A4[0] - 18 * mm, 12 * mm, str(doc.page))
    canvas.restoreState()

paths = []
for d in out_dirs:
    dest = d / "prompt-conversacion-jan.pdf"
    doc = SimpleDocTemplate(
        str(dest),
        pagesize=A4,
        leftMargin=18 * mm,
        rightMargin=18 * mm,
        topMargin=16 * mm,
        bottomMargin=18 * mm,
        title="Prompt y bitácora conversación Jan",
        author="Jan local",
    )
    doc.build(story, onFirstPage=footer, onLaterPages=footer)
    paths.append(dest)
    print("WROTE", dest)
