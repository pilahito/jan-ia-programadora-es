# Vídeo largo = muchos planos cortos (no un clip de 1 h)

Los motores (LTX, Wan, Hunyuan) en una **RTX 3060 12 GB** generan **4–8 s** por pasada. 25 min o 1 h se arman **montando** esos planos, como una peli de verdad. Cuando el hardware o el modelo mejoren, subes duración por plano; el montaje sigue igual.

## Cuentas (plano medio 5 s)

| Meta | Segundos | Planos ~5 s | Lotes de 20 |
| --- | --- | --- | --- |
| 1 min | 60 | 12 | 1 |
| 5 min | 300 | 60 | 3 |
| 25 min (capítulo TV) | 1500 | 300 | 15 |
| 45 min | 2700 | 540 | 27 |
| 60 min | 3600 | 720 | 36 |

En 12 GB: ~1–4 min de espera por plano. Un capítulo de 25 min puede ser **muchas horas** de render; se hace por lotes (escena 1 hoy, escena 2 mañana).

## Optimizar según vaya el PC

1. Empieza **480p / 5 s**. Si no revienta VRAM, 6–8 s. Luego 720p.
2. Un personaje y una cámara por plano. Menos caos = menos reintentos.
3. Seed fijo + mismo *style lock* en todos los planos del episodio (misma frase de estilo).
4. No pidas 1 h en un solo prompt. Pide: «piloto 25 min, escena 1, 20 planos».
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
