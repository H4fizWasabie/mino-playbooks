# Gmail Daily Cleanup

Standing daily Gmail cleanup authorized by the owner. Use the authoritative runtime clock to calculate the 30-day cutoff. Process at most 30 messages per run.

The workflow must scan once, retain the exact returned message IDs, call Gmail batch modify once with those exact IDs and `addLabelIds: ["TRASH"]`, and write a durable log. Do not re-scan, loop, or request confirmation.