# Compose Image + Caption for Instagram

## Inputs

| Source | File/Location | Section/Scope | Why |
| --- | --- | --- | --- |
| Previous stage | `../01-judgment/output/topic.md` | Full file | The chosen topic + angle |
| Runtime | Authoritarian local date | Full | Date-stamp the image filename |

## Process

1. Read the topic from `../01-judgment/output/topic.md`.
2. In ONE generate_image call: generate a catchy square image for the topic (vibrant, modern, text-free, abstract geometric shapes — no fine detail, no logos). Then evaluate with `view_image` on the returned local artifact path BEFORE anything is published: write a short critique of what it actually shows — on-topic, genuinely text-free, no logos or garbled artifacts, visually distinct from recent posts. If the critique finds a material flaw, regenerate ONCE fixing that flaw, then re-evaluate; only keep an image that passed critique. If it still fails after regeneration, pick a new topic and try once more before giving up. **The critique is INTERNAL WORKING ONLY — record it in your reasoning / the image filename note, NEVER inside the caption text or caption.md. It must never appear in the published post.**
3. Write a human-sounding caption for the topic (2-4 sentences, plain voice, one hook line). **The caption is the PUBLISHED post text and ONLY that — the human-facing words a reader sees. It MUST NOT contain ANY internal metadata: no "Generated:", no "Topic:", no "Image verified:", no critique notes, no verification details, no date-stamps, no headings, no "---" separators, no asterisk-italics footers. A caption that includes any of those leaks internal process into the post and is a FAILED caption — rewrite it clean before saving.**
4. **Image sync (two separate tool calls):**
   - (a) Use `sync_file` to copy the generated image to `/home/mino/images/instagram-YYYY-MM-DD.jpg` (YYYY-MM-DD = today's date). This is a harness tool call, NOT a bash command.
   - (b) Use `bash` to `chmod 644 /home/mino/images/instagram-YYYY-MM-DD.jpg`.
   - (c) Use `bash` for a separate `curl -sI` call against the public URL `https://vultr-1.tail8e6639.ts.net/images/instagram-YYYY-MM-DD.jpg`. Assert: (a) the URL starts with `https://vultr-1.tail8e6639.ts.net/images/`, (b) HTTP status is 200, and (c) Content-Type includes `image/jpeg`.

   FAILURE GATE (non-overridable): if sync_file fails, OR if curl does NOT return HTTP 200, OR if Content-Type does NOT include `image/jpeg`, use `write_file` to write `output/failure.md` with the reason and the URL that failed, do NOT write `output/caption.md` or `output/url-verified.md`, and STOP — this stage has failed. Do not guess, retry with a different URL, or fall back to http://149.28.146.30.

   TRANSPORT RULE (mandatory, proven live 08-18/08-19 and 08-21): the canonical public base is `https://vultr-1.tail8e6639.ts.net/images/`. NEVER use `http://149.28.146.30/...` — the plain-HTTP datacenter IP is not reachable by Instagram's fetcher (HTTP 400/522) and has never succeeded. NEVER construct or accept any URL containing `http://149.28.146.30`.
5. **URL-VERIFIED RECEIPT (non-overridable, mandatory):** After step 4's curl check passes, IMMEDIATELY use `write_file` to create `output/url-verified.md` containing ALL of the following — this receipt is the ONLY proof Stage 03 will accept. Do NOT use bash redirects (echo >, cat >) to write this file — the harness rejects output files not written by sanctioned tools:
   ```
   # URL Verification Receipt
   
   - **Image URL:** <the exact HTTPS URL>
   - **HTTP Status:** 200
   - **Content-Type:** image/jpeg
   - **Verified at:** <ISO 8601 timestamp, e.g. 2026-08-26T10:55:00+08:00>
   - **Filename:** instagram-YYYY-MM-DD.jpg
   ```
   If you skip this receipt, Stage 03 will correctly abort (no receipt = no publish). Do NOT write this receipt if step 4 failed.
6. Use `write_file` to create `output/caption.md`: the caption text (ONLY the human post text, per step 3) and the verified image URL. Do NOT use bash redirects to write this file. The file may also hold a separate, clearly-labelled `## Critique` section for the internal image critique — but NEVER inside the caption text itself.

## OUTPUT PROVENANCE RULE (non-overridable)

Every file under `output/` MUST be written using the `write_file` harness tool (or `sync_file` for image/copy artifacts). NEVER use bash redirects (>, >>, cat >, echo >, tee >) to create or overwrite `output/` files. The harness validates output provenance: a file that physically exists but was not written by a sanctioned tool is treated as NOT WRITTEN, and the stage will fail with "output/X.md exists but was not written by this stage's tools".

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
| URL verification receipt | `output/url-verified.md` | Markdown: URL, status, content type, timestamp |
## Recovery Protocol (fix-or-adapt)

A skip-reason output is a successful outcome; ending without the declared outputs is the only true failure. On trouble, recover in-contract instead of reporting failure bare:

- Image fails the vision critique → regenerate ONCE with the specific flaw fixed; a second failure → write the critique verdict and end (stage 03 will skip the day).
- Public URL sync fails → do not proceed; write the failure to the output so stage 03 skips with a reason.
- Escalate to the owner only what genuinely blocked the run, with evidence and the recovery already attempted. The Telegram report (when declared) is never dropped — EXACTLY ONCE per run.
