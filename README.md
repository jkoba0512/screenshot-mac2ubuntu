# screenshot-mac2ubuntu

A `/shot` skill for Claude Code, Gemini CLI, and Codex that analyzes the latest screenshot synced from Mac to Ubuntu.

## Overview

1. Take a screenshot on Mac → automatically synced to `~/Screenshots` on Ubuntu
2. Run `/shot` in any supported CLI → the AI analyzes the screenshot

## Prerequisites

- Screenshots are synced from Mac to `~/Screenshots` on Ubuntu
- See [docs/mac-sync-setup.md](docs/mac-sync-setup.md) for sync configuration

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
