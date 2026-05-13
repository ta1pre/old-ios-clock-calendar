#!/Users/taichiumeki/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3

from __future__ import annotations

import json
from html import escape
from pathlib import Path

from localization_bundle import APP_NAME, BASE_URL, BUNDLE, CATEGORY, CONTACT_EMAIL, COPYRIGHT, PRICE_USD


ROOT = Path("/Users/taichiumeki/projects/clockApp")
DOCS = ROOT / "docs/app_store"
LOCALIZATIONS_DIR = DOCS / "localizations"
SITE_ROOT = ROOT / "site"


def locale_url(path: str, suffix: str = "") -> str:
    if not path:
        return f"{BASE_URL}{suffix}"
    return f"{BASE_URL}{path}/{suffix}"


def marketing_url(path: str) -> str:
    if not path:
        return BASE_URL
    return f"{BASE_URL}{path}/"


def screenshot_doc(locale: str, data: dict) -> str:
    lines = [
        f"# {data['native_name']} Screenshot Plan",
        "",
        "This file records the localized App Store screenshot copy for this locale.",
        "",
        "## Output Policy",
        "",
        "- Use the approved Japanese layout as the visual base",
        "- Keep the reference size at `1920 x 1080`",
        "- Keep the app screen time fixed at `10:10`",
        "- Adapt for natural store copy, not literal translation",
        "",
    ]
    for idx in range(1, 6):
        slide = data["screenshots"][f"slide_{idx}"]
        lines.extend([f"## Slide {idx}", ""])
        lines.extend(["- Main:"])
        for text in slide["main"]:
            lines.append(f"  - {text}")
        if "bullets" in slide:
            lines.append("- Points:")
            for head, sub in slide["bullets"]:
                lines.append(f"  - {head} / {sub}")
        if "sub" in slide:
            lines.append("- Sub:")
            for text in slide["sub"]:
                lines.append(f"  - {text}")
        if "support" in slide:
            lines.append("- Support:")
            for text in slide["support"]:
                lines.append(f"  - {text}")
        if "pills" in slide:
            lines.append("- Pills:")
            for text in slide["pills"]:
                lines.append(f"  - {text}")
        if "footer" in slide:
            lines.append(f"- Footer: {slide['footer']}")
        lines.append("")
    return "\n".join(lines).rstrip() + "\n"


def render_language_chip(data: dict) -> str:
    path = data["path"]
    href = "./" if not path else "../"
    label = escape(data["native_name"])
    return f'<span class="active">{label}</span>'


def home_page(locale: str, data: dict) -> str:
    site = data["site"]
    prefix = "./" if not data["path"] else "../"
    lang = escape(locale)
    title = escape(APP_NAME)
    return f"""<!DOCTYPE html>
<html lang="{lang}">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>{title}</title>
    <link rel="stylesheet" href="{prefix}styles.css" />
  </head>
  <body>
    <main class="wrap">
      <section class="panel">
        <nav class="lang-switch" aria-label="Language">
          {render_language_chip(data)}
        </nav>
        <div class="eyebrow">{escape(site["eyebrow_home"])}</div>
        <h1>{title}</h1>
        <p>{escape(site["home_summary"])}</p>
        <p class="muted">{escape(site["home_muted"])}</p>

        <div class="nav">
          <a href="./support/">{escape(site["eyebrow_support"])}</a>
          <a href="./privacy/">{escape(site["eyebrow_privacy"])}</a>
        </div>

        <div class="meta">{escape(site["home_meta"])}</div>
      </section>
    </main>
  </body>
</html>
"""


def support_page(locale: str, data: dict) -> str:
    site = data["site"]
    prefix = "../" if not data["path"] else "../../"
    home_href = "../" if data["path"] else "../"
    privacy_href = "../privacy/" if data["path"] else "../privacy/"
    lang = escape(locale)
    title = escape(APP_NAME)
    bullets = "\n".join(f"          <li>{escape(item)}</li>" for item in site["support_bullets"])
    return f"""<!DOCTYPE html>
<html lang="{lang}">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>{escape(site["eyebrow_support"])} | {title}</title>
    <link rel="stylesheet" href="{prefix}styles.css" />
  </head>
  <body>
    <main class="wrap">
      <section class="panel">
        <nav class="lang-switch" aria-label="Language">
          {render_language_chip(data)}
        </nav>
        <div class="eyebrow">{escape(site["eyebrow_support"])}</div>
        <h1>{title}</h1>
        <p>{escape(site["support_summary"])}</p>

        <h2>{escape(site["support_what_title"])}</h2>
        <ul>
{bullets}
        </ul>

        <h2>{escape(site["support_contact_title"])}</h2>
        <p>
          {escape(site["support_contact_body"])}
          <a class="inline-link" href="mailto:{CONTACT_EMAIL}">{CONTACT_EMAIL}</a>
        </p>

        <h2>{escape(site["support_compatibility_title"])}</h2>
        <p>{escape(site["support_compatibility_body"])}</p>

        <div class="nav">
          <a href="{home_href}">{escape(site["eyebrow_home"])}</a>
          <a href="{privacy_href}">{escape(site["eyebrow_privacy"])}</a>
        </div>

        <div class="meta">{escape(site["support_meta_prefix"])} <code>{CONTACT_EMAIL}</code></div>
      </section>
    </main>
  </body>
</html>
"""


def privacy_page(locale: str, data: dict) -> str:
    site = data["site"]
    prefix = "../" if not data["path"] else "../../"
    home_href = "../" if data["path"] else "../"
    support_href = "../support/" if data["path"] else "../support/"
    lang = escape(locale)
    title = escape(APP_NAME)
    return f"""<!DOCTYPE html>
<html lang="{lang}">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>{escape(site["eyebrow_privacy"])} | {title}</title>
    <link rel="stylesheet" href="{prefix}styles.css" />
  </head>
  <body>
    <main class="wrap">
      <section class="panel">
        <nav class="lang-switch" aria-label="Language">
          {render_language_chip(data)}
        </nav>
        <div class="eyebrow">{escape(site["eyebrow_privacy"])}</div>
        <h1>{title}</h1>
        <p>{escape(site["privacy_effective_date"])}</p>

        <p>{escape(site["privacy_intro"])}</p>

        <h2>{escape(site["privacy_data_title"])}</h2>
        <p>{escape(site["privacy_data_body"])}</p>

        <h2>{escape(site["privacy_network_title"])}</h2>
        <p>{escape(site["privacy_network_body"])}</p>

        <h2>{escape(site["privacy_ads_title"])}</h2>
        <p>{escape(site["privacy_ads_body"])}</p>

        <h2>{escape(site["privacy_local_title"])}</h2>
        <p>{escape(site["privacy_local_body"])}</p>

        <h2>{escape(site["privacy_contact_title"])}</h2>
        <p>
          {escape(site["privacy_contact_body"])}
          <a class="inline-link" href="mailto:{CONTACT_EMAIL}">{CONTACT_EMAIL}</a>
        </p>

        <div class="nav">
          <a href="{home_href}">{escape(site["eyebrow_home"])}</a>
          <a href="{support_href}">{escape(site["eyebrow_support"])}</a>
        </div>

        <div class="meta">{escape(site["privacy_meta_prefix"])} <code>{CONTACT_EMAIL}</code></div>
      </section>
    </main>
  </body>
</html>
"""


def write_text(path: Path, body: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(body, encoding="utf-8")


def main() -> None:
    bundle_locales = BUNDLE["locales"]
    rollout = {"defaultLocale": BUNDLE["default_locale"], "locales": []}

    for locale, data in bundle_locales.items():
        path = data["path"]
        metadata = data["metadata"]
        metadata_json = {
            "locale": locale,
            "isDefault": data["is_default"],
            "appName": APP_NAME,
            "subtitle": metadata["subtitle"],
            "promotionalText": metadata["promotional_text"],
            "description": metadata["description"],
            "keywords": metadata["keywords"],
            "supportURL": locale_url(path, "support/"),
            "privacyURL": locale_url(path, "privacy/"),
            "marketingURL": marketing_url(path),
            "category": CATEGORY,
            "priceUSD": PRICE_USD,
            "copyright": COPYRIGHT,
            "reviewNotes": metadata["review_notes"],
        }
        json_body = json.dumps(metadata_json, ensure_ascii=False, indent=2) + "\n"
        write_text(LOCALIZATIONS_DIR / f"{locale}.json", json_body)
        write_text(DOCS / f"screenshots_{data['doc_tag']}.md", screenshot_doc(locale, data))

        if path:
            locale_root = SITE_ROOT / path
            write_text(locale_root / "index.html", home_page(locale, data))
            write_text(locale_root / "support/index.html", support_page(locale, data))
            write_text(locale_root / "privacy/index.html", privacy_page(locale, data))
        else:
            write_text(SITE_ROOT / "index.html", home_page(locale, data))
            write_text(SITE_ROOT / "support/index.html", support_page(locale, data))
            write_text(SITE_ROOT / "privacy/index.html", privacy_page(locale, data))

        rollout["locales"].append(
            {
                "locale": locale,
                "language": data["native_name"],
                "tier": 0 if locale in {"en-US", "ja-JP"} else 1,
                "status": "done",
                "text": "done",
                "screenshots": "done",
                "supportPage": "done",
                "privacyPage": "done",
            }
        )

    rollout["locales"] = sorted(rollout["locales"], key=lambda item: (item["tier"], item["locale"]))
    write_text(DOCS / "locale_rollout.json", json.dumps(rollout, ensure_ascii=False, indent=2) + "\n")


if __name__ == "__main__":
    main()
