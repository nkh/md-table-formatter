---
name: md-table-formatter
description: Install and use the `md-table-formatter` Perl tool to align and width-check Markdown tables. Use this skill whenever the task involves formatting, aligning, or column-padding Markdown pipe tables, checking that table rows fit a width limit (e.g. for a 185-column terminal or a CI gate), converting TSV to Markdown tables, or fixing tables that overflow. Also use it when generating or editing documents that contain Markdown tables and you want them tidy and width-safe before delivery. Trigger on phrases like "format this table", "align the columns", "table is too wide", "check table width", "make the tables fit", or any time you are about to hand-write a wide Markdown table by hand instead of letting the tool align it.
---

# md-table-formatter

A single-file Perl tool (`md-table-formatter` by nkh) that takes messy Markdown pipe tables and re-aligns their columns, and — just as importantly — tells you when a row is too wide to fit. This skill installs the tool and explains how to use it so the AI produces tables that are both tidy and guaranteed to fit a width limit.

## Why use a tool instead of aligning by hand

Hand-aligning Markdown tables is error-prone: column widths drift, padding is inconsistent, and there is no feedback when a row silently exceeds the terminal or viewer width. The tool does the alignment deterministically and, with `--check-width`, reports every offending row by line number so it can be fixed. Formatting and width-checking are separate concerns that the tool handles in one pass.

## Install

Run the bundled installer. It clones the repo, makes the script executable, symlinks it onto your PATH, and verifies it runs.

```bash
bash scripts/install.sh
```

Optional args: `bash scripts/install.sh [clone_dir] [bindir]`. Defaults: clone to `~/.local/share/md-table-formatter`, link to `~/.local/bin`.

**Requirements:** `git` and `perl` (any 5.8+). The script has no external CPAN dependencies — `strict`, `warnings`, `utf8`, and `List::Util` are all Perl core modules, so no `cpan install` step is needed.

Verify after install:

```bash
md-table-formatter --help
```

If `command not found`, the bindir is not on your PATH. Either add it (`export PATH="$HOME/.local/bin:$PATH"`) or call the script by its full path.

## The core workflow (format → check → fix)

This is the proper way to use the tool. Two principles make it work: **always pass a row-width limit**, and **verify with `--check-width`** afterward. Without a width limit the tool happily aligns a table that is far too wide to read; without `--check-width` you get no signal that anything is wrong.

### 1. Format the file in place

The tool reads a file (or stdin) and writes the formatted result to **stdout**. It does not edit files in place, so redirect to a temp file and move it back. Never redirect straight onto the source (`> file.md`) — that truncates the file before it is read.

```bash
md-table-formatter --max-row-width 185 doc.md > doc.md.tmp && mv doc.md.tmp doc.md
```

`--max-row-width 185` is the recommended limit (matches a 185-column terminal and the project's vim integration). Use a smaller value if the target is narrower.

### 2. Check that every row fits

```bash
md-table-formatter --max-row-width 185 --check-width doc.md > /dev/null
```

`--check-width` sends any overflowing row to stderr as JSON and sets a non-zero exit code:

```json
{"line": 104, "column_widths": [7, 5, 47, 30, 43, 34], "cells_widths": [11, 5, 47, 30, 43, 34]}
```

- Exit code `0` → every row fits. Done.
- Non-zero → at least one row is too wide. Read the flagged line numbers and fix them (see step 3).

### 3. Fix overflowing rows, then re-check

The tool aligns columns; **it does not reflow or wrap cell text.** When a row is too wide, you must edit the content yourself. The JSON `column_widths` vs `cells_widths` tells you which column(s) overflow. Effective fixes, in order of preference:

- **Merge two columns** into one when they carry the same idea (e.g. `Requirement` + `What it is for` → `Requirement — what it is for`).
- **Shorten the prose** in the wide cells: drop filler words, use `;` instead of a full sentence, abbreviate repeated terms.
- **Drop a column** that is not load-bearing.
- **Split one wide table into two** narrower tables under separate headings.

Then re-run step 1 (re-format) and step 2 (re-check) until exit is `0`.

### Quick reference: the three relevant flags

| Flag | What it does |
|---|---|
| `--max-row-width N` (alias `-r`) | Sets the row-width limit. Rows exceeding N get `@` prepended in the output. Without this flag there is no width checking at all. |
| `--check-width` (alias `-c`) | Pairs with `--max-row-width`. Writes offending rows to stderr as JSON and exits non-zero on overflow — the CI/verify mode. |
| `--style N` (alias `-s`) | Output style. `0` = pure Markdown (default; use for `.md` files). `2` = ASCII, `3`/`4` = box-drawing — for terminal display only. |

So: format with `--max-row-width`, verify with `--max-row-width --check-width`. The two flags are always used together for checking; the `@`-prepend behavior of `--max-row-width` alone is only a visual hint and exits `0` even when rows overflow — do not rely on it as a gate.

## Other operations

**Pipe instead of file** — useful for a quick check or for embedding in a pipeline:

```bash
cat table.md | md-table-formatter --max-row-width 185
```

**Convert TSV to a Markdown table** — handy when pasting spreadsheet output:

```bash
md-table-formatter --from-TSV data.tsv > data.md
# add --TSV-no-header if the first row is data, not a header
```

**Format one table among other text** — the tool passes non-table lines through unchanged, so it is safe to run on a whole document that mixes prose and several tables. It aligns each table independently.

## Vim integration (for the user)

If the user edits Markdown in vim, the upstream README suggests:

```vim
nnoremap <Leader>at vip:!md-table-formatter --max-row-width 185<CR>
xnoremap <Leader>at :!md-table-formatter --max-row-width 185<CR>
```

## Common mistakes to avoid

- **Forgetting `--max-row-width`.** Without it the tool aligns but never warns, so a 250-column table ships unnoticed. Always pass it.
- **Trusting the `@` marker as a pass/fail signal.** `--max-row-width` alone prepends `@` and exits `0`. Only `--check-width` gives a non-zero exit code. Use both.
- **Overwriting the source in place.** `md-table-formatter file.md > file.md` empties the file. Always go through a temp file.
- **Expecting the tool to wrap long cells.** It will not shorten your text — that is your job. Re-run the check after editing.
- **Using a non-Markdown style for committed docs.** Styles 1–5 produce box-drawing/ASCII art that is not valid Markdown. Keep `--style 0` (the default) for `.md` files.
- **Running it on the user's live tmux server or production files without a backup.** It only touches the file you name (via stdout), but keep a copy when integrating into a larger edit.

## Script

- `scripts/install.sh` — idempotent installer (clone or update, chmod, symlink, verify). Run it once per environment.
