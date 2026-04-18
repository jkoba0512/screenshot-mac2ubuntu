# screenshot-mac2ubuntu

A `/shot` skill for Claude Code, Gemini CLI, and Codex that analyzes the latest screenshot.

Works on **macOS and Ubuntu**.

## Overview

- **Mac**: Take a screenshot → `/shot` analyzes it directly
- **Ubuntu**: Screenshots synced from Mac → `/shot` analyzes the latest one

## Prerequisites

Screenshots must be saved to `~/Screenshots`.

### Mac — verify and configure the save location

Press `Command + Shift + 5` → click **Options** in the toolbar → check **Save to**.

If it is not set to `~/Screenshots`, change it there.

> Note: `defaults read com.apple.screencapture location` may return empty even when
> configured via the GUI on newer macOS. Trust the GUI value.

### Ubuntu — sync from Mac

See [docs/mac-sync-setup.md](docs/mac-sync-setup.md) for sync configuration (SynologyDrive, rsync, Syncthing, etc.).

## Quick Start

```bash
git clone https://github.com/jkoba0512/screenshot-mac2ubuntu.git
cd screenshot-mac2ubuntu
bash install.sh
```

The installer detects which CLI tools are installed and sets up symlinks automatically.
Any `git pull` in this repository immediately updates the skill for all CLIs.

## Usage

```
/shot
/shot explain this error
/shot summarize this page
/shot extract the code
/shot what should I click next?
```

### Gemini CLI note

`/shot` works in **interactive mode**. Launch `gemini` from your home directory and type `/shot`.
The `-p` (headless) mode has tool restrictions that prevent shell execution and file access outside the workspace.

## Supported CLIs

| CLI | Install method |
|-----|---------------|
| Claude Code | Symlink `~/.claude/skills/shot` → this repo |
| Gemini CLI | `gemini skills link` |
| Codex | Symlink `~/.codex/skills/shot` → this repo |

## Update

```bash
cd ~/path/to/screenshot-mac2ubuntu
git pull
```

Changes are reflected immediately in all CLIs via symlinks.

## Uninstall

```bash
bash uninstall.sh
```

## Repository Structure

```
screenshot-mac2ubuntu/
├── SKILL.md          ← Skill definition (shared by all CLIs)
├── install.sh        ← Installer
├── uninstall.sh      ← Uninstaller
├── docs/
│   └── mac-sync-setup.md  ← Mac sync configuration guide
└── .gitignore
```
