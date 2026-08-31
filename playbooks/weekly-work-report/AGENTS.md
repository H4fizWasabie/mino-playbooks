# Weekly Work Report — workspace navigation

*ICM Layer 0 — workspace identity and map. See CONTEXT.md for routing.*

One paragraph purpose: this playbook produces the owner's weekly procurement report to his superior at Starlight Veterinary Medical Centre. Work items are collected as they arrive via Telegram (stage 01), synthesized into a draft every Monday 08:00 +08 covering the PREVIOUS week (stage 02), and rendered to a letterhead DOCX and sent after the owner's review (stage 03). The report is backdated: the Monday run covers Mon–Sun of the week that just ended.

Operated by the `procurement-officer` persona (workspace-owned; see `persona/CONTEXT.md`). Mino's outer rails — SOUL.md, the runtime MAP.md, memory, audit, cancellation, retries, output verification, and tool policy — are owned by the harness and always take precedence over this workspace's own contracts.

## Folder Map

- `AGENTS.md` — this file, workspace identity and map (you are here)
- `CONTEXT.md` — routing, failure protocol, stage handoffs
- `config.md` — schedule, delivery, agent, report parameters
- `persona/procurement-officer.md` — this workspace's own persona (workspace-owned, per PSN-002)
- `persona/CONTEXT.md` — one-line pointer to the file above
- `collect/README.md` — how items are appended to the inbox; `collect/week-items.md` — the owner's inbox, the current week's raw log; `collect/archive/` — week-items-<date>.md after each render
- `stages/01-collect/` — logging contract: `stages/01-collect/CONTEXT.md` + `stages/01-collect/CONTRACT.md`
- `stages/02-synthesize/` — draft contract: `stages/02-synthesize/CONTEXT.md` + `stages/02-synthesize/CONTRACT.md`
- `stages/03-render/` — mechanical stage: `stages/03-render/CONTEXT.md` + `stages/03-render/CONTRACT.md`, draft → letterhead DOCX → Telegram
- `tools/link-check.sh` — ICM routing health check, must print "Routing health OK"
- `output/` — declared outputs: drafts, final DOCX, logs; `runs/<run-id>/` — per-run state, never hand-edit; letterhead template used by stage 03: `/home/mino/.mino/playbooks/weekly-work-report/assets/letterhead-template.docx`

Read CONTEXT.md next for routing, the failure protocol, and stage handoffs.
