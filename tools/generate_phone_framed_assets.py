#!/Users/taichiumeki/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw


ROOT = Path("/Users/taichiumeki/projects/clockApp")
INPUT_DIR = ROOT / "tmp/appstore_assets/phone_focus"
OUTPUT_DIR = INPUT_DIR


def rounded_mask(size: tuple[int, int], radius: int) -> Image.Image:
    mask = Image.new("L", size, 0)
    draw = ImageDraw.Draw(mask)
    draw.rounded_rectangle((0, 0, size[0], size[1]), radius=radius, fill=255)
    return mask


def frame_phone(src: Path, dst: Path):
    screenshot = Image.open(src).convert("RGBA")

    side_bezel = 34
    top_bezel = 34
    bottom_bezel = 34
    outer_padding = 52
    frame_radius = 74
    screen_radius = 46

    screen_w, screen_h = screenshot.size
    body_w = screen_w + side_bezel * 2
    body_h = screen_h + top_bezel + bottom_bezel
    canvas_w = body_w + outer_padding * 2
    canvas_h = body_h + outer_padding * 2

    canvas = Image.new("RGBA", (canvas_w, canvas_h), (0, 0, 0, 0))
    draw = ImageDraw.Draw(canvas)

    body_box = (
        outer_padding,
        outer_padding,
        outer_padding + body_w,
        outer_padding + body_h,
    )
    draw.rounded_rectangle(body_box, radius=frame_radius, fill=(10, 10, 12, 255))

    screen_box = (
        outer_padding + side_bezel,
        outer_padding + top_bezel,
        outer_padding + side_bezel + screen_w,
        outer_padding + top_bezel + screen_h,
    )
    masked = Image.new("RGBA", screenshot.size, (0, 0, 0, 0))
    masked.paste(screenshot, (0, 0), rounded_mask(screenshot.size, screen_radius))
    canvas.paste(masked, (screen_box[0], screen_box[1]), masked)

    # Thin inner border around the screen.
    draw.rounded_rectangle(screen_box, radius=screen_radius, outline=(34, 34, 38, 255), width=2)

    # Top speaker slit and front camera dot.
    slit_w = int(body_w * 0.16)
    slit_h = 8
    slit_x = outer_padding + (body_w - slit_w) // 2
    slit_y = outer_padding + 14
    draw.rounded_rectangle((slit_x, slit_y, slit_x + slit_w, slit_y + slit_h), radius=4, fill=(30, 30, 34, 255))
    cam_r = 4
    cam_x = slit_x + slit_w + 18
    cam_y = slit_y + slit_h // 2
    draw.ellipse((cam_x - cam_r, cam_y - cam_r, cam_x + cam_r, cam_y + cam_r), fill=(28, 28, 32, 255))

    dst.parent.mkdir(parents=True, exist_ok=True)
    canvas.save(dst)


def main():
    pairs = [
        ("iphone-se-light-vertical.png", "iphone-se-light-framed.png"),
        ("iphone-se-dark-vertical.png", "iphone-se-dark-framed.png"),
    ]
    for src_name, dst_name in pairs:
        frame_phone(INPUT_DIR / src_name, OUTPUT_DIR / dst_name)


if __name__ == "__main__":
    main()
