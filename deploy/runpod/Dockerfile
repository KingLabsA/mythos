FROM vllm/vllm-openai:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV MODEL_NAME=FableForge-AI/mythos-9b-unhinged
ENV MAX_MODEL_LEN=4096
ENV PORT=8000
ENV HF_TOKEN=""
ENV GPU_MEMORY_UTILIZATION=0.92
ENV DTYPE=auto

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app /models

COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=3 \
    CMD curl -f http://localhost:${PORT}/health || exit 1

EXPOSE ${PORT}

WORKDIR /app

ENTRYPOINT ["/app/start.sh"]