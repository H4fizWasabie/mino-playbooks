# Persona

This playbook owns its persona locally. `persona/instagram-curator.md` is the workspace's
authoritative voice (PSN-002: workspace personas are authoritative; the shared
roster at `~/.mino/agents/instagram-curator.md` is a migration fallback for legacy
playbooks only — it is no longer live-synced to this file).

## Contents

| File | Contains | Load when |
|---|---|---|
| `persona/instagram-curator.md` | `agent: instagram-curator` from `config.md` — stance, mission, lens, voice | Executing any stage of this playbook |

To tune this workspace's voice, edit `persona/instagram-curator.md` directly. Do not
load the persona for harness mechanics (run state, output paths, verification).
