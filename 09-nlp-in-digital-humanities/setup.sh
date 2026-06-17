#!/usr/bin/env bash
# Setup for this lesson. The root ./setup.sh runs this INSIDE the lesson's
# own virtualenv — plain `pip install` lands in this lesson's environment.
# The venv inherits the base image's torch/CUDA via --system-site-packages,
# so do NOT reinstall torch unless you need a specific version.
#
# Fill in everything your practical needs: pinned pip installs, dataset
# downloads, model caching. Must run non-interactively; safe to re-run.
set -e

# ── Extraction stack ───────────────────────────────────────────────────────────
pip install --quiet transformers==5.10.2
pip install --quiet spacy==3.8.14
pip install --quiet networkx==3.6.1
pip install --quiet pyvis==0.3.2
pip install --quiet sklearn-pandas==2.2.0
pip install --quiet matplotlib==3.10.0
pip install --quiet accelerate==1.13.0
pip install --quiet bitsandbytes==0.49.2
pip install huggingface-hub==1.18.0

# ── Pre-cache Spacy models (avoids download lag during the session) ─────
python -m spacy download en_core_web_lg -q
