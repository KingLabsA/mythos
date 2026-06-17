#!/usr/bin/env bash
set -euo pipefail

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"; }

log "Starting Mythos vLLM server..."
log "Model: ${MODEL_NAME}"
log "Max model len: ${MAX_MODEL_LEN}"

export VLLM_WORKER_MULTIPROC_LOG_LEVEL=INFO

MAX_RETRIES=10
RETRY_DELAY=30

for i in $(seq 1 $MAX_RETRIES); do
    log "Download attempt ${i}/${MAX_RETRIES} for ${MODEL_NAME}"

    if python3 -c "
from huggingface_hub import snapshot_download
snapshot_download(
    '${MODEL_NAME}',
    token='${HF_TOKEN}',
    local_dir='/models/${MODEL_NAME}',
    resume_download=True,
)
print('Model downloaded successfully')
"; then
        log "Model download complete"
        break
    else
        log "Download attempt ${i} failed, retrying in ${RETRY_DELAY}s..."
        sleep "${RETRY_DELAY}"
    fi

    if [ "${i}" -eq "${MAX_RETRIES}" ]; then
        log "FATAL: Failed to download model after ${MAX_RETRIES} attempts"
        exit 1
    fi
done

SECONDARY_MODELS="${SECONDARY_MODELS:-}"

if [ -n "${SECONDARY_MODELS}" ]; then
    IFS=',' read -ra models <<< "${SECONDARY_MODELS}"
    for m in "${models[@]}"; do
        log "Downloading secondary model: ${m}"
        python3 -c "
from huggingface_hub import snapshot_download
snapshot_download(
    '${m}',
    token='${HF_TOKEN}',
    local_dir='/models/${m}',
    resume_download=True,
)
" || log "WARNING: Failed to download secondary model ${m}, continuing..."
    done
fi

SERVED_MODEL_NAME="${SERVED_MODEL_NAME:-$(echo "${MODEL_NAME}" | awk -F'/' '{print $2}')}"

ARGS=(
    --model "/models/${MODEL_NAME}"
    --served-model-name "${SERVED_MODEL_NAME}"
    --max-model-len "${MAX_MODEL_LEN}"
    --port "${PORT}"
    --gpu-memory-utilization "${GPU_MEMORY_UTILIZATION}"
    --dtype "${DTYPE}"
    --trust-remote-code
    --enable-prefix-caching
    --disable-log-requests
)

if [ -n "${QUANTIZATION:-}" ]; then
    ARGS+=(--quantization "${QUANTIZATION}")
fi

if [ -n "${TENSOR_PARALLEL_SIZE:-}" ]; then
    ARGS+=(--tensor-parallel-size "${TENSOR_PARALLEL_SIZE}")
fi

if [ "${ENABLE_LORA:-false}" = "true" ]; then
    ARGS+=(--enable-lora)
fi

log "Starting vLLM with args: ${ARGS[*]}"
exec python3 -m vllm.entrypoints.openai.api_server "${ARGS[@]}"