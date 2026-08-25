# Malaysian Daily News

## Purpose
Every day, curate one fresh Malaysian news story from each of five categories—politics, sports, entertainment, disasters, and viral news—then publish a concise, source-linked roundup to the the Facebook Page and send the owner the complete roundup and run report in Telegram.

## Sources (mandatory — always use these three)
These are the owner's approved Malaysian news sources. Always fetch from these three:

1. **Bernama** — https://www.bernama.com (national news agency, official/government news)
2. **Malaysiakini** — https://www.malaysiakini.com (independent Malay-language news)
3. **Free Malaysia Today** — https://www.freemalaysiatoday.com (English-language, broad coverage)

Strategy: fetch from the relevant category pages on these sites. Alternate sources across days so coverage stays fresh. If a category has no story from one source, try the others.

## Routing
Run this playbook for the daily Malaysian news roundup. Use the previous completed stage outputs as the exclusion history. Do not reuse the same event, article, or materially unchanged development; choose a different eligible story when a candidate is already present in recent reports. If a category has no credible fresh story, state that clearly rather than inventing one.

## Schedule
Daily at 20:00 Asia/Kuala_Lumpur.