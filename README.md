# Kaizen

> **Small improvements, every day.**
>
> The compound interest of discipline.

`kaizen` is a terminal tool for recording daily micro-improvements. Deleted dead code? `kaizen done`. Renamed a confusing variable? `kaizen done`. Added a missing test? `kaizen done`.

No project management. No categories. No priorities. Just a timestamped record of getting better, one small thing at a time.

---

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Commands](#commands)
  - [`done` — Record an Improvement](#done--record-an-improvement)
  - [`undo` — Remove Last Entry](#undo--remove-last-entry)
  - [`today`](#today)
  - [`yesterday`](#yesterday)
  - [`week`](#week)
  - [`month`](#month)
  - [`log`](#log--custom-range)
  - [`streak`](#streak)
  - [`stats`](#stats)
- [Philosophy](#philosophy)
- [Database](#database)
- [Configuration & Data Location](#configuration--data-location)
- [Development](#development)
- [Related](#related)
- [License](#license)

---

## Features

| Feature | Description |
|---------|-------------|
| **One-Command Recording** | `kaizen done "what you did"` — nothing else required. |
| **Streak Tracking** | Consecutive days with at least one improvement. |
| **Daily / Weekly / Monthly Views** | See what you improved and when. |
| **Undo** | Remove the last entry if you made a mistake. |
| **All-Time Stats** | Total improvements, active days, daily average. |
| **Zero Dependencies** | Ruby stdlib only (`pstore`, `date`). |
| **Offline Only** | No cloud. No sync. No accounts. |

---

## Installation

```bash
gem install kaizen-log
```

### Requirements

- Ruby >= 3.0.0

No external gems required.

---

## Quick Start

```bash
# Record improvements throughout the day
kaizen done "Removed 3 unused imports"
kaizen done "Split 200-line function into two"
kaizen done "Added timeout to HTTP client"

# Review your day
kaizen today

# Check your streak
kaizen streak
```

Example output:

```text
$ kaizen done "Removed 3 unused imports"
Recorded #1: Removed 3 unused imports
First improvement today.

$ kaizen done "Added error handling to API call"
Recorded #2: Added error handling to API call
2 improvements today.

$ kaizen today
Today (2):
  [09:15] Removed 3 unused imports
  [14:30] Added error handling to API call
```

---

## Commands

### `done` — Record an Improvement

```bash
kaizen done "what you improved"
```

- Maximum **200 characters**.
- Timestamped with date and time.
- Shows today's count and current streak.

**Examples:**

```bash
kaizen done "Deleted dead CSS rules"
kaizen done "Renamed confusing variable"
kaizen done "Fixed N+1 query in dashboard"
kaizen done "Removed console.log from production code"
kaizen done "Added index to slow database query"
```

### `undo` — Remove Last Entry

```bash
kaizen undo
```

Removes the most recently recorded entry. Useful for typos or accidental entries.

### `today`

```bash
kaizen today
```

Shows all improvements recorded today.

### `yesterday`

```bash
kaizen yesterday
```

Shows all improvements recorded yesterday.

### `week`

```bash
kaizen week
```

Shows improvements from the last 7 days, grouped by date.

**Example output:**

```text
Last 7 days: 9 improvements
------------------------------------
  2026-04-24 (Thu) — 3
    [09:15] Removed unused imports
    [11:00] Added test for edge case
    [16:45] Simplified error handling
  2026-04-23 (Wed) — 2
    [10:30] Fixed typo in README
    [14:00] Removed dead code in utils
  2026-04-22 (Tue) — 4
    ...
```

### `month`

```bash
kaizen month
```

Shows improvements from the last 30 days.

### `log` — Custom Range

```bash
kaizen log [days]
```

- Default: **7 days**
- Shows improvements from the last N days.

```bash
kaizen log 90    # last 90 days
```

### `streak`

```bash
kaizen streak
```

Shows your current streak of consecutive days with at least one recorded improvement.

```text
Current streak: 12 days
```

### `stats`

```bash
kaizen stats
```

Shows all-time statistics.

```text
All time:
  Total improvements: 147
  Active days:        34
  Average per day:    4.3
  Current streak:     12 days
  Today:              3
```

---

## Philosophy

**Kaizen (改善)** is the Japanese concept of continuous improvement through small, incremental changes.

This tool does not track tasks, priorities, or deadlines. It tracks **what you already did**. The difference matters:

- A task list is about the future. Kaizen is about the present.
- A task list creates pressure. Kaizen creates evidence.
- A task list can grow without bound. Kaizen only records what actually happened.

The streak is not a gamification trick. It is a mirror. If it breaks, you know why.

---

## Database

Improvements are stored in a local PStore database. Each entry has the following structure:

| Field | Type | Description |
|-------|------|-------------|
| `id` | Integer | Auto-incrementing identifier |
| `text` | String | What you improved (max 200 chars) |
| `date` | String | ISO date (`YYYY-MM-DD`) |
| `time` | String | Local time (`HH:MM`) |

---

## Configuration & Data Location

| Platform | Path |
|----------|------|
| Linux / macOS | `~/.config/kaizen/improvements.db` |
| Windows | `%USERPROFILE%\.config\kaizen\improvements.db` |

The directory is created automatically on first run.

---

## Development

### Setup

```bash
git clone https://github.com/YumaKakuya/kaizen.git
cd kaizen
```

### Running Locally

```bash
ruby -Ilib bin/kaizen done "test improvement"
```

### Building the Gem

```bash
gem build kaizen-log.gemspec
```

---

## Related

- [zen-and-musashi](https://github.com/YumaKakuya/zenandmusashi) — Japanese wisdom for your terminal
- [ronin](https://github.com/YumaKakuya/ronin) — Focus timer for the solo developer
- [ichigo-ichie](https://github.com/YumaKakuya/ichigo-ichie) — One quote per day, every day different

---

## License

MIT License. See [LICENSE](LICENSE) for the full text.

---

> *A journey of a thousand miles is built from a single step repeated.*
