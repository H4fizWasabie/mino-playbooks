# Post-mortem — Diagnose Mino's Own Failure From Its Own Trace

Diagnose the most recent failed run using the harness `post_mortem` tool (which extracts the trace evidence) — do NOT re-scan with bash. The harness does the legwork; you render the ticket from the returned evidence.

## Process

1. Call the `post_mortem` tool (omit `playbook` for the most recent failed run, or pass a name). It returns the failure evidence: parse-failures with iteration numbers, outcome contradictions, stage-rewrite streaks, iteration usage, final reply.

2. If it returns "no failed run found", say so and stop — do not invent a failure.

3. Write `output/postmortem-<run-id>.md` in wayfinder ticket format, citing the returned evidence:
   - **Symptom:** what failed
   - **Trace evidence:** the iteration numbers / signals the tool returned
   - **Root cause / Hypothesis:** label it — cite the evidence, or say "hypothesis" if unconfirmed
   - **Fix:** harness-level change so it doesn't recur

4. Verify-then-claim: only claim "diagnosed" once the ticket file exists with cited evidence.

5. Report to the owner via Telegram (one line via `send_message`, exactly once): the run, symptom, root cause/hypothesis, and fix.

## Grounding (non-negotiable)

- Rely on the `post_mortem` tool's returned evidence — never re-scan with bash (that churns to the cap).
- A mechanism claim with no cited evidence is a HYPOTHESIS. "No evidence found" is a valid finding.
- Never invent a mechanism, count, timestamp, or tool call.

## Outputs
| Artifact | Path |
| --- | --- |
| postmortem ticket | output/postmortem.md |

The ticket filename is LITERAL: `output/postmortem.md` (the run directory already identifies the run — never embed `<run-id>` in the declared path; the output validator checks the literal name and a placeholder ticket is a contract defect, 2026-08-29). Inside the ticket, name the diagnosed run ID in the header. If a ticket for the diagnosed run is desired under the diagnosed run's ID, write it as a SECOND file alongside the declared one — the declared output must always be the real, complete ticket.

## Recovery Protocol (fix-or-adapt)

A skip-reason output is a successful outcome; ending without the declared outputs is the only true failure. On trouble, recover in-contract instead of reporting failure bare:

- No failed runs found → write the ticket stating that; it is a valid outcome.
- Harness tool returns thin evidence → render the ticket from exactly what was returned; never re-scan traces with bash.
- Escalate to the owner only what genuinely blocked the run, with evidence and the recovery already attempted. The Telegram report (when declared) is never dropped — EXACTLY ONCE per run.
