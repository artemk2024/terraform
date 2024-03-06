#!/usr/local/bin/python3.9

import stable_whisper

ckpt = "large-v3"
device = "cpu"
device_index = 0
compute_type = "default"
download_root = "/data/HF_HOME"
model = stable_whisper.load_faster_whisper(
    ckpt, device=device, device_index=device_index, compute_type=compute_type, download_root=download_root
)
model = stable_whisper.load_model(ckpt, device=device, download_root=download_root)
