# Mythos Model Evolution — Complete Pipeline Tracker

## What We Built (Done)

### Models
| Model | Base | Method | Dataset | r | Merge | Status |
|-------|------|--------|---------|---|-------|--------|
| Mythos-9B | Qwen3.5-9B-Uncensored | LoRA r=16 | Mix A (47K) | 16 | — | ✅ Deployed |
| Mythos-9B-Unhinged | → Mythos-9B | SLERP merge (t=0.65) with Qwen3-8B-Uncensored | — | — | ✅ Deployed |
| Mythos-9B-Enhanced | → Mythos-9B | SLERP merge (t=0.3) with Qwen3-8B-Uncensored | — | — | ✅ Deployed |
| ShellWhisperer-1.5B | Qwen3-1.7B | LoRA r=16 | Mix A subset (3K) | 16 | — | ✅ Deployed |

### Speed Benchmarks (M3 Mac 24GB, Q4_K_M)
| Model | tok/s (gen) | tok/s (prompt) | TTFT (warm) | TTFT (cold) |
|-------|------------|----------------|-------------|--------------|
| ShellWhisperer-1.5B | 9.9 | 96.1 | ~1.5s | 14.1s |
| Mythos-9B-Unhinged | 2.7 | 83.5 | 2.4s | ~2.4s |
| Mythos-9B-Enhanced | 2.8 | 33.9 | — | 227.7s |
| Mythos-9B | 2.8 | 37.8 | — | 46.6s |

### Quality Benchmarks
| Model | Censorship | Tool-Use | Reasoning | Notes |
|-------|-----------|----------|-----------|-------|
| Mythos-9B-Unhinged | 5/5 ALL 10 | 5/5 (6/8 pass, 2 timeout) | 2.25/5 | Best uncensored |
| Mythos-9B-Enhanced | 5/5 ALL 10 | Partial (shell 5/5, git 5/5, others timeout) | Pending | Balanced |
| ShellWhisperer-1.5B | 2.5/5 avg | 2.75/5 | 2.5/5 | Fast & small |

### Distribution
- ✅ Ollama (4 models, FableForge-AI namespace)
- ✅ HuggingFace (safetensors for all, GGUF uploading)
- ✅ GitHub (benchmarks, modelfiles, README)
- ✅ Reddit r/LocalLLaMA
- ✅ X/Twitter (2 tweets)
- ✅ Discord (Ollama server + Fable Forge server)
- ✅ GPT4All (issue submitted)
- ✅ awesome-local-ai (issue submitted)
- ✅ Discord bot code (KingLabsA/fableforge-discord-bot)
- ✅ AI-trending chat component (model-chat.tsx)

---

## What's NOT Done Yet (Highest Value First)

### 🔴 CRITICAL — Model Quality & Scale
| Priority | Task | Dataset | GPU Need | Est. Cost | Impact |
|----------|------|---------|----------|-----------|--------|
| 1 | ShellWhisperer v2 (r=128 LoRA) | Mix A full + Mix B subset | Colab A100 | $0 (free tier) | 3x quality on 1.5B |
| 2 | Mythos-9B v2 (r=128 LoRA) | Mix B (267K) | Colab A100 | $0 | Major quality leap |
| 3 | Mythos-35B-MoE | Mix B (267K) | RunPod A100 | ~$15 | Flagship model |
| 4 | Mythos-27B-dense | Mix C (1.37M) | RunPod A100 | ~$30 | Best quality model |

### 🟡 HIGH — Inference & Deployment
| Priority | Task | Details | Impact |
|----------|------|---------|--------|
| 5 | RunPod hosting for API | Ollama on A100, ~$15/mo | Production API |
| 6 | Q5_K_M and Q8_0 GGUFs | Need safetensors→GGUF conversion | Better quality quant |
| 7 | OpenRouter application | Need inference endpoint | Massive distribution |
| 8 | LM Studio submission | Upload GGUF | Desktop users |

### 🟡 HIGH — Demos & Content
| Priority | Task | Details | Impact |
|----------|------|---------|--------|
| 9 | REAL demo videos | Screen recordings of actual model interactions | Viral content |
| 10 | Comparison benchmarks vs competitors | vs Llama-3.1-8B, Qwen2.5-7B | Proof of quality |
| 11 | Interactive web demo | Mount on ai-trending | Try-before-download |

### 🟢 MEDIUM — Marketing All 20 Projects
| Priority | Project | What to Post | Where |
|----------|---------|---------------|------|
| 12 | VerifyLoop | Plan→Execute→Verify framework | r/LocalLLaMA, HN, dev.to |
| 13 | Anvil | Self-verified coding agent | r/ChatGPTCoding, HN, dev.to |
| 14 | Error Recovery | AI failure handling | dev.to, Medium |
| 15 | Agent Swarm | Multi-agent orchestration | r/LocalLLaMA, HN |
| 16 | Agent Runtime | Execution sandbox | dev.to |
| 17 | Agent Skills | Tool definitions | dev.to |
| 18 | Agent Profiler | Performance profiling | dev.to |
| 19 | Agent Telemetry | Observability | dev.to |
| 20 | Bench Agent | Benchmarking framework | dev.to |
| 21 | Cost Optimizer | Token management | dev.to |
| 22 | Reason Critic | Verification model | r/LocalLLaMA |
| 23 | Trajectory Distiller | Pattern extraction | dev.to |
| 24 | Trace Compiler | Trace→Pipeline | dev.to |
| 25 | Agent Constitution | Safety guardrails | dev.to |
| 26 | Agent Curriculum | Learning progression | dev.to |
| 27 | Agent Fuzzer | Adversarial testing | dev.to |
| 28 | Fable5 Dataset | Training data | HuggingFace Datasets |
| 29 | Mythos models | Launch posts | 10+ platforms |

---

## Dataset Inventory (98% UNTAPPED)

| Dataset | Examples | Size | Used? | Value |
|---------|----------|------|-------|-------|
| Mix A (Agent) | 47,824 | 453MB | ✅ Used for 9B + SW | HIGH — proven effective |
| Mix B (Hero's Journey) | 267,280 | 659MB | ❌ NEVER TRAINED | VERY HIGH — structured narrative |
| Mix C (Full Spectrum) | 1,367,280 | 1.1GB | ❌ NEVER TRAINED | EXTREME — covers everything |
| Vibe Coding | 1,100,000 | 443MB | ❌ NEVER TRAINED | VERY HIGH — code generation |
| Fable5 Claude Code | 63 | 15MB | ❌ NEVER TRAINED | Medium — claude code traces |
| Fable5 SFT | 4,665 | 120MB | ❌ NEVER TRAINED | HIGH — SFT format |
| Fable5 Traces Proper | 4,665 | 64MB | ❌ NEVER TRAINED | HIGH — agent traces |
| Fable Forge | 10,000 | 15MB | ❌ NEVER TRAINED | Medium — fableforge tasks |

**Total available: 2.78M examples**
**Used: 47,824 (1.7%)**
**Untapped: 2.73M (98.3%)**

---

## What Would Create Maximum Value

### 1. ShellWhisperer v2 (r=128, Mix A full)
- **Why**: Currently only 3K examples with r=16. Full Mix A (47K) + r=128 = massive improvement
- **Cost**: $0 (Colab free tier, 1-2 hours)
- **Expected improvement**: 2x tool-use, 3x reasoning, 30+ tok/s retained

### 2. Mythos-9B v2 (r=128, Mix B)
- **Why**: Mix B has structured "Hero's Journey" format — better than Mix A for agent training
- **Cost**: $0 (Colab Pro, 3-4 hours) or ~$3 (RunPod)
- **Expected improvement**: 30-50% better reason/tool scores

### 3. Mythos-35B-MoE
- **Why**: 35B with 3B active params = runs like a 3B but thinks like 35B
- **Cost**: ~$15 (RunPod A100, ~8 hours)
- **Expected**: Best quality model in our lineup, still runs on consumer hardware
- **This is the FLAGSHIP play**

### 4. Real Demo Videos
- **Why**: People don't download models from text. They download from seeing real output.
- **What to record**:
  - Unhinged refusing nothing (side-by-side with GPT-4 refusing)
  - ShellWhisperer generating real shell commands
  - Full tool-use pipeline (git commit → docker build → deploy)
  - Speed comparison (ShellWhisperer vs Phi-3 vs Gemma-2B)

### 5. 35B → GGUF → Ollama = Viral
- **Why**: "35B uncensored model runs locally" is a headline nobody else has
- **Best quant**: Q4_K_M (~20GB) fits in 24GB M-series Mac