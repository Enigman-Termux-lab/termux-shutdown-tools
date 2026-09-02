---
name: termux-shutdown-tools
description: Safely terminate Termux processes, prevent battery drain from orphan background processes, and manage Android CPU wakelock.
---

# Termux Shutdown Tools Skill

Use this skill when managing the Termux process lifecycle, stopping background servers (MCP bridges, daemons), and closing the Termux environment completely.

## Key Rules

1. **Orphan Process Hazard:** When Termux:Widget scripts run, they are adopted by init (PPID=1). Clicking "Exit" in the notification bar DOES NOT terminate them.
2. **Two-phase Termination:**
   - Step 1: `pkill -TERM -u $(id -u)` (graceful exit, allow flush).
   - Step 2: `kill -9` remaining processes.
   - Step 3: `am force-stop com.termux` (full Android application unload).
3. **Wakelock Management:** Use `termux-wake-lock` only during active background jobs; release it via `termux-wake-unlock` when idle to save battery.
