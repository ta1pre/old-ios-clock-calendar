#!/Users/taichiumeki/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

from localization_bundle import BUNDLE

ROOT = Path("/Users/taichiumeki/projects/clockApp")
ASSETS = ROOT / "tmp/appstore_assets"

SPECS = {
    "iphone_6_9_landscape": (2796, 1290),
    "ipad_13_landscape": (2752, 2064),
}

def load_slide(path: Path) -> Image.Image:
    return Image.open(path).convert("RGBA")


def cover_background(slide: Image.Image, target_size: tuple[int, int]) -> Image.Image:
    tw, th = target_size
    scale = max(tw / slide.width, th / slide.height)
    bg = slide.resize((int(slide.width * scale), int(slide.height * scale)), Image.Resampling.LANCZOS)
    left = (bg.width - tw) // 2
    top = (bg.height - th) // 2
    bg = bg.crop((left, top, left + tw, top + th))
    bg = bg.filter(ImageFilter.GaussianBlur(54))

    veil = Image.new("RGBA", target_size, (248, 247, 244, 92))
    bg = Image.alpha_composite(bg, veil)
    return bg


def fit_slide(slide: Image.Image, target_size: tuple[int, int]) -> Image.Image:
    tw, th = target_size
    pad_x = int(tw * 0.035)
    pad_y = int(th * 0.035)
    scale = min((tw - pad_x * 2) / slide.width, (th - pad_y * 2) / slide.height)
    resized = slide.resize((int(slide.width * scale), int(slide.height * scale)), Image.Resampling.LANCZOS)
    return resized


def shadow_layer(canvas_size: tuple[int, int], box: tuple[int, int, int, int], radius: int = 28) -> Image.Image:
    layer = Image.new("RGBA", canvas_size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(layer)
    x0, y0, x1, y1 = box
    draw.rounded_rectangle((x0, y0, x1, y1), radius=radius, fill=(0, 0, 0, 72))
    return layer.filter(ImageFilter.GaussianBlur(34))


def export_slide(slide_path: Path, out_path: Path, target_size: tuple[int, int]) -> None:
    slide = load_slide(slide_path)
    bg = cover_background(slide, target_size)
    fitted = fit_slide(slide, target_size)

    x = (target_size[0] - fitted.width) // 2
    y = (target_size[1] - fitted.height) // 2
    box = (x, y, x + fitted.width, y + fitted.height)

    bg.alpha_composite(shadow_layer(target_size, box))
    bg.alpha_composite(fitted, (x, y))
    out_path.parent.mkdir(parents=True, exist_ok=True)
    bg.save(out_path)


def contact_sheet(images: list[Path], out_path: Path) -> None:
    opened = [Image.open(path).convert("RGBA") for path in images]
    w, h = opened[0].size
    thumb_w = 420
    thumb_h = int(h * (thumb_w / w))
    sheet = Image.new("RGBA", (thumb_w * 2 + 60, thumb_h * 3 + 80), (245, 245, 245, 255))
    positions = [
        (20, 20),
        (thumb_w + 40, 20),
        (20, thumb_h + 40),
        (thumb_w + 40, thumb_h + 40),
        (20, thumb_h * 2 + 60),
    ]
    for img, pos in zip(opened, positions):
        thumb = img.resize((thumb_w, thumb_h), Image.Resampling.LANCZOS)
        sheet.paste(thumb, pos)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(out_path)


def main() -> None:
    submission_root = ASSETS / "submission"

    for locale, data in BUNDLE["locales"].items():
        tag = data["doc_tag"]
        src_dir = ASSETS / f"{tag}_reference_final"
        slides = [src_dir / f"{tag}-slide-{idx:02d}.png" for idx in range(1, 6)]
        for family, size in SPECS.items():
            out_dir = submission_root / tag / family
            exported = []
            for idx, slide in enumerate(slides, start=1):
                out_path = out_dir / f"{tag}-slide-{idx:02d}.png"
                export_slide(slide, out_path, size)
                exported.append(out_path)
            contact_sheet(exported, out_dir / f"{tag}-{family}-contact-sheet.png")


if __name__ == "__main__":
    main()
