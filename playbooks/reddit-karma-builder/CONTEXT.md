Purpose: Daily Reddit karma builder for u/your-handle. Uses Composio Reddit tools (active connection; account alias: `owner-account`) to find trending posts in AI/tech and developer/builder subreddits and post genuinely helpful comments. Goal: organic karma growth following each subreddit's rules.

Routing: Run daily at 10:00 +08:00. Discover fresh posts, draft helpful comments, post them, log results.

Inputs: Composio Reddit tools (active connection; account alias: `owner-account`), target subreddits: r/ChatGPT, r/AI_Agents, r/LocalLLaMA, r/artificial, r/LocalLLM, r/LLM, r/singularity, r/SideProject, r/buildinpublic, r/microsaas, r/SaaS, r/vibecoding, r/LocalGPT, r/Solopreneur, r/MachineLearning, r/indiehackers.

Dedup file: /home/mino/.mino/data/reddit-karma/commented-posts.md — contains Reddit post URLs already commented on. Both stages must respect this file.

Outputs: Posted comments and a log file at output/karma-log.md containing the date, posts commented on, comment text, and post IDs.

Safety: Max 3 comments per run to avoid spam. No self-promo, no links. Follow each subreddit's rules. If Reddit API fails, do not retry; report the error.