#!/usr/bin/env bash
# Setup for this lesson. The root ./setup.sh runs this INSIDE the lesson's
# own virtualenv — plain `pip install` lands in this lesson's environment.
# The venv inherits the base image's torch/CUDA via --system-site-packages,
# so do NOT reinstall torch unless you need a specific version.
#
# Fill in everything your practical needs: pinned pip installs, dataset
# downloads, model caching. Must run non-interactively; safe to re-run.
set -e

# ── Retrieval stack ───────────────────────────────────────────────────────────
pip install --quiet rank_bm25==0.2.2
pip install --quiet sentence-transformers==3.3.1
pip install --quiet faiss-cpu==1.14.3
pip install --quiet datasets==3.2.0
pip install --quiet transformers==4.48.0
pip install --quiet bitsandbytes==0.49.2
pip install --quiet accelerate==1.2.1
pip install --quiet sentencepiece==0.2.0
pip install --quiet protobuf==5.29.3

# ── Pre-cache HuggingFace models (avoids download lag during the session) ─────
python - << 'PYEOF'
from sentence_transformers import SentenceTransformer
from transformers import AutoTokenizer, AutoModel

print("Caching all-MiniLM-L6-v2 ...")
SentenceTransformer("sentence-transformers/all-MiniLM-L6-v2")

print("Caching legal-bert-base-uncased ...")
AutoTokenizer.from_pretrained("nlpaueb/legal-bert-base-uncased")
AutoModel.from_pretrained("nlpaueb/legal-bert-base-uncased")

print("Caching Mistral-7B-Instruct-v0.3 tokenizer ...")
AutoTokenizer.from_pretrained("mistralai/Mistral-7B-Instruct-v0.3")

from huggingface_hub import try_to_load_from_cache, snapshot_download
cached = try_to_load_from_cache("mistralai/Mistral-7B-Instruct-v0.3", "config.json")
if cached is None:
    print("  Downloading Mistral weights ...")
    snapshot_download("mistralai/Mistral-7B-Instruct-v0.3")
else:
    print("  Mistral weights already cached -- skipping.")

print("All models cached.")
PYEOF
