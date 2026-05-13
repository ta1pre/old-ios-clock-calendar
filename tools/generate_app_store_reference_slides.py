#!/Users/taichiumeki/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3

from __future__ import annotations

import argparse
import math
from pathlib import Path

from PIL import Image, ImageChops, ImageDraw, ImageFilter, ImageFont

from localization_bundle import BUNDLE

ROOT = Path("/Users/taichiumeki/projects/clockApp")
RAW = ROOT / "tmp/appstore_assets/raw"
PHONE_FOCUS = ROOT / "tmp/appstore_assets/phone_focus"

JA_FONT_HEAVY = "/System/Library/Fonts/ヒラギノ角ゴシック W8.ttc"
JA_FONT_SEMIBOLD = "/System/Library/Fonts/ヒラギノ角ゴシック W6.ttc"
JA_FONT_REGULAR = "/System/Library/Fonts/ヒラギノ角ゴシック W4.ttc"

EN_FONT_HEAVY = "/System/Library/Fonts/Supplemental/Arial Black.ttf"
EN_FONT_SEMIBOLD = "/System/Library/Fonts/Supplemental/Arial Bold.ttf"
EN_FONT_REGULAR = "/System/Library/Fonts/Supplemental/Arial.ttf"
KO_FONT = "/System/Library/Fonts/AppleSDGothicNeo.ttc"
ZH_FONT = "/System/Library/Fonts/STHeiti Medium.ttc"

FONT_HEAVY = JA_FONT_HEAVY
FONT_SEMIBOLD = JA_FONT_SEMIBOLD
FONT_REGULAR = JA_FONT_REGULAR

BLUE = (41, 112, 255, 255)
RED = (255, 59, 48, 255)
TEXT = (12, 12, 18, 255)
TEXT_MUTED = (88, 93, 104, 255)
TEXT_LIGHT = (250, 250, 252, 255)
TEXT_LIGHT_MUTED = (198, 201, 208, 255)
BG = (248, 247, 244, 255)
BG_DARK = (17, 18, 22, 255)

def set_font_profile(profile: str):
    global FONT_HEAVY, FONT_SEMIBOLD, FONT_REGULAR
    if profile == "latin":
        FONT_HEAVY = EN_FONT_HEAVY
        FONT_SEMIBOLD = EN_FONT_SEMIBOLD
        FONT_REGULAR = EN_FONT_REGULAR
    elif profile == "ko":
        FONT_HEAVY = KO_FONT
        FONT_SEMIBOLD = KO_FONT
        FONT_REGULAR = KO_FONT
    elif profile == "zh":
        FONT_HEAVY = ZH_FONT
        FONT_SEMIBOLD = ZH_FONT
        FONT_REGULAR = ZH_FONT
    else:
        FONT_HEAVY = JA_FONT_HEAVY
        FONT_SEMIBOLD = JA_FONT_SEMIBOLD
        FONT_REGULAR = JA_FONT_REGULAR


def font(path: str, size: int) -> ImageFont.FreeTypeFont:
    return ImageFont.truetype(path, size=size)


def rgba(color):
    if len(color) == 4:
        return color
    return (*color, 255)


def make_background(size: tuple[int, int], dark: bool = False) -> Image.Image:
    base = Image.new("RGBA", size, BG_DARK if dark else BG)
    overlay = Image.new("RGBA", size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)

    accents = [
        ((-200, -120, 820, 620), (242, 239, 232, 230)),
        ((size[0] - 760, -160, size[0] + 160, 600), (237, 238, 241, 190)),
        ((size[0] * 0.28, size[1] * 0.58, size[0] * 0.96, size[1] * 1.18), (238, 239, 242, 185)),
    ]
    dark_accents = [
        ((-220, -120, 820, 620), (28, 31, 38, 255)),
        ((size[0] - 760, -160, size[0] + 160, 600), (23, 25, 33, 225)),
        ((size[0] * 0.24, size[1] * 0.58, size[0] * 0.96, size[1] * 1.18), (21, 24, 30, 215)),
    ]

    for box, color in (dark_accents if dark else accents):
        draw.ellipse(box, fill=color)

    overlay = overlay.filter(ImageFilter.GaussianBlur(80))
    base = Image.alpha_composite(base, overlay)
    return base


def draw_shadow(canvas: Image.Image, box: tuple[int, int, int, int], radius: int, alpha: int = 58, blur: int = 30, expand: int = 28):
    layer = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(layer)
    x0, y0, x1, y1 = box
    draw.rounded_rectangle(
        (x0 - expand, y0 - expand, x1 + expand, y1 + expand),
        radius=radius + expand,
        fill=(0, 0, 0, alpha),
    )
    layer = layer.filter(ImageFilter.GaussianBlur(blur))
    canvas.alpha_composite(layer)


def rotate(path: Path, degrees: int) -> Image.Image:
    return Image.open(path).convert("RGBA").rotate(degrees, expand=True)


def crop(img: Image.Image, box: tuple[int, int, int, int]) -> Image.Image:
    return img.crop(box)


def fit(img: Image.Image, max_w: int, max_h: int) -> Image.Image:
    scale = min(max_w / img.width, max_h / img.height)
    return img.resize((int(img.width * scale), int(img.height * scale)), Image.Resampling.LANCZOS)


def rounded_mask(size: tuple[int, int], radius: int) -> Image.Image:
    mask = Image.new("L", size, 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, size[0], size[1]), radius=radius, fill=255)
    return mask


def paste_rounded(base: Image.Image, image: Image.Image, xy: tuple[int, int], radius: int):
    mask = rounded_mask(image.size, radius)
    base.paste(image, xy, mask)


def draw_ipad(base: Image.Image, screen: Image.Image, x: int, y: int, w: int, *, bezel_color=(10, 10, 12, 255), inner_border=(50, 50, 54, 255)):
    screen_aspect = screen.height / screen.width
    h = int(w * 0.66)
    box = (x, y, x + w, y + h)
    draw_shadow(base, box, radius=44, alpha=52, blur=34, expand=32)

    frame = Image.new("RGBA", base.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(frame)
    draw.rounded_rectangle(box, radius=42, fill=bezel_color)
    base.alpha_composite(frame)

    bezel = max(18, int(w * 0.025))
    screen_box = (x + bezel, y + bezel, x + w - bezel, y + h - bezel)
    sw = screen_box[2] - screen_box[0]
    sh = screen_box[3] - screen_box[1]
    fitted = fit(screen, sw, sh)
    sx = screen_box[0] + (sw - fitted.width) // 2
    sy = screen_box[1] + (sh - fitted.height) // 2
    paste_rounded(base, fitted, (sx, sy), radius=24)

    draw = ImageDraw.Draw(base)
    draw.rounded_rectangle(screen_box, radius=24, outline=inner_border, width=2)
    cam_r = max(3, int(w * 0.004))
    cam_x = x + w // 2
    cam_y = y + max(13, int(h * 0.03))
    draw.ellipse((cam_x - cam_r, cam_y - cam_r, cam_x + cam_r, cam_y + cam_r), fill=(36, 36, 40, 255))
    return box


def draw_phone(base: Image.Image, screen: Image.Image, x: int, y: int, h: int, *, bezel_color=(8, 8, 10, 255)):
    screen_aspect = screen.width / screen.height
    w = int(h * screen_aspect * 0.82)
    box = (x, y, x + w, y + h)
    draw_shadow(base, box, radius=42, alpha=64, blur=28, expand=26)

    frame = Image.new("RGBA", base.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(frame)
    draw.rounded_rectangle(box, radius=38, fill=bezel_color)
    base.alpha_composite(frame)

    bezel = max(14, int(w * 0.055))
    screen_box = (x + bezel, y + bezel, x + w - bezel, y + h - bezel)
    sw = screen_box[2] - screen_box[0]
    sh = screen_box[3] - screen_box[1]
    fitted = fit(screen, sw, sh)
    sx = screen_box[0] + (sw - fitted.width) // 2
    sy = screen_box[1] + (sh - fitted.height) // 2
    paste_rounded(base, fitted, (sx, sy), radius=28)
    return box


def draw_asset(base: Image.Image, asset: Image.Image, x: int, y: int, h: int):
    scale = h / asset.height
    resized = asset.resize((int(asset.width * scale), h), Image.Resampling.LANCZOS)
    base.alpha_composite(resized, (x, y))
    return (x, y, x + resized.width, y + resized.height)


def text_block(draw: ImageDraw.ImageDraw, x: int, y: int, lines: list[str], line_gap: int, font_obj, fill):
    yy = y
    for line in lines:
        draw.text((x, yy), line, font=font_obj, fill=fill)
        yy += font_obj.size + line_gap
    return yy


def icon_check(base: Image.Image, x: int, y: int, size: int):
    draw = ImageDraw.Draw(base)
    draw.ellipse((x, y, x + size, y + size), fill=BLUE)
    p1 = (x + int(size * 0.28), y + int(size * 0.53))
    p2 = (x + int(size * 0.45), y + int(size * 0.68))
    p3 = (x + int(size * 0.74), y + int(size * 0.34))
    draw.line([p1, p2, p3], fill=(255, 255, 255, 255), width=max(5, size // 11), joint="curve")


def icon_wifi_off(base: Image.Image, x: int, y: int, size: int):
    draw = ImageDraw.Draw(base)
    draw.ellipse((x, y, x + size, y + size), outline=BLUE, width=max(4, size // 16))
    cx = x + size // 2
    cy = y + size // 2 + int(size * 0.04)
    arc_w = max(3, size // 18)
    for scale in (0.64, 0.44, 0.22):
        box = (
            cx - int(size * scale * 0.5),
            cy - int(size * scale * 0.5),
            cx + int(size * scale * 0.5),
            cy + int(size * scale * 0.5),
        )
        draw.arc(box, 210, 330, fill=BLUE, width=arc_w)
    dot_r = max(3, size // 22)
    draw.ellipse((cx - dot_r, cy + size * 0.08 - dot_r, cx + dot_r, cy + size * 0.08 + dot_r), fill=BLUE)
    draw.line((x + int(size * 0.22), y + int(size * 0.22), x + int(size * 0.78), y + int(size * 0.78)), fill=BLUE, width=max(5, size // 13))


def pill(base: Image.Image, x: int, y: int, w: int, h: int, label: str, *, fill=(255, 255, 255, 235), outline=(0, 0, 0, 0), text_fill=TEXT):
    draw_shadow(base, (x, y, x + w, y + h), radius=h // 2, alpha=28, blur=22, expand=14)
    panel = Image.new("RGBA", base.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(panel)
    draw.rounded_rectangle((x, y, x + w, y + h), radius=h // 2, fill=fill, outline=outline, width=2 if outline[3] else 0)
    base.alpha_composite(panel)
    f = font(FONT_SEMIBOLD, int(h * 0.42))
    bbox = draw.textbbox((0, 0), label, font=f)
    tx = x + (w - (bbox[2] - bbox[0])) // 2
    ty = y + (h - (bbox[3] - bbox[1])) // 2 - 2
    ImageDraw.Draw(base).text((tx, ty), label, font=f, fill=text_fill)


def label_value(draw, x: int, y: int, title: str, subtitle: str):
    bold = font(FONT_SEMIBOLD, 34)
    regular = font(FONT_REGULAR, 22)
    draw.text((x, y), title, font=bold, fill=TEXT)
    draw.text((x, y + 48), subtitle, font=regular, fill=TEXT_MUTED)


def draw_radio(draw, cx: int, cy: int, selected: bool):
    outer = 18
    draw.ellipse((cx - outer, cy - outer, cx + outer, cy + outer), outline=BLUE if selected else (130, 132, 140, 255), width=4)
    if selected:
        inner = 8
        draw.ellipse((cx - inner, cy - inner, cx + inner, cy + inner), fill=BLUE)


def draw_sun_icon(draw: ImageDraw.ImageDraw, x: int, y: int, size: int, fill):
    cx = x + size // 2
    cy = y + size // 2
    core = size * 0.18
    draw.ellipse((cx - core, cy - core, cx + core, cy + core), fill=fill)
    for angle in range(0, 360, 45):
        inner = size * 0.28
        outer = size * 0.42
        rad = math.radians(angle)
        x0 = cx + math.cos(rad) * inner
        y0 = cy + math.sin(rad) * inner
        x1 = cx + math.cos(rad) * outer
        y1 = cy + math.sin(rad) * outer
        draw.line((x0, y0, x1, y1), fill=fill, width=max(2, size // 16))


def draw_moon_icon(draw: ImageDraw.ImageDraw, x: int, y: int, size: int, fill, bg):
    cx = x + size // 2
    cy = y + size // 2
    r = size * 0.34
    draw.ellipse((cx - r, cy - r, cx + r, cy + r), fill=fill)
    offset = size * 0.14
    cut = rgba(bg)
    draw.ellipse((cx - r + offset, cy - r - offset * 0.2, cx + r + offset, cy + r - offset * 0.2), fill=cut)


def draw_theme_card(base: Image.Image, x: int, y: int, w: int, h: int, selected: str, dark: bool = False):
    radius = 28
    draw_shadow(base, (x, y, x + w, y + h), radius=radius, alpha=28 if not dark else 42, blur=24, expand=18)
    panel = Image.new("RGBA", base.size, (0, 0, 0, 0))
    panel_draw = ImageDraw.Draw(panel)
    fill = (255, 255, 255, 236) if not dark else (39, 40, 46, 235)
    border = (222, 224, 228, 255) if not dark else (61, 63, 70, 255)
    panel_draw.rounded_rectangle((x, y, x + w, y + h), radius=radius, fill=fill, outline=border, width=2)
    mid = y + h // 2
    panel_draw.line((x + 24, mid, x + w - 24, mid), fill=(228, 230, 234, 255) if not dark else (74, 76, 82, 255), width=2)
    base.alpha_composite(panel)

    draw = ImageDraw.Draw(base)
    fg = TEXT if not dark else TEXT_LIGHT
    bg_fill = fill
    draw_sun_icon(draw, x + 34, y + 28, 36, fg)
    draw.text((x + 110, y + 34), "Light", font=font(FONT_SEMIBOLD, 28), fill=fg)
    draw_moon_icon(draw, x + 34, y + h // 2 + 28, 36, fg, bg_fill)
    draw.text((x + 110, y + h // 2 + 34), "Dark", font=font(FONT_SEMIBOLD, 28), fill=fg)
    draw_radio(draw, x + w - 54, y + h // 4, selected == "light")
    draw_radio(draw, x + w - 54, y + h * 3 // 4, selected == "dark")


def draw_week_card(base: Image.Image, x: int, y: int, w: int, h: int, selected: str, dark: bool = False):
    radius = 28
    draw_shadow(base, (x, y, x + w, y + h), radius=radius, alpha=28 if not dark else 42, blur=24, expand=18)
    panel = Image.new("RGBA", base.size, (0, 0, 0, 0))
    panel_draw = ImageDraw.Draw(panel)
    fill = (255, 255, 255, 236) if not dark else (39, 40, 46, 235)
    border = (222, 224, 228, 255) if not dark else (61, 63, 70, 255)
    divider = (228, 230, 234, 255) if not dark else (74, 76, 82, 255)
    panel_draw.rounded_rectangle((x, y, x + w, y + h), radius=radius, fill=fill, outline=border, width=2)
    row_h = h // 3
    for i in range(1, 3):
        yy = y + row_h * i
        panel_draw.line((x + 24, yy, x + w - 24, yy), fill=divider, width=2)
    base.alpha_composite(panel)

    draw = ImageDraw.Draw(base)
    fg = TEXT if not dark else TEXT_LIGHT
    sunday_fill = RED if not dark else (255, 82, 82, 255)
    saturday_fill = (84, 137, 255, 255)
    rows = [
        ("S", "Sunday", sunday_fill, "sunday"),
        ("M", "Monday", fg, "monday"),
        ("S", "Saturday", saturday_fill, "saturday"),
    ]
    for idx, (mark, label, mark_fill, key) in enumerate(rows):
        cy = y + row_h * idx + row_h // 2
        draw.text((x + 42, cy - 28), mark, font=font(FONT_SEMIBOLD, 40), fill=mark_fill)
        draw.text((x + 118, cy - 20), label, font=font(FONT_SEMIBOLD, 28), fill=fg)
        draw_radio(draw, x + w - 54, cy, key == selected)


def load_assets():
    ipad_light = crop(rotate(RAW / "ipad-light-main.png", -90), (16, 16, 2250, 1472))
    ipad_dark = crop(rotate(RAW / "ipad-dark-main.png", -90), (16, 16, 2250, 1472))
    iphone_light = Image.open(PHONE_FOCUS / "iphone-se-light-framed.png").convert("RGBA")
    iphone_dark = Image.open(PHONE_FOCUS / "iphone-se-dark-framed.png").convert("RGBA")

    return {
        "ipad_light": ipad_light,
        "ipad_dark": ipad_dark,
        "iphone_light": iphone_light,
        "iphone_dark": iphone_dark,
    }


def slide_one(size, assets, copy):
    base = make_background(size, dark=False)
    draw = ImageDraw.Draw(base)
    title_font = font(FONT_HEAVY, copy.get("title_size", 68))
    body_font = font(FONT_REGULAR, 28)

    text_block(draw, 72, 86, copy["main"], 18, title_font, TEXT)

    bullet_y = 420
    for idx, (head, sub) in enumerate(copy["bullets"]):
        y = bullet_y + idx * 150
        icon_check(base, 74, y + 8, 44)
        draw.text((138, y), head, font=font(FONT_SEMIBOLD, 34), fill=TEXT)
        draw.text((138, y + 54), sub, font=body_font, fill=TEXT_MUTED)

    draw_ipad(base, assets["ipad_light"], 840, 90, 920)
    draw_asset(base, assets["iphone_dark"], 1564, 308, 570)
    return base


def slide_two(size, assets, copy):
    base = make_background(size, dark=False)
    draw = ImageDraw.Draw(base)
    title_font = font(FONT_HEAVY, copy.get("title_size", 84))
    body_font = font(FONT_REGULAR, 30)

    text_block(draw, 72, 118, copy["main"], 18, title_font, TEXT)
    text_block(draw, 78, 438, copy["sub"], 16, body_font, TEXT)

    icon_wifi_off(base, 68, 726, 92)
    draw.text((188, 742), copy["support"][0], font=font(FONT_SEMIBOLD, 28), fill=TEXT)
    draw.text((188, 792), copy["support"][1], font=font(FONT_SEMIBOLD, 28), fill=TEXT)

    draw_ipad(base, assets["ipad_dark"], 760, 78, 980)
    draw_asset(base, assets["iphone_light"], 1548, 286, 610)
    return base


def slide_three(size, assets, copy):
    base = make_background(size, dark=False)
    draw = ImageDraw.Draw(base)
    title_font = font(FONT_HEAVY, copy.get("title_size", 84))
    body_font = font(FONT_REGULAR, 28)

    text_block(draw, 72, 104, copy["main"], 18, title_font, TEXT)
    text_block(draw, 78, 366, copy["sub"], 16, body_font, TEXT_MUTED)

    draw_ipad(base, assets["ipad_light"], 790, 118, 650, bezel_color=(10, 10, 12, 255), inner_border=(60, 60, 64, 255))
    draw_asset(base, assets["iphone_light"], 1492, 108, 332)

    draw_ipad(base, assets["ipad_dark"], 980, 568, 544, bezel_color=(14, 14, 18, 255), inner_border=(66, 66, 72, 255))
    draw_asset(base, assets["iphone_dark"], 1528, 534, 328)
    return base


def slide_four(size, assets, copy):
    base = make_background(size, dark=False)
    draw = ImageDraw.Draw(base)
    title_font = font(FONT_HEAVY, copy.get("title_size", 84))
    body_font = font(FONT_REGULAR, 28)

    text_block(draw, 72, 108, copy["main"], 18, title_font, TEXT)
    text_block(draw, 78, 366, copy["sub"], 16, body_font, TEXT_MUTED)

    draw_shadow(base, (842, 132, 1760, 932), radius=46, alpha=48, blur=32, expand=24)
    panel = Image.new("RGBA", base.size, (0, 0, 0, 0))
    ImageDraw.Draw(panel).rounded_rectangle((842, 132, 1760, 932), radius=46, fill=(255, 255, 255, 215))
    base.alpha_composite(panel)
    draw_theme_card(base, 910, 206, 780, 210, selected="light", dark=False)
    draw_week_card(base, 910, 474, 780, 360, selected="monday", dark=False)

    pill(base, 86, 714, 210, 70, copy["pills"][0], fill=(255, 255, 255, 238))
    pill(base, 314, 714, 210, 70, copy["pills"][1], fill=(231, 241, 255, 255), outline=(88, 145, 255, 70), text_fill=(24, 76, 188, 255))
    pill(base, 542, 714, 210, 70, copy["pills"][2], fill=(255, 255, 255, 238))
    draw.text((92, 820), copy["footer"], font=font(FONT_REGULAR, 24), fill=TEXT_MUTED)
    return base


def slide_five(size, assets, copy):
    base = make_background(size, dark=False)
    draw = ImageDraw.Draw(base)
    title_font = font(FONT_HEAVY, copy.get("title_size", 64))
    body_font = font(FONT_REGULAR, 28)

    text_block(draw, 72, 108, copy["main"], 14, title_font, TEXT)
    text_block(draw, 78, 352, copy["sub"], 16, body_font, TEXT_MUTED)

    draw_ipad(base, assets["ipad_light"], 842, 102, 930)
    draw_asset(base, assets["iphone_dark"], 1496, 432, 520)
    return base


def contact_sheet(images: list[Image.Image], out_path: Path):
    w, h = images[0].size
    thumb_w = 540
    thumb_h = int(h * (thumb_w / w))
    sheet = Image.new("RGBA", (thumb_w * 2 + 60, thumb_h * 3 + 80), (245, 245, 245, 255))
    positions = [(20, 20), (thumb_w + 40, 20), (20, thumb_h + 40), (thumb_w + 40, thumb_h + 40), (20, thumb_h * 2 + 60)]
    for img, pos in zip(images, positions):
        thumb = img.resize((thumb_w, thumb_h), Image.Resampling.LANCZOS)
        sheet.paste(thumb, pos)
    sheet.save(out_path)


def main():
    locale_aliases = {}
    for locale, data in BUNDLE["locales"].items():
        locale_aliases[locale] = locale
        locale_aliases[data["doc_tag"]] = locale

    parser = argparse.ArgumentParser()
    parser.add_argument("--width", type=int, default=1920)
    parser.add_argument("--height", type=int, default=1080)
    parser.add_argument("--locale", choices=sorted(locale_aliases.keys()), default="ja-JP")
    parser.add_argument("--out", type=Path)
    args = parser.parse_args()

    locale = locale_aliases[args.locale]
    locale_data = BUNDLE["locales"][locale]
    doc_tag = locale_data["doc_tag"]

    if args.out is None:
        args.out = ROOT / "tmp/appstore_assets" / f"{doc_tag}_reference_final"

    set_font_profile(locale_data["font_profile"])
    args.out.mkdir(parents=True, exist_ok=True)
    assets = load_assets()
    size = (args.width, args.height)
    copy = locale_data["screenshots"]

    slides = [
        slide_one(size, assets, copy["slide_1"]),
        slide_two(size, assets, copy["slide_2"]),
        slide_three(size, assets, copy["slide_3"]),
        slide_four(size, assets, copy["slide_4"]),
        slide_five(size, assets, copy["slide_5"]),
    ]

    for idx, slide in enumerate(slides, start=1):
        slide.save(args.out / f"{doc_tag}-slide-{idx:02d}.png")

    contact_sheet(slides, args.out / f"{doc_tag}-contact-sheet.png")


if __name__ == "__main__":
    main()
