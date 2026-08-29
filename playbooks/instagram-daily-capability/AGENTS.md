# Instagram Daily Capability Posts

This workspace produces one verified Instagram capability post per scheduled
run. Mino is the single autonomous agent; stages, personas, and tools are
workspace resources, not separate agents.

## Folder Map

```text
instagram-daily-capability/
├── AGENTS.md                 # workspace map and operating rules
├── CONTEXT.md                # workflow routing
├── config.md                 # schedule/runtime binding
├── persona/                  # post-writing voice
├── stages/                   # numbered execution contracts
├── runs/                     # per-run state and handoffs
└── tools/                    # routing health checks
```

## Triggers

| Trigger | Action |
|---|---|
| `instagram` / `daily capability post` | Run `CONTEXT.md` from stage 01 |
| `status` | Report stage/run status and run `tools/link-check.sh` |
| `post-mortem` | Diagnose the failed run through Mino's post-mortem path |

## Routing

| Task | Load |
|---|---|
| Start a post run | `CONTEXT.md`, then the current stage `CONTEXT.md` |
| Write the post | `persona/content-creator.md` at stage 02 |
| Publish | stage 03 contract and its declared inputs |
| Inspect routing | `tools/link-check.sh` |

## Hard Rules

- Never publish without a mechanically verified image URL, publishing
  parameters, and platform receipt.
- Never invent a platform ID, URL, verification result, or success claim.
- Keep internal image critique and metadata out of the published caption.
- Use the canonical HTTPS image URL declared by stage 02; never substitute a
  guessed or insecure URL.
- Stage outputs must be written through the sanctioned Mino tools so output
  provenance remains auditable.
- A failed or uncertain external mutation is not success; verify its receipt
  before any retry.
- The workspace does not authorize edits to Mino contracts, memory, or other
  playbooks.

## Source of Truth and Loading Boundary

`config.md` owns this playbook's runtime binding. The persona owns voice.
Stage `CONTEXT.md` files own process, inputs, audits, and outputs. `runs/`
contains run-specific evidence. Load only the files named by the current
stage's Inputs table; do not scan historical runs by default.

