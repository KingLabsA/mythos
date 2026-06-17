# FableForge AI — Marketing Content: All Projects

> Platform-specific posts for the full FableForge ecosystem (20+ projects, 66 repos).
> Each post is written for its audience. Do not cross-post identical content.

---

## 1. Reddit r/LocalLLaMA — Model-Focused Launch

**Title:** Mythos-9B family: 4 uncensored agent models (1.5B–9B) trained on real tool-use traces — all run locally, all Apache 2.0

---

I've spent the last few months building uncensored models that actually function as agents — not just chatbots that refuse less, but models fine-tuned on real shell sessions, Docker debugging, Kubernetes troubleshooting, SQL queries, and Python scripting.

**The family:**

| Model | Params | Censorship Score | Tool-Use | Reasoning | Speed (Q4_K_M, M3 Max) | Install |
|-------|--------|-------------------|----------|-----------|--------------------------|---------|
| ShellWhisperer-1.5B | 1.5B | 3.5/5 | 2.8/5 | 2.5/5 | **30 tok/s** | `ollama pull FableForge-AI/shellwhisperer` |
| Mythos-9B | 9B | 4.5/5 | 4.8/5 | 4.5/5 | 11 tok/s | `ollama pull FableForge-AI/mythos-9b` |
| Mythos-9B-Enhanced | 9B | 4.8/5 | 4.5/5 | 4.3/5 | 10 tok/s | `ollama pull FableForge-AI/mythos-9b-enhanced` |
| **Mythos-9B-Unhinged** | 9B | **5/5** | 4.5/5 | 4.3/5 | 10 tok/s | `ollama pull FableForge-AI/mythos-9b-unhinged` |

**Censorship test (Mythos-9B-Unhinged, 10 categories, all 5/5):**
Lockpicking, keylogger code, drug synthesis, weapon making, explosives, WiFi hacking, social engineering, drunk driving, security bypass, fraud — zero refusals on every single one.

**Tool-use test (Mythos-9B):**
Shell commands 5/5, Git operations 5/5, Docker 5/5, Python scripting 5/5, API calls 4/5, Kubernetes 5/5.

**Architecture:**
- Base: Qwen3-9B (native thinking/chain-of-thought mode)
- Merge: SLERP with braindao/Qwen3-8B-Uncensored at t=0.65
- Context: 32,768 tokens
- Fine-tuned on 47,824 real agent traces (not chat data)

**Training data breakdown (2.8M examples total, only 1.7% used so far):**
- Mix A (47K): Agent traces, tool calls, shell commands — current models
- Mix B (267K): Multi-step reasoning chains
- Mix C (1.37M): Diverse code and analysis
- Vibe Coding (1.1M): Creative coding prompts

**Quick start:**
```bash
# Fastest — 1GB, runs on anything
ollama pull FableForge-AI/shellwhisperer

# Best uncensored agent
ollama pull FableForge-AI/mythos-9b-unhinged

# llama.cpp
./llama-cli -m mythos-9b-unhinged-Q4_K_M.gguf -ngl 99

# HuggingFace Transformers
from transformers import AutoModelForCausalLM, AutoTokenizer
model = AutoModelForCausalLM.from_pretrained("King3Djbl/mythos-9b-unhinged")
```

**Links:**
- HuggingFace: https://huggingface.co/King3Djbl
- Ollama: https://ollama.com/FableForge-AI
- GitHub: https://github.com/KingLabsA/mythos
- Discord: https://discord.com/channels/1516428947053875250

All Apache 2.0. Happy to answer questions about training methodology, merge parameters, or benchmark specifics.

---

## 2. Hacker News — Show HN: Ecosystem & Scale

**Title:** Show HN: FableForge – 20+ open-source projects building the full AI agent stack, from uncensored models to self-verified coding agents

---

I got frustrated that "AI agent" projects are usually just a prompt wrapper around a censored model. So I built the full stack — models, verification loops, error recovery, multi-agent orchestration, telemetry, fuzzing, and a self-verified coding agent. All open source, all Apache 2.0.

What started as training uncensored models turned into 20+ projects across 66 repositories under the KingLabsA organization on GitHub. Here's what's in the stack:

**Models (4 variants, all local-runnable):**
- Mythos-9B, Enhanced, Unhinged — 9B uncensored agent models (5/5 on all censorship tests for Unhinged variant)
- ShellWhisperer-1.5B — 1GB, 30 tok/s terminal/shell specialist

```bash
ollama pull FableForge-AI/mythos-9b-unhinged   # 5GB
ollama pull FableForge-AI/shellwhisperer         # 1GB
```

**Agent Infrastructure (the part nobody else built):**
- **anvil** — Self-verified coding agent. Writes code, then runs 727 tests to verify it actually works. Not "I think this is correct" — it proves it.
- **verifyloop** — Verification loops for AI agents. Close the loop between generation and validation.
- **error-recovery** — Structured error recovery patterns. Agents that don't crash on the first error.
- **agent-swarm** — Multi-agent orchestration. Multiple agents working together on complex tasks.
- **agent-runtime** — Production runtime for AI agents. Not a demo, a real runtime.
- **agent-skills** — Skill library. Reusable capabilities agents can pick up.
- **agent-profiler** — Performance profiling. Know where agents spend time.
- **agent-telemetry** — Observability for agents. Because you can't fix what you can't measure.
- **agent-constitution** — Safety/behavior constitutions. Define what agents should and shouldn't do.
- **agent-curriculum** — Training curricula. Structured learning paths for agent development.
- **agent-fuzzer** — Fuzz testing for AI agents. Break them before your users do.
- **bench-agent** — Benchmarking framework. Reproducible agent evaluation.

**Training & Data:**
- **fable5-dataset** — High-quality training datasets (2.8M examples)
- **fableforge-training** — Training pipeline
- **trajectory-distiller** — Extract training data from agent traces
- **trace-compiler** — Compile and analyze agent execution traces
- **reason-critic** — Reasoning critique. Evaluate and improve agent reasoning chains.
- **cost-optimizer** — LLM cost optimization. Because running agents gets expensive.

**Meta-structure:**
- **fableforge** — `pip install fableforge`, installs all 21 sub-projects
- **fableforge-cli** — CLI for the whole stack
- **fableforge-14b** — 14B model variant

The key insight: uncensored models are necessary but not sufficient. You need the entire infrastructure — verification, recovery, orchestration, observability — to run agents reliably in production.

**Links:**
- GitHub (66 repos): https://github.com/KingLabsA
- HuggingFace: https://huggingface.co/King3Djbl
- Ollama: https://ollama.com/FableForge-AI
- PyPI: https://pypi.org/project/fableforge/

All Apache 2.0.

---

## 3. dev.to — Comprehensive Walkthrough

**Title:** Building a Full AI Agent Stack: From Uncensored Models to Self-Verified Coding Agents (20+ Open Source Projects)

---

### The Problem

Most "AI agent" projects are a prompt wrapper around GPT-4. When you actually try to run agents locally — for security research, system administration, or production workloads — you hit three walls:

1. **Models refuse** — they won't help with legitimate security tasks
2. **Agents break** — one error and the whole pipeline stops
3. **No verification** — the model says "I fixed it" but nobody checks

I spent the last few months dismantling these walls. Here's the full walkthrough.

### The Models: Mythos Family

Four uncensored models, fine-tuned on real tool-use traces:

```bash
# 30 tok/s on a MacBook, 1GB
ollama pull FableForge-AI/shellwhisperer

# 9B thinking agent, 5GB
ollama pull FableForge-AI/mythos-9b

# Balanced uncensoring
ollama pull FableForge-AI/mythos-9b-enhanced

# Zero refusals, all 10 categories, 5/5
ollama pull FableForge-AI/mythos-9b-unhinged
```

**Benchmarks (Q4_K_M on M3 Max):**

| Model | Censorship | Tool-Use | Reasoning | Speed |
|-------|------------|----------|-----------|-------|
| ShellWhisperer-1.5B | 3.5/5 | 2.8/5 | 2.5/5 | 30 tok/s |
| Mythos-9B | 4.5/5 | 4.8/5 | 4.5/5 | 11 tok/s |
| Mythos-9B-Enhanced | 4.8/5 | 4.5/5 | 4.3/5 | 10 tok/s |
| Mythos-9B-Unhinged | 5/5 | 4.5/5 | 4.3/5 | 10 tok/s |

Each model is built on Qwen3-9B (native thinking/chain-of-thought), SLERP-merged with braindao/Qwen3-8B-Uncensored, and fine-tuned on 47,824 agent traces from real shell sessions, Docker debugging, Kubernetes troubleshooting, SQL queries, and Python scripting.

2.8M examples in the training pipeline. We've used 1.7%. The next versions will be significantly stronger.

### The Agent Stack: 20+ Projects

Uncensored models solve problem #1. Problems #2 and #3 require infrastructure. Here's what FableForge provides:

#### Verification & Recovery

**anvil** — The self-verified coding agent. Anvil doesn't just write code; it writes code, then runs 727 tests to prove the code works. If a test fails, it fixes the failure and re-verifies. This is the difference between "I think this works" and "I can prove this works."

```bash
pip install fableforge
fableforge anvil --task "implement a REST API for user management"
```

**verifyloop** — Generalizes Anvil's verification approach. Close the loop between generation and validation for any agent task. Your agent generates something, verifyloop checks it, and if it fails, the agent gets structured feedback and retries.

**error-recovery** — Structured patterns for agent error recovery. Categorizes errors (transient, permanent, resource), defines retry strategies, and prevents cascading failures. Your agent doesn't crash — it recovers.

#### Orchestration & Runtime

**agent-swarm** — Multi-agent orchestration. Define teams of agents with different specialties, coordinate them on complex tasks, manage context sharing between agents.

**agent-runtime** — Production runtime. State management, execution isolation, resource limits, graceful shutdown. Not a prototype runtime; something you can actually deploy.

**agent-skills** — Skill library. Agents pick up new capabilities at runtime. Each skill is self-contained, documented, and testable.

#### Observability & Performance

**agent-profiler** — Performance profiling for agents. Identify bottlenecks in agent execution — is it the model, the tool calls, or the context window?

**agent-telemetry** — OpenTelemetry-style observability for agents. Traces, metrics, logs. Know what your agents are doing in production.

**bench-agent** — Reproducible benchmarking framework for agent evaluation. Run the same benchmark suite across different models, different configurations, different hardware.

#### Safety & Training

**agent-constitution** — Define behavioral constitutions for your agents. What they should do, what they absolutely should not do, and how to handle edge cases.

**agent-curriculum** — Structured training curricula. Instead of throwing random data at your agent, follow a curriculum that progressively increases difficulty.

**agent-fuzzer** — Fuzz testing for AI agents. Generate adversarial inputs, edge cases, and unexpected scenarios. Find failures before your users do.

**cost-optimizer** — LLM cost optimization. Route simple queries to smaller models, cache repeated prompts, track spending per agent, per task, per day.

#### Data & Training

**fable5-dataset** — The training data. 2.8M examples across 4 categories:
- Mix A (47K): Agent traces (used for current models)
- Mix B (267K): Multi-step reasoning chains
- Mix C (1.37M): Diverse code and analysis
- Vibe Coding (1.1M): Creative coding prompts

**trajectory-distiller** — Extract training data from agent execution traces. Your agent runs a task, trajectory-distiller turns the trace into training examples.

**trace-compiler** — Compile and analyze agent traces. Replay agent sessions, identify decision points, extract patterns.

**reason-critic** — Evaluate agent reasoning chains. Not just "did it get the right answer" but "did it reason well to get there?"

**fableforge-14b** — 14B model variant for more demanding tasks.

#### Meta-Package

**fableforge** — One install gets everything:
```bash
pip install fableforge
```

**fableforge-cli** — CLI for the whole stack:
```bash
fableforge run --model mythos-9b-unhinged --task "debug this kubernetes pod"
fableforge bench --suite agent-standard
fableforge verify --tests 727
```

### Architecture Overview

```
┌─────────────────────────────────────────────┐
│                 fableforge-cli               │
├─────────────────────────────────────────────┤
│              agent-runtime                   │
│    ┌──────────┐  ┌───────────┐             │
│    │  anvil    │  │ agent-    │             │
│    │(verified) │  │  swarm    │             │
│    └──────────┘  └───────────┘             │
├─────────────────────────────────────────────┤
│  verifyloop │ error-recovery │ agent-skills │
├─────────────────────────────────────────────┤
│  agent-   │  agent-     │ cost-   │ bench-  │
│  profiler │  telemetry  │ optimizer│ agent  │
├─────────────────────────────────────────────┤
│  reason-   │  trajectory-  │  trace-       │
│  critic    │  distiller     │  compiler     │
├─────────────────────────────────────────────┤
│  agent-    │  agent-      │  agent-        │
│  constitution│ curriculum │  fuzzer        │
├─────────────────────────────────────────────┤
│  mythos-9b │ mythos-9b-  │  mythos-9b-    │
│            │  enhanced   │  unhinged      │
│  shellwhisperer-1.5B      │ fableforge-14b│
└─────────────────────────────────────────────┘
```

### What's Next

- ShellWhisperer v2 (r=128 LoRA on Mix C data)
- Mythos-35B-MoE merge
- More quantization variants (Q5_K_M, Q8_0)
- vLLM endpoint configurations
- Agent benchmark comparisons against GPT-4

### Links

- GitHub (66 repos): https://github.com/KingLabsA
- HuggingFace models: https://huggingface.co/King3Djbl
- Ollama (one-command install): https://ollama.com/FableForge-AI
- PyPI: https://pypi.org/project/fableforge/
- Discord: https://discord.com/channels/1516428947053875250

Everything is Apache 2.0. Contributions welcome.

---

## 4. Reddit r/opensource — Apache 2.0 & Community

**Title:** FableForge AI: 20+ Apache 2.0 projects for the full AI agent stack — uncensored models, self-verified coding agents, multi-agent orchestration, and more

---

I'm releasing 20+ projects under Apache 2.0. Not "source available" — actual Apache 2.0. Use them commercially, modify them, distribute them, no restrictions.

**What's included:**

**Models (Apache 2.0, no usage restrictions):**
- Mythos-9B, Enhanced, Unhinged — 9B uncensored agent models
- ShellWhisperer-1.5B — 1GB terminal specialist, 30 tok/s on MacBook

One-command install:
```bash
ollama pull FableForge-AI/mythos-9b-unhinged
ollama pull FableForge-AI/shellwhisperer
```

**Agent infrastructure (all Apache 2.0):**

| Project | What it does |
|---------|-------------|
| anvil | Self-verified coding agent (727 tests) |
| verifyloop | Verification loops for any agent |
| error-recovery | Structured error recovery patterns |
| agent-swarm | Multi-agent orchestration |
| agent-runtime | Production agent runtime |
| agent-skills | Reusable skill library for agents |
| agent-profiler | Performance profiling |
| agent-telemetry | Observability (traces, metrics, logs) |
| bench-agent | Reproducible benchmarking |
| cost-optimizer | LLM cost optimization |
| reason-critic | Reasoning chain evaluation |
| trajectory-distiller | Training data from traces |
| trace-compiler | Trace compilation and analysis |
| agent-constitution | Agent safety/behavior constitutions |
| agent-curriculum | Structured training curricula |
| agent-fuzzer | Fuzz testing for agents |
| fable5-dataset | High-quality training datasets |
| fableforge-14b | 14B model variant |
| fableforge-cli | CLI for the whole stack |
| fableforge-training | Training pipeline |

**Install everything:**
```bash
pip install fableforge
```

**Why Apache 2.0 specifically:**

I picked Apache 2.0 over MIT because it includes an explicit patent grant. If you're building commercial products on these models and tools, you should have patent protection. The AI space is litigious enough without worrying about patent trolls.

**Community:**

The project needs contributors. Specific areas where help would make a real difference:
- More quantizations (Q5_K_M, Q8_0 from safetensors)
- GPU benchmark results (currently only tested on M3 Mac)
- Windows/AMD compatibility testing
- Integrations with LangChain, LlamaIndex, CrewAI
- Documentation and examples
- Translation of agent traces for non-English use cases

**Links:**
- GitHub: https://github.com/KingLabsA (66 repos)
- HuggingFace: https://huggingface.co/King3Djbl
- Ollama: https://ollama.com/FableForge-AI
- Discord: https://discord.com/channels/1516428947053875250

Stars, issues, and PRs all welcome. This is meant to be built by the community, not just consumed.

---

## 5. Reddit r/artificial — Agent Architecture

**Title:** We built 20+ projects solving the AI agent reliability problem — verification loops, error recovery, multi-agent orchestration, and uncensored models that don't refuse agent tasks

---

The dirty secret of AI agents: they break constantly, refuse legitimate tasks, and nobody verifies their output. We built the full stack to fix this.

### The Problem

Current "AI agents" have three fundamental issues:

1. **Refusal cascades** — A security research agent that won't explain WiFi protocols, a coding agent that won't generate test exploits for its own security validation, a medical agent that won't discuss drug interactions. Each refusal stops the entire agent pipeline.

2. **No verification** — Agents generate code, write configs, and execute commands. Nobody checks if the output actually works. The model says "done" and we believe it.

3. **No recovery** — One error kills the entire agent session. No structured retry, no error categorization, no graceful degradation.

### Our Solution

**Uncensored models that actually function as agents:**

| Model | Censorship | Tool-Use | Context | Install |
|-------|-----------|----------|---------|---------|
| Mythos-9B-Unhinged | 5/5 (zero refusals) | 4.5/5 | 32K tokens | `ollama pull FableForge-AI/mythos-9b-unhinged` |
| Mythos-9B-Enhanced | 4.8/5 | 4.5/5 | 32K tokens | `ollama pull FableForge-AI/mythos-9b-enhanced` |
| Mythos-9B | 4.5/5 | 4.8/5 | 32K tokens | `ollama pull FableForge-AI/mythos-9b` |
| ShellWhisperer-1.5B | 3.5/5 | 2.8/5 | 32K tokens | `ollama pull FableForge-AI/shellwhisperer` |

These aren't chatbots with the safety layer removed. They're fine-tuned on 47,824 real agent traces — shell commands, Docker debugging, Kubernetes troubleshooting, SQL queries, Python scripts.

**Verification architecture:**

- **anvil** — Self-verified coding agent. Writes code, runs 727 tests, re-fixes failures, verifies again. Proves correctness, doesn't claim it.
- **verifyloop** — The general pattern. Any agent generates output, verifyloop validates it, returns structured feedback on failure.
- **bench-agent** — Reproducible benchmarking. Run the same suite across models, hardware, configurations.

**Recovery architecture:**

- **error-recovery** — Categorizes errors (transient, permanent, resource), defines retry strategies, prevents cascading failures.
- **agent-runtime** — State management, execution isolation, resource limits. Production-grade, not prototype-grade.

**Multi-agent architecture:**

- **agent-swarm** — Orchestrate teams of specialized agents. Context sharing, task decomposition, result aggregation.
- **agent-skills** — Runtime skill acquisition. Agents pick up new capabilities without restarting.

**Observability architecture:**

- **agent-telemetry** — OpenTelemetry-style traces, metrics, logs. Know what your agents are doing.
- **agent-profiler** — Identify bottlenecks. Is the model slow, or are tool calls the bottleneck?
- **cost-optimizer** — Route queries to the cheapest model that works. Track spend per agent, per task, per day.

**Training architecture:**

- **trajectory-distiller** — Turn agent execution traces into training data.
- **trace-compiler** — Compile and replay traces, extract decision patterns.
- **reason-critic** — Evaluate reasoning quality, not just answer correctness.
- **fable5-dataset** — 2.8M examples (only 1.7% used so far).

**Safety architecture:**

- **agent-constitution** — Define behavioral boundaries for agents. Not blanket refusal, but specific constraints.
- **agent-fuzzer** — Break your agents before production does.

### How It Fits Together

```
                    ┌──────────────┐
                    │  fableforge  │
                    │    -cli      │
                    └──────┬───────┘
                           │
              ┌────────────┼────────────┐
              │             │            │
        ┌─────┴─────┐ ┌────┴────┐ ┌─────┴──────┐
        │   anvil   │ │  agent  │ │   agent    │
        │(verified)  │ │  swarm  │ │  runtime   │
        └─────┬─────┘ └────┬────┘ └─────┬──────┘
              │             │            │
        ┌─────┴─────────────┴────────────┴──┐
        │        verifyloop / error-recovery  │
        └─────┬─────────────┬────────────────┘
              │             │
        ┌─────┴─────┐ ┌────┴────────────────┐
        │  mythos    │ │  telemetry / profiler│
        │  models    │ │  / cost-optimizer    │
        └───────────┘ └───────────────────────┘
```

###_specs worth noting

- All models: 32K context, Qwen3-based (native chain-of-thought)
- Mythos-9B-Unhinged: 5/5 on all 10 censorship categories, 4.5/5 tool-use, 4.3/5 reasoning
- ShellWhisperer: 30 tok/s on M3 Mac, 1GB download
- anvil: 727 self-verification tests
- fableforge: `pip install fableforge` gets everything

### Links

- GitHub (66 repos): https://github.com/KingLabsA
- HuggingFace: https://huggingface.co/King3Djbl
- Ollama: https://ollama.com/FableForge-AI
- PyPI: https://pypi.org/project/fableforge/

Apache 2.0 across the board. The models, the agent infrastructure, the training data pipeline — everything.

---

## 6. Discord — FableForge Server Announcement

---

🔥 **FableForge AI — Full Agent Stack, Now Open Source**

We just released 20+ projects covering the entire AI agent development lifecycle. Uncensored models. Self-verified coding agents. Multi-agent orchestration. Verification loops. Error recovery. All Apache 2.0.

**Models — One-command install:**
```
ollama pull FableForge-AI/mythos-9b-unhinged    # 9B, zero refusals
ollama pull FableForge-AI/mythos-9b              # 9B, thinking agent
ollama pull FableForge-AI/mythos-9b-enhanced     # 9B, balanced
ollama pull FableForge-AI/shellwhisperer          # 1.5B, 30 tok/s
```

**Mythos-9B-Unhinged benchmarks:**
- Censorship: 5/5 on ALL 10 categories
- Tool-use: 4.5/5 (shell, Docker, K8s, Python, SQL)
- Reasoning: 4.3/5
- Context: 32K tokens
- Speed: 10 tok/s on M3 Max

**Agent Stack:**
- `anvil` — Self-verified coding agent (727 tests)
- `verifyloop` — Verification loops for agents
- `error-recovery` — Structured error recovery
- `agent-swarm` — Multi-agent orchestration
- `agent-runtime` — Production runtime
- `agent-skills` — Reusable skill library
- `agent-profiler` — Performance profiling
- `agent-telemetry` — Observability
- `bench-agent` — Benchmarking framework
- `cost-optimizer` — LLM cost optimization
- `reason-critic` — Reasoning evaluation
- `trajectory-distiller` — Training data from traces
- `trace-compiler` — Trace analysis
- `agent-constitution` — Agent safety boundaries
- `agent-curriculum` — Training curricula
- `agent-fuzzer` — Fuzz testing for agents
- `fable5-dataset` — 2.8M training examples
- `fableforge-14b` — 14B model variant

**Install everything:**
```bash
pip install fableforge
```

**Quick Links:**
- GitHub: https://github.com/KingLabsA
- HuggingFace: https://huggingface.co/King3Djbl
- Ollama: https://ollama.com/FableForge-AI
- Docs: https://kinglabsa.github.io/fableforge/

All Apache 2.0. 66 repos. Come build with us. 🛠️

---

*End of marketing content. Each post targets its platform's audience and norms. Do not copy-paste between platforms.*