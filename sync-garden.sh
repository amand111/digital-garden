#!/usr/bin/env bash
set -euo pipefail

VAULT_DIR="/Users/aman/Documents/Obsidian Vault"
QUARTZ_DIR="/Users/aman/projects/quartz"
CONTENT_DIR="$QUARTZ_DIR/content"

# Clean content/ but preserve index.md
find "$CONTENT_DIR" -mindepth 1 ! -name 'index.md' -delete 2>/dev/null || true

# Find all markdown files with publish: true in frontmatter
while IFS= read -r -d '' file; do
  # Check if file has publish: true in YAML frontmatter
  if awk '
    BEGIN { in_fm=0; found=0 }
    NR==1 && /^---$/ { in_fm=1; next }
    in_fm && /^---$/ { exit !found }
    in_fm && /^publish:[[:space:]]*true/ { found=1 }
    END { exit !found }
  ' "$file"; then
    # Get relative path from vault
    rel_path="${file#"$VAULT_DIR"/}"
    dest="$CONTENT_DIR/$rel_path"
    mkdir -p "$(dirname "$dest")"
    cp "$file" "$dest"

    # Copy referenced attachments
    while IFS= read -r attachment; do
      att_src="$VAULT_DIR/$attachment"
      if [[ -f "$att_src" ]]; then
        att_dest="$CONTENT_DIR/$attachment"
        mkdir -p "$(dirname "$att_dest")"
        cp "$att_src" "$att_dest"
      fi
    done < <(sed -n 's/.*!\[\[\([^]]*\)\]\].*/\1/p' "$file" | while read -r name; do
      att_file=$(find "$VAULT_DIR/Attachments" -name "$name" 2>/dev/null | head -1)
      if [[ -n "$att_file" ]]; then
        echo "Attachments/${att_file#"$VAULT_DIR"/Attachments/}"
      fi
    done)
  fi
done < <(find "$VAULT_DIR" -name '*.md' -not -path '*/.obsidian/*' -not -path '*/node_modules/*' -print0)

# Commit and push
cd "$QUARTZ_DIR"
git add -A
if git diff --cached --quiet; then
  echo "No changes to publish."
else
  git commit -m "sync: update digital garden content"
  git push
  echo "Published successfully!"
fi
