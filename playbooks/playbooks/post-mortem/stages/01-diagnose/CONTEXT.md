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
| postmortem ticket | output/postmortem-<run-id>.md |
