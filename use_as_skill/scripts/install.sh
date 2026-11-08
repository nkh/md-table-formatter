#!/usr/bin/env bash
# install.sh — install md-table-formatter (single self-contained Perl script)
# Usage: ./install.sh [clone_dir] [bindir]
# Defaults: clone to ~/.local/share/md-table-formatter, symlink to ~/.local/bin
set -euo pipefail

REPO="https://github.com/nkh/md-table-formatter.git"
CLONE_DIR="${1:-$HOME/.local/share/md-table-formatter}"
BIN_DIR="${2:-$HOME/.local/bin}"
SCRIPT_NAME="md-table-formatter"

command -v git  >/dev/null 2>&1 || { echo "ERROR: git not found" >&2; exit 1; }
command -v perl >/dev/null 2>&1 || { echo "ERROR: perl not found" >&2; exit 1; }

# Clone (or update if already present)
if [ -d "$CLONE_DIR/.git" ]; then
  echo "Updating existing clone at $CLONE_DIR"
  git -C "$CLONE_DIR" pull --ff-only
else
  echo "Cloning into $CLONE_DIR"
  mkdir -p "$(dirname "$CLONE_DIR")"
  git clone --depth 1 "$REPO" "$CLONE_DIR"
fi

SRC="$CLONE_DIR/$SCRIPT_NAME"
[ -f "$SRC" ] || { echo "ERROR: $SCRIPT_NAME not found in clone" >&2; exit 1; }
chmod +x "$SRC"

# Symlink onto PATH
mkdir -p "$BIN_DIR"
LINK="$BIN_DIR/$SCRIPT_NAME"
if [ -L "$LINK" ] || [ -e "$LINK" ]; then
  echo "Removing existing link at $LINK"
  rm -f "$LINK"
fi
ln -s "$SRC" "$LINK"
echo "Linked $LINK -> $SRC"

# Verify it runs (deps are Perl core only: strict, warnings, utf8, List::Util)
if "$LINK" --help >/dev/null 2>&1; then
  echo "OK: $SCRIPT_NAME runs."
else
  echo "ERROR: $SCRIPT_NAME did not run. Check perl is installed." >&2
  exit 1
fi

# Warn if bindir is not on PATH
case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *) echo "NOTE: $BIN_DIR is not on your PATH. Add it:  export PATH=\"$BIN_DIR:\$PATH\"" ;;
esac

echo ""
echo "Done. Run:  md-table-formatter --help"
echo "Resolved: $(command -v "$SCRIPT_NAME" 2>/dev/null || echo "$LINK (not on PATH)")"
