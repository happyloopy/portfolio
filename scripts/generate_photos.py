#!/usr/bin/env python3
"""Create photos.json from gallery photos. No third-party dependencies."""
import json
from pathlib import Path
from urllib.parse import quote

root = Path(__file__).resolve().parents[1]
folder = root / "images" / "little-corner" / "collections"
allowed = {".jpg", ".jpeg", ".png", ".webp", ".gif"}
folder.mkdir(parents=True, exist_ok=True)
photos = [
    "images/little-corner/collections/" + quote(p.name, safe="-._~")
    for p in sorted(folder.iterdir(), key=lambda p: p.name.lower())
    if p.is_file() and p.suffix.lower() in allowed
]
(root / "photos.json").write_text(json.dumps(photos, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
print(f"Generated photos.json with {len(photos)} photo(s)")
