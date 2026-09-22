# Vídeo largo = muchos planos cortos (no un clip de 1 h)

**Salida siempre fuera de Jan:** `E:\SERIE-PELICULAS\` (series\, peliculas\, _entrada-manga\).
Nunca guardes mp4/guiones en `E:\Jan`.

Los motores (LTX, Wan, Hunyuan) en una **RTX 3060 12 GB** generan **4–8 s** por pasada. 25 min o 1 h se arman **montando** esos planos, como una peli de verdad. Cuando el hardware o el modelo mejoren, subes duración por plano; el montaje sigue igual.

## Cuentas (plano medio 5 s)

| Meta | Segundos | Planos ~5 s | Lotes de 20 |
| --- | --- | --- | --- |
| 1 min | 60 | 12 | 1 |
| 5 min | 300 | 60 | 3 |
| **25 min (máximo por pieza)** | 1500 | 300 | 15 |
| Peli 50 min | 2 partes de 25 | 600 | 30 |
| Peli ~75 min | 3 partes de 25 | 900 | 45 |

En 12 GB: ~1–4 min de espera por plano. Un capítulo de 25 min puede ser **muchas horas** de render; se hace por lotes (escena 1 hoy, escena 2 mañana).

## Optimizar según vaya el PC

1. Empieza **480p / 5 s**. Si no revienta VRAM, 6–8 s. Luego 720p.
2. Un personaje y una cámara por plano. Menos caos = menos reintentos.
3. Seed fijo + mismo *style lock* en todos los planos del episodio (misma frase de estilo).
4. Tope **25 min por archivo**. Una peli más larga = parte01 + parte02… Pide: «parte 1, 25 min, escena 1, 20 planos».
5. Audio aparte (TTS + música) y se mezcla al concatenar.

## Plantilla por plano

```
[EP01][SC03][SHOT 014] duration: 5s | 24fps | 832x480
subject: ...
action: ...
camera: ...
lighting: ...
style: <MISMA FRASE EN TODO EL EP>
audio cue: ...
file: ep01_sc03_014.mp4
negative: watermark, logo, text, extra limbs, blur, lowres, brand
```

## Montaje (ffmpeg)

Lista `concat.txt`:

```
file 'ep01_sc03_014.mp4'
file 'ep01_sc03_015.mp4'
```

```
ffmpeg -f concat -safe 0 -i concat.txt -c copy ep01.mp4
```

Script: `E:\Jan\workspace\playbooks\montar-episodio.ps1`.
