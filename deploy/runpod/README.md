# Mythos vLLM — RunPod Deployment

OpenAI-compatible API serving for Mythos models on RunPod GPU infrastructure.

## Models

| Endpoint | Model | Tier | Min Workers |
|---|---|---|---|
| mythos-unhinged-primary | `FableForge-AI/mythos-9b-unhinged` | Primary | 1 (always warm) |
| mythos-enhanced-secondary | `FableForge-AI/mythos-9b-enhanced` | Secondary | 0 (scale-to-zero) |
| shellwhisperer-fast | `FableForge-AI/shellwhisperer` | Fast | 0 (scale-to-zero) |

## Prerequisites

- Docker with BuildKit
- RunPod account with API key
- RunPod CLI (`pip install runpod`) or API access
- HuggingFace access token with model permissions

## Quick Start

```bash
# Set required environment variables
export HF_TOKEN="${HF_TOKEN}"
export RUNPOD_API_KEY="your-runpod-api-key"
export RUNPOD_ACCOUNT_ID="your-account-id"

# Full deploy: build, push, and create endpoints
chmod +x deploy.sh
./deploy.sh all
```

## Step-by-Step Deployment

### 1. Build the Docker Image

```bash
./deploy.sh build
# or with a specific tag
./deploy.sh build --tag v1.0.0
```

### 2. Push to Registry

```bash
docker login ghcr.io
./deploy.sh push
```

### 3. Deploy Endpoints

```bash
# Deploy all three endpoints
./deploy.sh deploy

# Deploy with A100 GPUs
./deploy.sh deploy --gpu A100

# Deploy just the primary model
./deploy.sh deploy --model FableForge-AI/mythos-9b-unhinged
```

### 4. Verify Deployment

```bash
# Check endpoint health
./deploy.sh health --endpoint https://your-endpoint.runpod.net/v1

# Or check manually
curl https://your-endpoint.runpod.net/v1/health
curl https://your-endpoint.runpod.net/v1/models
```

## API Usage

### OpenAI SDK (Python)

```python
from openai import OpenAI

client = OpenAI(
    base_url="https://your-endpoint.runpod.net/v1",
    api_key="not-needed"  # RunPod handles auth
)

# Chat completion
response = client.chat.completions.create(
    model="mythos-9b-unhinged",
    messages=[
        {"role": "system", "content": "You are a creative storyteller."},
        {"role": "user", "content": "Write a dark fable about ambition."}
    ],
    max_tokens=4096,
    temperature=0.8
)
print(response.choices[0].message.content)

# Switch models
response = client.chat.completions.create(
    model="shellwhisperer",
    messages=[{"role": "user", "content": "Explain this shell command: awk '{print $2}'"}],
    max_tokens=1024
)
```

### OpenAI SDK (TypeScript)

```typescript
import OpenAI from "openai";

const client = new OpenAI({
  baseURL: "https://your-endpoint.runpod.net/v1",
  apiKey: "not-needed",
});

const completion = await client.chat.completions.create({
  model: "mythos-9b-unhinged",
  messages: [{ role: "user", content: "Write a fable." }],
  max_tokens: 4096,
});
console.log(completion.choices[0].message.content);
```

### cURL

```bash
# Chat completion
curl https://your-endpoint.runpod.net/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "mythos-9b-unhinged",
    "messages": [{"role": "user", "content": "Hello"}],
    "max_tokens": 512
  }'

# List available models
curl https://your-endpoint.runpod.net/v1/models

# Health check
curl https://your-endpoint.runpod.net/v1/health
```

### OpenRouter Integration

Add as a custom provider in OpenRouter:

```
Provider URL: https://your-endpoint.runpod.net/v1
Provider Name: Mythos
Models: mythos-9b-unhinged, mythos-9b-enhanced, shellwhisperer
```

## Architecture

```
Client (OpenAI SDK / OpenRouter / Chat Widget)
    │
    ▼
RunPod Serverless Endpoint (port 8000)
    │
    ▼
vLLM OpenAI-Compatible Server
    │
    ├── mythos-9b-unhinged  (RTX 4090, always warm)
    ├── mythos-9b-enhanced  (RTX 4090, scale-to-zero)
    └── shellwhisperer      (RTX 4090, scale-to-zero)
```

## Configuration

### Environment Variables

| Variable | Default | Description |
|---|---|---|
| `MODEL_NAME` | `FableForge-AI/mythos-9b-unhinged` | HuggingFace model ID |
| `SERVED_MODEL_NAME` | Derived from MODEL_NAME | OpenAI API model name |
| `MAX_MODEL_LEN` | `4096` | Maximum context window |
| `PORT` | `8000` | API server port |
| `GPU_MEMORY_UTILIZATION` | `0.92` | VRAM allocation fraction |
| `DTYPE` | `auto` | Data type (auto/float16/bfloat16) |
| `QUANTIZATION` | (unset) | Quantization method |
| `HF_TOKEN` | (required) | HuggingFace download token |
| `SECONDARY_MODELS` | (unset) | Comma-separated additional models |
| `TENSOR_PARALLEL_SIZE` | (unset) | Number of GPUs for tensor parallelism |

### GPU Selection

| GPU | VRAM | Best For | Hourly Cost |
|---|---|---|---|
| RTX 4090 | 24 GB | Single 9B model, production | ~$0.44 |
| A100 40GB | 40 GB | Multi-model, high throughput | ~$1.14 |
| A100 80GB | 80 GB | Multiple models simultaneously | ~$1.64 |

### Scaling

- **Primary endpoint**: min 1 worker (always warm, ~2min cold start avoided)
- **Secondary/fast endpoints**: min 0 workers (scale-to-zero, pay only when used)
- **Idle timeout**: 300s (primary), 120s (secondary), 60s (fast)

## Troubleshooting

### Model download failures

```bash
# Test HuggingFace access
huggingface-cli login --token $HF_TOKEN
python3 -c "from huggingface_hub import snapshot_download; snapshot_download('FableForge-AI/mythos-9b-unhinged')"
```

### Health check failures

```bash
# Check if vLLM started
kubectl logs <pod-name> | grep "Uvicorn running"

# Test directly
curl -f http://localhost:8000/health
curl -f http://localhost:8000/v1/models
```

### Out of memory

- Reduce `GPU_MEMORY_UTILIZATION` to `0.85`
- Switch to `--quantization awq` or `--quantization gptq`
- Use A100 80GB GPU
- Reduce `MAX_MODEL_LEN` to `2048`

### Slow cold starts

- Set `minWorkers: 1` to keep at least one warm worker
- Use RunPod network volumes to cache model weights between cold starts
- Pre-download models during image build for fastest starts

## Security Notes

- **Never commit HF tokens to source control**. Use environment variables or secrets management.
- Set `RUNPOD_API_KEY` as a secret, not in config files.
- Consider adding API key authentication via RunPod's built-in auth or a reverse proxy.
- The provided `runpod.yaml` contains a placeholder token — rotate it before deployment.

## License

See individual model repositories for license terms.