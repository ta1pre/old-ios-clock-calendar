#!/Users/taichiumeki/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3

from __future__ import annotations

import json
from pathlib import Path

from PIL import Image, ImageFont

from localization_bundle import APP_NAME, BUNDLE


ROOT = Path("/Users/taichiumeki/projects/clockApp")
DOCS = ROOT / "docs/app_store"
SITE = ROOT / "site"
ASSETS = ROOT / "tmp/appstore_assets"

REF_SIZE = (1920, 1080)
SUBMISSION_SPECS = {
    "iphone_6_9_landscape": (2796, 1290),
    "ipad_13_landscape": (2752, 2064),
}

JA_FONT_HEAVY = "/System/Library/Fonts/ヒラギノ角ゴシック W8.ttc"
JA_FONT_SEMIBOLD = "/System/Library/Fonts/ヒラギノ角ゴシック W6.ttc"
JA_FONT_REGULAR = "/System/Library/Fonts/ヒラギノ角ゴシック W4.ttc"
EN_FONT_HEAVY = "/System/Library/Fonts/Supplemental/Arial Black.ttf"
EN_FONT_SEMIBOLD = "/System/Library/Fonts/Supplemental/Arial Bold.ttf"
EN_FONT_REGULAR = "/System/Library/Fonts/Supplemental/Arial.ttf"
KO_FONT = "/System/Library/Fonts/AppleSDGothicNeo.ttc"
ZH_FONT = "/System/Library/Fonts/STHeiti Medium.ttc"


def font_set(profile: str) -> tuple[str, str, str]:
    if profile == "latin":
        return EN_FONT_HEAVY, EN_FONT_SEMIBOLD, EN_FONT_REGULAR
    if profile == "ko":
        return KO_FONT, KO_FONT, KO_FONT
    if profile == "zh":
        return ZH_FONT, ZH_FONT, ZH_FONT
    return JA_FONT_HEAVY, JA_FONT_SEMIBOLD, JA_FONT_REGULAR


def text_width(text: str, font_path: str, size: int) -> int:
    font = ImageFont.truetype(font_path, size=size)
    left, _, right, _ = font.getbbox(text)
    return right - left


def validate_text_fit(locale: str, data: dict) -> list[str]:
    issues: list[str] = []
    heavy, semibold, regular = font_set(data["font_profile"])
    shots = data["screenshots"]

    checks = [
        ("slide_1", shots["slide_1"]["main"], heavy, shots["slide_1"].get("title_size", 68), 760, "main"),
        ("slide_2", shots["slide_2"]["main"], heavy, shots["slide_2"].get("title_size", 84), 760, "main"),
        ("slide_3", shots["slide_3"]["main"], heavy, shots["slide_3"].get("title_size", 84), 760, "main"),
        ("slide_4", shots["slide_4"]["main"], heavy, shots["slide_4"].get("title_size", 84), 760, "main"),
        ("slide_5", shots["slide_5"]["main"], heavy, shots["slide_5"].get("title_size", 64), 760, "main"),
    ]

    for slide_name, lines, path, size, limit, label in checks:
        for line in lines:
            if text_width(line, path, size) > limit:
                issues.append(f"{slide_name}:{label} line too wide: {line}")

    for line in shots["slide_2"].get("sub", []):
        if text_width(line, regular, 30) > 640:
            issues.append(f"slide_2:sub line too wide: {line}")
    for line in shots["slide_2"].get("support", []):
        if text_width(line, semibold, 28) > 420:
            issues.append(f"slide_2:support line too wide: {line}")
    for line in shots["slide_3"].get("sub", []):
        if text_width(line, regular, 28) > 640:
            issues.append(f"slide_3:sub line too wide: {line}")
    for line in shots["slide_4"].get("sub", []):
        if text_width(line, regular, 28) > 680:
            issues.append(f"slide_4:sub line too wide: {line}")
    for pill in shots["slide_4"].get("pills", []):
        if text_width(pill, semibold, 29) > 160:
            issues.append(f"slide_4:pill too wide: {pill}")
    for line in shots["slide_5"].get("sub", []):
        if text_width(line, regular, 28) > 680:
            issues.append(f"slide_5:sub line too wide: {line}")

    for head, sub in shots["slide_1"].get("bullets", []):
        if text_width(head, semibold, 34) > 540:
            issues.append(f"slide_1:bullet head too wide: {head}")
        if text_width(sub, regular, 28) > 640:
            issues.append(f"slide_1:bullet sub too wide: {sub}")

    return issues


def image_size(path: Path) -> tuple[int, int]:
    with Image.open(path) as image:
        return image.size


def main() -> None:
    report: dict[str, dict] = {}

    for locale, data in BUNDLE["locales"].items():
        tag = data["doc_tag"]
        path = data["path"]
        locale_issues: list[str] = []
        metadata_path = DOCS / "localizations" / f"{locale}.json"
        screenshots_doc = DOCS / f"screenshots_{tag}.md"
        site_root = SITE if not path else SITE / path
        ref_root = ASSETS / f"{tag}_reference_final"
        sub_root = ASSETS / "submission" / tag

        if not metadata_path.exists():
            locale_issues.append("missing metadata json")
        else:
            metadata = json.loads(metadata_path.read_text(encoding="utf-8"))
            if metadata["appName"] != APP_NAME:
                locale_issues.append("app name mismatch")
            if len(metadata["subtitle"]) > 30:
                locale_issues.append("subtitle exceeds 30 chars")
            if len(metadata["promotionalText"]) > 170:
                locale_issues.append("promotional text exceeds 170 chars")
            if len(metadata["description"]) > 4000:
                locale_issues.append("description exceeds 4000 chars")
            if len(metadata["keywords"]) > 100:
                locale_issues.append("keywords exceeds 100 chars")

        if not screenshots_doc.exists():
            locale_issues.append("missing screenshot copy doc")

        for html_path in [site_root / "index.html", site_root / "support/index.html", site_root / "privacy/index.html"]:
            if not html_path.exists():
                locale_issues.append(f"missing site page: {html_path}")

        for idx in range(1, 6):
            slide = ref_root / f"{tag}-slide-{idx:02d}.png"
            if not slide.exists():
                locale_issues.append(f"missing reference slide {idx}")
            elif image_size(slide) != REF_SIZE:
                locale_issues.append(f"reference slide {idx} wrong size")
        if not (ref_root / f"{tag}-contact-sheet.png").exists():
            locale_issues.append("missing reference contact sheet")

        for family, size in SUBMISSION_SPECS.items():
            family_root = sub_root / family
            for idx in range(1, 6):
                slide = family_root / f"{tag}-slide-{idx:02d}.png"
                if not slide.exists():
                    locale_issues.append(f"missing submission slide {family}:{idx}")
                elif image_size(slide) != size:
                    locale_issues.append(f"submission slide wrong size {family}:{idx}")
            if not (family_root / f"{tag}-{family}-contact-sheet.png").exists():
                locale_issues.append(f"missing submission contact sheet {family}")

        locale_issues.extend(validate_text_fit(locale, data))

        report[locale] = {
            "status": "pass" if not locale_issues else "fail",
            "issues": locale_issues,
        }

    out_dir = DOCS / "reviews"
    out_dir.mkdir(parents=True, exist_ok=True)
    (out_dir / "localization_audit.json").write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    lines = ["# Localization Audit", ""]
    for locale, data in report.items():
        lines.append(f"## {locale}")
        lines.append("")
        lines.append(f"- Status: {data['status']}")
        if data["issues"]:
            for issue in data["issues"]:
                lines.append(f"- Issue: {issue}")
        else:
            lines.append("- Issue: none")
        lines.append("")
    (out_dir / "localization_audit.md").write_text("\n".join(lines), encoding="utf-8")


if __name__ == "__main__":
    main()
