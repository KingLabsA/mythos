#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REGISTRY="${DOCKER_REGISTRY:-ghcr.io}"
IMAGE_NAME="${DOCKER_IMAGE:-fableforge/mythos-vllm}"
IMAGE_TAG="${VERSION:-latest}"
FULL_IMAGE="${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log() { echo -e "${CYAN}[$(date '+%H:%M:%S')]${NC} $*"; }
ok() { echo -e "${GREEN}[OK]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
fail() { echo -e "${RED}[FAIL]${NC} $*" >&2; exit 1; }

check_deps() {
    local missing=0
    for cmd in docker curl; do
        if ! command -v "${cmd}" &>/dev/null; then
            warn "${cmd} not found"
            missing=1
        fi
    done

    if ! command -v runpod &>/dev/null && ! command -v python3 &>/dev/null; then
        warn "Neither runpod CLI nor python3 found"
        missing=1
    fi

    [ "${missing}" -eq 0 ] || fail "Missing required dependencies"
}

build_image() {
    log "Building Docker image: ${FULL_IMAGE}"

    docker build \
        -t "${FULL_IMAGE}" \
        -f "${SCRIPT_DIR}/Dockerfile" \
        --build-arg BUILDKIT_INLINE_CACHE=1 \
        "${SCRIPT_DIR}"

    ok "Image built: ${FULL_IMAGE}"

    docker tag "${FULL_IMAGE}" "${REGISTRY}/${IMAGE_NAME}:latest"
}

push_image() {
    log "Pushing image to registry: ${REGISTRY}/${IMAGE_NAME}"
    docker push "${FULL_IMAGE}" 2>/dev/null || {
        warn "Push failed. Trying docker login..."
        docker login "${REGISTRY}" || fail "Could not log in to ${REGISTRY}"
        docker push "${FULL_IMAGE}"
    }
    ok "Image pushed: ${FULL_IMAGE}"
}

deploy_via_cli() {
    local endpoint_name="${1}"
    local model="${2}"
    local gpu_type="${3:-RTX4090}"
    local min_workers="${4:-1}"

    log "Deploying endpoint: ${endpoint_name} (model: ${model})"

    if command -v runpod &>/dev/null; then
        runpod create endpoint \
            --name "${endpoint_name}" \
            --image "${FULL_IMAGE}" \
            --gpu "${gpu_type}" \
            --min-workers "${min_workers}" \
            --max-workers 4 \
            --env "MODEL_NAME=${model}" \
            --env "HF_TOKEN=${HF_TOKEN:-}" \
            --env "MAX_MODEL_LEN=4096" \
            --env "PORT=8000" \
            --volume-size 50 \
            --network-volume
    else
        log "RunPod CLI not found. Using API..."
        deploy_via_api "${endpoint_name}" "${model}" "${gpu_type}" "${min_workers}"
    fi

    ok "Deployed: ${endpoint_name}"
}

deploy_via_api() {
    local endpoint_name="${1}"
    local model="${2}"
    local gpu_type="${3:-RTX4090}"
    local min_workers="${4:-1}"

    local api_key="${RUNPOD_API_KEY:-}"
    [ -z "${api_key}" ] && fail "RUNPOD_API_KEY not set"

    local gpu_ids
    case "${gpu_type}" in
        RTX4090)  gpu_ids='["NVIDIA RTX 4090"]' ;;
        A100)     gpu_ids='["NVIDIA A100 80GB"]' ;;
        A6000)    gpu_ids='["NVIDIA A6000"]' ;;
        *)        gpu_ids='["NVIDIA RTX 4090"]' ;;
    esac

    local payload
    payload=$(cat <<EOF
{
    "name": "${endpoint_name}",
    "imageName": "${FULL_IMAGE}",
    "gpuIds": ${gpu_ids},
    "minWorkerCount": ${min_workers},
    "maxWorkerCount": 4,
    "workers": [],
    "env": {
        "MODEL_NAME": "${model}",
        "HF_TOKEN": "${HF_TOKEN:-}",
        "MAX_MODEL_LEN": "4096",
        "PORT": "8000",
        "GPU_MEMORY_UTILIZATION": "0.92"
    },
    "networkVolumeId": "${RUNPOD_VOLUME_ID:-}",
    "containerDiskInGb": 10,
    "volumeInGb": 50,
    "ports": "8000/http"
}
EOF
)

    local response
    response=$(curl -s -X POST "https://api.runpod.ai/v2/${RUNPOD_ACCOUNT_ID:-}/endpoints" \
        -H "Authorization: Bearer ${api_key}" \
        -H "Content-Type: application/json" \
        -d "${payload}")

    log "API response: ${response}"
}

wait_for_endpoint() {
    local endpoint_id="${1}"
    local max_wait="${2:-300}"
    local elapsed=0
    local interval=10

    log "Waiting for endpoint ${endpoint_id} to become healthy..."

    while [ "${elapsed}" -lt "${max_wait}" ]; do
        if curl -sf "http://localhost:8000/health" &>/dev/null; then
            ok "Endpoint is healthy!"
            return 0
        fi
        sleep "${interval}"
        elapsed=$((elapsed + interval))
        log "Still waiting... (${elapsed}s/${max_wait}s)"
    done

    fail "Endpoint did not become healthy within ${max_wait}s"
}

usage() {
    cat <<EOF
Mythos vLLM RunPod Deployment

Usage: $(basename "$0") <command> [options]

Commands:
  build       Build the Docker image
  push        Push Docker image to registry
  deploy      Deploy endpoints to RunPod
  status      Check deployment status
  health      Run health check against an endpoint
  all         Build, push, and deploy (full pipeline)

Options:
  --model MODEL        Override default model
  --gpu GPU_TYPE        GPU type: RTX4090, A100, A6000 (default: RTX4090)
  --min-workers N       Minimum workers (default: 1)
  --tag TAG            Image tag (default: latest)
  --endpoint URL        Endpoint URL for health checks
  --help                Show this help

Environment:
  HF_TOKEN              HuggingFace token
  RUNPOD_API_KEY        RunPod API key
  RUNPOD_ACCOUNT_ID     RunPod account ID
  RUNPOD_VOLUME_ID      RunPod network volume ID
  DOCKER_REGISTRY       Docker registry (default: ghcr.io)
  DOCKER_IMAGE          Docker image name (default: fableforge/mythos-vllm)

Examples:
  $(basename "$0") all
  $(basename "$0") build --tag v1.0.0
  $(basename "$0") deploy --model FableForge-AI/mythos-9b-unhinged
  $(basename "$0") health --endpoint https://mythos.runpod.net/v1
EOF
    exit 0
}

COMMAND="${1:-help}"
shift || true

MODEL="${MODEL:-FableForge-AI/mythos-9b-unhinged}"
GPU_TYPE="RTX4090"
MIN_WORKERS=1
ENDPOINT_URL=""

while [[ $# -gt 0 ]]; do
    case "${1}" in
        --model)      MODEL="$2"; shift 2 ;;
        --gpu)        GPU_TYPE="$2"; shift 2 ;;
        --min-workers) MIN_WORKERS="$2"; shift 2 ;;
        --tag)        IMAGE_TAG="$2"; FULL_IMAGE="${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"; shift 2 ;;
        --endpoint)   ENDPOINT_URL="$2"; shift 2 ;;
        --help|-h)    usage ;;
        *)            warn "Unknown option: ${1}"; shift ;;
    esac
done

check_deps

case "${COMMAND}" in
    build)
        build_image
        ;;
    push)
        push_image
        ;;
    deploy)
        export HF_TOKEN="${HF_TOKEN:-${HF_TOKEN}}"

        deploy_via_cli "mythos-unhinged-primary" "FableForge-AI/mythos-9b-unhinged" "${GPU_TYPE}" "${MIN_WORKERS}"
        deploy_via_cli "mythos-enhanced-secondary" "FableForge-AI/mythos-9b-enhanced" "${GPU_TYPE}" 0
        deploy_via_cli "shellwhisperer-fast" "FableForge-AI/shellwhisperer" "${GPU_TYPE}" 0
        ;;
    status)
        if command -v runpod &>/dev/null; then
            runpod get endpoints
        else
            warn "RunPod CLI not available. Check dashboard at https://runpod.ai"
        fi
        ;;
    health)
        [ -z "${ENDPOINT_URL}" ] && fail "--endpoint URL required for health check"
        log "Checking health: ${ENDPOINT_URL}/health"
        curl -sf "${ENDPOINT_URL}/health" && ok "Healthy" || fail "Unhealthy"
        ;;
    all)
        export HF_TOKEN="${HF_TOKEN:-${HF_TOKEN}}"
        build_image
        push_image
        deploy_via_cli "mythos-unhinged-primary" "FableForge-AI/mythos-9b-unhinged" "${GPU_TYPE}" "${MIN_WORKERS}"
        deploy_via_cli "mythos-enhanced-secondary" "FableForge-AI/mythos-9b-enhanced" "${GPU_TYPE}" 0
        deploy_via_cli "shellwhisperer-fast" "FableForge-AI/shellwhisperer" "${GPU_TYPE}" 0
        ok "Full deployment complete!"
        ;;
    help|*)
        usage
        ;;
esac