# Weekly Cost — Sunday spend + output report

*ICM Layer 0 — workspace identity and map. See CONTEXT.md for routing.*

One Sunday report of the week's actual spend and output: tokens and estimated cost per model, posts published per platform, runs skipped and why. Day-gated: runs only on Sunday (authoritative local date); on other days write the skip log and end without Telegram.

Operated by the `reality-checker` persona (workspace-owned; see `persona/CONTEXT.md`). Mino's outer rails — SOUL.md, the runtime MAP.md, memory, audit, cancellation, retries, output verification, and tool policy — are owned by the harness and always take precedence over this workspace's own contracts.

## Folder Map

```
weekly-cost/
├── AGENTS.md            (you are here — workspace identity and map)
├── CONTEXT.md            (routing, failure protocol, stage handoffs)
├── config.md             (runner: description, status, agent)
├── persona/              (persona pointer → agency roster; see Routing)
├── stages/
│   ├── 01-mechanical/    (script: compute spend/output/issues from state.db usage_log → output/raw-cost.md)
│   └── 02-synthesize/    (compose Telegram report from raw numbers → output/weekly-cost.md)
├── tools/link-check.sh   (routing health: links + orphans)
└── runs/                 (Mino-owned run state — never hand-edit state.json)
```

Read CONTEXT.md next for routing, the failure protocol, and stage handoffs.
