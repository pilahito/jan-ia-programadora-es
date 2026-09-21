# Modelos recomendados (GGUF, llama.cpp)

Jan solo carga **GGUF**. Descárgalos desde Hugging Face (Hub de Jan o Importar).

No subimos los `.gguf` a este repo: pesan varios GB y cada uno tiene su licencia.

## Según hardware

| Hardware | Modelo diario | Contexto | Para qué |
| --- | --- | --- | --- |
| GPU 8 GB / 16 GB RAM | Jan-code 4B Q4_K | 16–32k | Código rápido |
| GPU 12 GB (RTX 3060) | Qwen3 14B Q4_K_M | 8k | Entender de todo + SSH |
| GPU 12 GB, código | Qwen2.5-Coder 7B Q4_K_M | 16k | Apps (web, Android, Flutter) |
| Solo CPU, 32 GB RAM | Qwen2.5-Coder 7B Q4_K_M | 8–16k | Más lento, usable |

## Enlaces

- [Jan-code 4B GGUF](https://huggingface.co/janhq/Jan-code-4b-gguf)
- [Qwen2.5-Coder-7B-Instruct GGUF](https://huggingface.co/Qwen/Qwen2.5-Coder-7B-Instruct-GGUF)
- [Qwen3-14B GGUF](https://huggingface.co/Qwen/Qwen3-14B-GGUF)

Cuantización **Q4_K_M** (o IQ4_XS si te falta VRAM). Q8 solo si te sobra memoria.

## Ajustes llama.cpp que sí importan

1. Backend **CUDA** si tienes NVIDIA (no CPU).
2. **n-gpu-layers = 99** (todo el modelo en la GPU).
3. **Un modelo cargado a la vez**.
4. KV cache **q8_0** si quieres más contexto en 12 GB.
5. **Flash Attention = on**.
6. **Fit = on** para que baje el contexto si no cabe.

Números concretos para RTX 3060 12 GB: `presets/rtx3060-12gb.ini`.
