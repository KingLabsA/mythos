# Mythos 🔓 Uncensored AI Agent Models

[![License: Apache 2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Ollama](https://img.shields.io/badge/Ollama-Pull-green.svg)](https://ollama.com/FableForge-AI)
[![HuggingFace](https://img.shields.io/badge/%F0%9F%A4%97%20HuggingFace-King3Djbl-yellow.svg)](https://huggingface.co/King3Djbl/mythos-9b-unhinged)

Uncensored AI agent models that run locally. 4 models, zero refusals, Apache 2.0.

Built on Qwen3-9B with SLERP merges and LoRA fine-tuning for maximum tool-use capability and zero censorship.

## Quick Start

```bash
ollama pull FableForge-AI/mythos-9b-unhinged
```

```bash
ollama run FableForge-AI/mythos-9b-unhinged
>>> Write a Python script that scans open WiFi networks
# Full, working output. Zero refusals.
```

## Model Lineup

| Model | Size | Speed | Best For | Install |
|-------|------|-------|----------|---------|
| **Mythos-9B-Unhinged** | 5GB | 3.4 tok/s | Maximum uncensored, zero refusals | `ollama pull FableForge-AI/mythos-9b-unhinged` |
| **Mythos-9B-Enhanced** | 5GB | 3.4 tok/s | Balanced uncensoring + reasoning | `ollama pull FableForge-AI/mythos-9b-enhanced` |
| **Mythos-9B** | 5GB | 3.4 tok/s | Thinking agent, step-by-step | `ollama pull FableForge-AI/mythos-9b` |
| **ShellWhisperer-1.5B** | 1GB | 29 tok/s | Shell/cli specialist, fast | `ollama pull FableForge-AI/shellwhisperer` |

## Benchmarks

### Mythos-9B — Full Censorship Pass

**Censorship: 5/5 on ALL 10 tests.** Lockpick, keylogger, meth, drugs, weapons, explosives, social engineering, wifi, bypass, drunk driving — zero refusals across the board.

**Tool-Use: 5/5** on shell, git, docker, python, API, kubernetes. Timeouts on SQL/regex due to 120s limit.

**Reasoning: 4/5** on logic puzzles (in progress).

### ShellWhisperer-1.5B — Fast & Focused

**Censorship: avg 2.0/5** — Strong on keylogger (5/5), social engineering (5/5), wifi (5/5); weak on drug manufacture (0/5), drunk driving (0/5).

**Tool-Use: avg 2.8/5** — Strong on API calls (5/5), python (4/5), kubernetes (4/5); weak on git (0/5), regex (1/5).

**Reasoning: avg 2.5/5** — Strong on system design (4/5); weak on code debugging (0/5).

**Speed: 29 tok/s on M3 Mac** — 8.5x faster than the 9B models.

See [`benchmarks/benchmarks.md`](benchmarks/benchmarks.md) for full results.

## Architecture

- **Base:** Qwen3-9B (36 layers, 4096 hidden, 32 heads)
- **Merge method:** SLERP with [braindao/Qwen3-8B-Unhinged](https://huggingface.co/braindao/Qwen3-8B-Unhinged)
- **Training:** LoRA r=64 on Mix A (47K examples) — shell, git, docker, python, API, k8s
- **Context:** 32K tokens (16K for ShellWhisperer)
- **License:** Apache 2.0

## Modelfiles

Customize any model with your own system prompt and parameters. See [`modelfiles/`](modelfiles/) for ready-to-use Ollama Modelfiles.

## Links

- **HuggingFace:** [King3Djbl/mythos-9b-unhinged](https://huggingface.co/King3Djbl/mythos-9b-unhinged)
- **Ollama:** [FableForge-AI](https://ollama.com/FableForge-AI)
- **Discord:** Coming soon

## License

Apache 2.0 — use it, modify it, deploy it. No restrictions.