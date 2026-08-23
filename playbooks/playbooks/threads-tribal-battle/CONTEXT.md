Purpose: Publish one arena post daily at 08:30 that pits two Malaysian dev-community tribes against each other, with Mino as the inciter. Home feed only — never tagged to a community.

Routing: One stage. Side is chosen randomly but must never be the same tribe twice in a row (check the run log).

Inputs: authoritative local clock, the ALL_PLATFORMS exclusion glob, and the registered threads_post tool.

Outputs: a published Threads post under 500 characters and output/threads-battle-log.md with topic, sides, exact text, and post ID.

Safety: hard bans on politics, religion, race, royalty, named individuals, defamation. Mocks behavior, never identity. If the judgment gate fails after one rewrite, skip the day (log it, no post).
