# Modelfiles

Ollama Modelfiles for the Mythos model family. These are ready to use with `ollama create`.

## Usage

```bash
# Create a custom model from a modelfile
ollama create my-mythos -f Modelfile.mythos-9b-unhinged

# Run it
ollama run my-mythos
```

## Customization

Each modelfile uses an Ollama registry reference in the `FROM` line (e.g., `FableForge-AI/mythos-9b-unhinged`). You can customize:

- **`SYSTEM`** — Change the system prompt to adjust behavior
- **`PARAMETER`** — Tweak temperature, top_p, top_k, and context length
- **`TEMPLATE`** — Modify the chat template (advanced)

## Models

| Modelfile | Base Model | Context |
|-----------|-----------|---------|
| `Modelfile.mythos-9b` | FableForge-AI/mythos-9b | 32K |
| `Modelfile.mythos-9b-enhanced` | FableForge-AI/mythos-9b-enhanced | 32K |
| `Modelfile.mythos-9b-unhinged` | FableForge-AI/mythos-9b-unhinged | 32K |
| `Modelfile.shellwhisperer-1.5b` | FableForge-AI/shellwhisperer | 16K |