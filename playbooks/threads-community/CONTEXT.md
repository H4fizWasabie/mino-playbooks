Purpose: Publish one safe-reach post daily at 11:00 tagged into the @AiThreads community (1M members). Rotates: even days = fresh funny observation about Malaysian dev life; odd days = trending GitHub repo spotlight. Never the same joke, repo, or idea twice.

Routing: Day-of-year parity selects the content type. One stage.

Inputs: authoritative local clock, the ALL_PLATFORMS exclusion glob, the repo dedup file, and the registered threads_post tool.

Outputs: a published Threads post under 500 characters tagged @AiThreads, and output/threads-community-log.md with type, topic, exact text, and post ID.

Safety: no politics, religion, race, royalty, named individuals. Funny posts must be fresh observations, never recycled jokes. Repo posts must link the real repository and never repeat a repo. If the judgment gate fails after one rewrite, skip the day (log it, no post).
