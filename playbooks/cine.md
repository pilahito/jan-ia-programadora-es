# Prompts de vídeo (local, 12 GB VRAM)

Jan escribe el plan. El render es en ComfyUI / LTX / Wan. Planos cortos: **4–8 s**.

## Plantilla por plano (inglés al motor)

```
[SHOT n] duration: 5s | 24fps | 832x480
subject: ...
action: ...
camera: slow push-in / static / handheld / pan
lighting: ...
style: original 2D-anime look, clean lines, NOT a known franchise
audio cue: ...
negative: watermark, logo, text, extra limbs, blur, lowres, brand
```

## RTX 3060 12 GB

- Preferir modelos **pequeños**: LTX-Video, Wan 1.3B, AnimateDiff. 720p solo si cabe.
- Una escena = varios planos, no un clip de 2 minutos.
- Upscale después (RealESRGAN) si hace falta.

## Estilo

Describe el look (cel-shade, grano de cine, nocturno neón). No “hazlo como [serie con copyright]”.
