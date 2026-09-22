# Doblaje EN → ES por partes de 25 min

Película o capítulo: **una parte = máximo 25 minutos** de diálogo + imagen.

## Qué sí

- Guion **tuyo** o dominio público en inglés → español natural por parte.
- Voces **nuevas** (ficha TTS), mismas en todas las partes del título.
- Timing aproximado para que quepa en 25 min.

## Qué no

- Doblar una peli/serie ajena (Netflix, cine, *So I'm a Spider*, etc.).
- Clonar al actor inglés. No “la voz del protagonista original”.

## Carpetas

```
peliculas\<slug>\
  01-guion\en\parte01.md     ← original EN
  01-guion\es\parte01.md     ← traducción ES
  03-audio\es\parte01\       ← wav/mp3 TTS por línea
  04-montaje\parte01.mp4     ← imagen + voces ES
```

## Flujo

1. Cortar el guion EN en bloques de ~25 min (no 1 h).
2. Traducir **solo esa parte** (asistente Traductora EN→ES o Cineasta).
3. Ficha de voz por personaje (una vez, se reutiliza):
   `nombre | edad | grave/agudo | acento ES | energía | motor TTS`
4. Líneas numeradas con segundos.
5. Generar TTS en `03-audio\es\parte01`. Mezclar al montar.

## Guion de doblaje

```
# parte01  dur_objetivo: 25:00  origen: en  destino: es
PERSONAJE: Kael | TTS: male 28 low-mid dry, Spanish (Spain), calm
L01  00:00-00:04  EN  We don't cross the river at night.
L01  00:00-00:04  ES  No cruzamos el río de noche.
```
