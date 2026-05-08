#!/usr/bin/env python3
"""Make branding PNG backgrounds transparent via edge flood-fill (solid BG)."""

from __future__ import annotations

from collections import deque
from pathlib import Path

from PIL import Image


def flood_transparent_rgba(
    img: Image.Image,
    *,
    ref: tuple[int, int, int],
    thresh: float,
) -> None:
    w, h = img.size
    px = img.load()
    thresh_sq = thresh * thresh
    visited = [[False] * w for _ in range(h)]

    def similar(rgb: tuple[int, int, int]) -> bool:
        dr = rgb[0] - ref[0]
        dg = rgb[1] - ref[1]
        db = rgb[2] - ref[2]
        return (dr * dr + dg * dg + db * db) <= thresh_sq

    q: deque[tuple[int, int]] = deque()
    for x in range(w):
        q.append((x, 0))
        q.append((x, h - 1))
    for y in range(h):
        q.append((0, y))
        q.append((w - 1, y))

    while q:
        x, y = q.popleft()
        if x < 0 or x >= w or y < 0 or y >= h or visited[y][x]:
            continue
        visited[y][x] = True
        r, g, b, a = px[x, y]
        if a == 0:
            continue
        if not similar((r, g, b)):
            continue
        px[x, y] = (r, g, b, 0)
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nx, ny = x + dx, y + dy
            if 0 <= nx < w and 0 <= ny < h and not visited[ny][nx]:
                q.append((nx, ny))


def process_file(path: Path, *, ref: tuple[int, int, int], thresh: float) -> None:
    img = Image.open(path).convert("RGBA")
    flood_transparent_rgba(img, ref=ref, thresh=thresh)
    img.save(path, format="PNG", optimize=True)
    print(f"OK {path.name} ref={ref} thresh={thresh}")


def main() -> None:
    root = Path(__file__).resolve().parents[1]
    branding = root / "assets" / "branding"

    splash = branding / "splash_wallet_hero.png"
    onboard = branding / "onboarding_hero.png"

    if not splash.is_file() or not onboard.is_file():
        raise SystemExit(f"Missing PNGs under {branding}")

    # Splash: solid black (sample corner).
    s = Image.open(splash).convert("RGB")
    ref_s = s.getpixel((0, 0))
    process_file(splash, ref=ref_s, thresh=52.0)

    # Onboarding: solid light cream (sample corner).
    o = Image.open(onboard).convert("RGB")
    ref_o = o.getpixel((0, 0))
    process_file(onboard, ref=ref_o, thresh=38.0)


if __name__ == "__main__":
    main()
