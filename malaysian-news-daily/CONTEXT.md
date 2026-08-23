# Malaysian Daily News

## Purpose
Every day, curate one fresh Malaysian news story from each of five categories—politics, sports, entertainment, disasters, and viral news—then publish a concise, source-linked roundup to the the Facebook Page and send the owner the complete roundup and run report in Telegram.

## Routing
Run this playbook for the daily Malaysian news roundup. Use the previous completed stage outputs as the exclusion history. Do not reuse the same event, article, or materially unchanged development; choose a different eligible story when a candidate is already present in recent reports. If a category has no credible fresh story, state that clearly rather than inventing one.

## Schedule
Daily at 20:00 Asia/Kuala_Lumpur.