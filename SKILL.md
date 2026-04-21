---
name: shot
description: Analyze the newest screenshot synced from Mac into ~/Screenshots.
---

Use this skill when the user wants to analyze, inspect, summarize, or extract information from the latest screenshot synced from Mac to Ubuntu.

Screenshots are synced into one of these directories:
- ~/Screenshots
- ~/スクリーンショット

When invoked:

1. Find the newest image file using this command:

   LATEST=$(find ~/Screenshots ~/スクリーンショット -maxdepth 1 -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" \) -print0 2>/dev/null | xargs -0 ls -t 2>/dev/null | head -n 1); [ -f "$LATEST" ] && echo "$LATEST"

2. If the command returns no output, tell the user:
   "No synced screenshot was found in ~/Screenshots or ~/スクリーンショット."

3. If an image exists but its file size is 0 bytes, warn the user that the file may be incomplete (sync in progress).

4. If an image exists, use that image as the primary input for analysis.

5. If the user included extra instructions after /shot, follow them.
   Examples:
   - explain the error
   - summarize this page
   - extract the code
   - read the text in the screenshot
   - tell me what to click next

In your response, mention the file path you used before giving the analysis.
