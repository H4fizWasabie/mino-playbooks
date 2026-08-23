# Compose Image + Caption for Instagram

## Inputs

| Source | File/Location | Section/Scope | Why |
| --- | --- | --- | --- |
| Previous stage | `../01-judgment/output/topic.md` | Full file | The chosen topic + angle |
| Runtime | Authoritative local date | Full | Date-stamp the image filename |

## Process

1. Read the topic from `../01-judgment/output/topic.md`.
2. In ONE generate_image call: generate a catchy square image for the topic (vibrant, modern, text-free, abstract geometric shapes — no fine detail, no logos). Then evaluate with `view_image` on the returned local artifact path BEFORE anything is published: write a short critique of what it actually shows — on-topic, genuinely text-free, no logos or garbled artifacts, visually distinct from recent posts. If the critique finds a material flaw, regenerate ONCE fixing that flaw, then re-evaluate; only keep an image that passed critique. If it still fails after regeneration, pick a new topic and try once more before giving up. **The critique is INTERNAL WORKING ONLY — record it in your reasoning / the image filename note, NEVER inside the caption text or caption.md. It must never appear in the published post.**
3. Write a human-sounding caption for the topic (2-4 sentences, plain voice, one hook line). **The caption is the PUBLISHED post text and ONLY that — the human-facing words a reader sees. It MUST NOT contain ANY internal metadata: no "Generated:", no "Topic:", no "Image verified:", no critique notes, no verification details, no date-stamps, no headings, no "---" separators, no asterisk-italics footers. A caption that includes any of those leaks internal process into the post and is a FAILED caption — rewrite it clean before saving.**
4. In ONE bash call: sync the image to `/home/mino/images/instagram-YYYY-MM-DD.jpg` (use sync_file), chmod 644, and curl-verify the public URL `https://vultr-1.tail8e6639.ts.net/images/instagram-YYYY-MM-DD.jpg` returns 200.
   TRANSPORT RULE (mandatory, proven live 08-18/08-19 and 08-21): use the HTTPS Tailscale Funnel URL `https://vultr-1.tail8e6639.ts.net/images/<file>` for publishing. NEVER use `http://149.28.146.30/...` — the plain-HTTP datacenter IP is not reachable by Instagram's fetcher (HTTP 400/522) and has never succeeded for publishing. The HTTPS Funnel URL is the only one that works.
5. Write `output/caption.md`: the caption text (ONLY the human post text, per step 3) and the verified image URL. The file may also hold a separate, clearly-labelled `## Critique` section for the internal image critique — but NEVER inside the caption text itself.

## Tools

- generate_image
- view_image
- sync_file
- bash
- write_file

## Outputs

| Artifact | Location | Format |
| --- | --- | --- |
| Caption + image URL | `output/caption.md` | Markdown: caption + verified HTTPS URL |
