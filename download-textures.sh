#!/bin/bash
set -euo pipefail

# Download missing character textures for Cyberpunk Megapolis
# This script searches the app for referenced .webp/.png filenames,
# merges them with a curated list (including the extra names you provided),
# checks the remote servers (/chars/textures and site root) for availability,
# and downloads missing files into chars/textures with retries.

TEXTURE_DIR="chars/textures"
mkdir -p "$TEXTURE_DIR"

WEBP_URL="https://zrlxxdaz56kym.ok.kimi.link/chars/textures"
PNG_URL="https://zrlxxdaz56kym.ok.kimi.link"

# Curated list (original + the extra names you requested)
CURATED=(
  "girl.png"
  "man.png"
  "T_SurvGirl_Backpack01_BaseColor.webp"
  "T_SurvGirl_Backpack01_Normal.webp"
  "T_SURVGIRL_BODY_01_BaseColor.webp"
  "T_SurvGirl_Body_BaseColor_01.webp"
  "T_SurvGirl_Body_Normal.webp"
  "T_SurvGirl_Eyelashes.webp"
  "T_SurvGirl_Eyes_BaseColorBlue.webp"
  "T_SurvGirl_eyeshadow.webp"
  "T_SurvGirl_Eyes_Normal.webp"
  "T_SURVGIRL_HAIR_01_BaseColor.webp"
  "T_SurvGirl_Hair_AO.webp"
  "T_SurvGirl_Hair_basecolor.webp"
  "T_SurvGirl_Hair_normal.webp"
  "T_SurvGirl_Hat02_BaseColor.webp"
  "T_SURVGIRL_HEAD_01_BaseColor.webp"
  "T_SurvGirl_Head_BaseColor_01.webp"
  "T_SurvGirl_Head_Normal.webp"
  "T_SurvGirl_Pants04_BaseColor.webp"
  "T_SurvGirl_Pants04_Normal.webp"
  "T_SurvGirl_Shoes01_BaseColor.webp"
  "T_SurvGirl_Shoes01_Normal.webp"
  "T_SurvGirl_Teeth_BaseColor.webp"
  "T_SurvGirl_Teeth_Normal.webp"
  "T_SurvGirl_Tshirt01_BaseColor.webp"
  "T_SurvGirl_Tshirt01_Normal.webp"
  "T_SURVMAN_BODY_BaseColor_nodirt_01.webp"
  "T_SURVMAN_BODY_MetallicSmoothness.webp"
  "T_SURVMAN_BODY_Normal.webp"
  "T_SurvMan_Eyes_BaseColorBlue.webp"
  "T_SurvMan_Eyes_Normal.webp"
  "T_SURVMAN_Hair_AO.webp"
  "T_SURVMAN_Hair_BaseColor.webp"
  "T_SURVMAN_Hair_Normal.webp"
  "T_SURVMAN_HEAD_BaseColor_nodirt_01.webp"
  "T_SURVMAN_HEAD_MetallicSmoothness.webp"
  "T_SURVMAN_HEAD_Normal.webp"
  "T_SURVMAN_JACKET_03_BaseColor_01.webp"
  "T_SURVMAN_JACKET_03_MetallicSmoothness.webp"
  "T_SURVMAN_JACKET_03_Normal.webp"
  "T_SurvMan_Lashes_BaseColor_Alpha.webp"
  "T_SURVMAN_PANTS_01_BaseColor_02.webp"
  "T_SURVMAN_PANTS_01_MetallicSmoothness.webp"
  "T_SURVMAN_PANTS_01_Normal.webp"
  "T_SURVMAN_SHOES_02_BaseColor_01.webp"
  "T_SURVMAN_SHOES_02_MetallicSmoothness.webp"
  "T_SURVMAN_SHOES_02_Normal.webp"
  "T_SurvMan_Teeth_AO.webp"
  "T_SurvMan_Teeth_BaseColor.webp"
  "T_SURVMAN_Teeth_Normal.webp"
  "T_SURVMAN_VEST_02_BaseColor_01.webp"
  "T_SURVMAN_VEST_02_MetallicSmoothness.webp"
  "T_SURVMAN_VEST_02_Normal.webp"

  # keep previous set (core textures) to remain compatible
  "T_SurvGirl_Hair_AO.webp"
  "T_SurvGirl_Hair_basecolor.webp"
  "T_SurvGirl_Hair_normal.webp"
  "T_SurvGirl_Hat02_BaseColor.webp"
  "T_SurvGirl_Hat02_MetallicSmoothness.png"
  "T_SurvGirl_Backpack01_BaseColor.webp"
  "T_SurvGirl_Backpack01_Normal.webp"
  "T_SurvGirl_Backpack01_MetallicSmoothness.png"
  "T_SurvGirl_Tshirt01_BaseColor.webp"
  "T_SurvGirl_Tshirt01_Normal.webp"
  "T_SurvGirl_Tshirt01_MetallicSmoothness.png"
  "T_SurvGirl_Pants04_BaseColor.webp"
  "T_SurvGirl_Pants04_MetallicSmoothness.png"
  "T_SurvGirl_Shoes01_BaseColor.webp"
  "T_SurvGirl_Pants04_Normal.webp"
  "T_SurvGirl_Shoes01_Normal.webp"
  "T_SurvGirl_Shoes01_MetallicSmoothness.png"
  "T_SurvGirl_eyeshadow.webp"
  "T_SurvGirl_Eyes_BaseColorBlue.webp"
  "T_SurvGirl_Eyes_Normal.webp"
  "T_SurvGirl_Head_BaseColor_01.webp"
  "T_SurvGirl_Head_Normal.webp"
  "T_SurvGirl_Head_MetallicSmoothness.png"
  "T_SurvGirl_Eyelashes.webp"
  "T_SurvGirl_Teeth_BaseColor.webp"
  "T_SurvGirl_Teeth_Normal.webp"
  "T_SurvGirl_Body_BaseColor_01.webp"
  "T_SurvGirl_Body_Normal.webp"
  "T_SurvGirl_Body_Dirt_MetallicSmoothness.png"
  "T_SurvMan_Hair_AO.webp"
  "T_SurvMan_Hair_basecolor.webp"
  "T_SurvMan_Hair_normal.webp"
  "T_SurvMan_Hat_BaseColor.webp"
  "T_SurvMan_Hat_Normal.webp"
  "T_SurvMan_Hat_MetallicSmoothness.png"
  "T_SurvMan_Jacket_BaseColor.webp"
  "T_SurvMan_Jacket_Normal.webp"
  "T_SurvMan_Jacket_MetallicSmoothness.png"
  "T_SurvMan_Pants_BaseColor.webp"
  "T_SurvMan_Pants_Normal.webp"
  "T_SurvMan_Pants_MetallicSmoothness.png"
  "T_SurvMan_Shoes_BaseColor.webp"
  "T_SurvMan_Shoes_Normal.webp"
  "T_SurvMan_Shoes_MetallicSmoothness.png"
  "T_SurvMan_Head_BaseColor_01.webp"
  "T_SurvMan_Head_Normal.webp"
  "T_SurvMan_Head_MetallicSmoothness.png"
  "T_SurvMan_Eyes_BaseColorBrown.webp"
  "T_SurvMan_Eyes_Normal.webp"
  "T_SurvMan_Body_BaseColor_01.webp"
  "T_SurvMan_Body_Normal.webp"
  "T_SurvMan_Body_Dirt_MetallicSmoothness.png"
  "T_SurvMan_Teeth_BaseColor.webp"
  "T_SurvMan_Teeth_Normal.webp"
  "T_SurvMan_eyeshadow.webp"
)

USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
FAILED=0
SUCCESS=0
MAX_RETRIES=3
RETRY_DELAY=2

# Helper: add to associative set
declare -A need_set

# Add curated names
for f in "${CURATED[@]}"; do
  need_set["$f"]=1
done

# Scan the app for referenced .png/.webp filenames and add them
# Exclude large/vendor directories to avoid noise
EXCLUDES=(".git" "${TEXTURE_DIR#./}" "node_modules" "dist" "build" "out" "vendor")
exclude_args=()
for e in "${EXCLUDES[@]}"; do
  exclude_args+=(--exclude-dir="$e")
done

# Find candidate filenames (liberal regex), then basename and add
# Use grep with PCRE if available, fallback to basic ERE
if command -v grep >/dev/null 2>&1; then
  mapfile -t found_files < <(grep -rhoI --exclude-dir={.git,"$TEXTURE_DIR",node_modules,dist,build,out,vendor} -E "[A-Za-z0-9_\-/.]+\.(png|webp)" . 2>/dev/null || true)
else
  found_files=()
fi

for ff in "${found_files[@]:-}"; do
  base=$(basename "$ff")
  # ignore URLs (http) and data URIs
  if [[ $base == http* ]] || [[ $base == data:* ]]; then
    continue
  fi
  need_set["$base"]=1
done

# Build final list
TEXTURES=()
for k in "${!need_set[@]}"; do
  TEXTURES+=("$k")
done

# Sort for stable output
IFS=$'\n' TEXTURES=( $(printf "%s\n" "${TEXTURES[@]}" | sort -u) )
unset IFS

# Summary
echo "Will check ${#TEXTURES[@]} candidate texture(s)."
echo "Textures will be saved to: $TEXTURE_DIR"
echo "WebP source: $WEBP_URL"
echo "PNG source: $PNG_URL"

echo "\nAttempting to parse remote directory listings to find available files..."
remote_files=()

fetch_and_parse() {
  local url="$1"
  local html
  if ! html=$(curl -sS -A "$USER_AGENT" --connect-timeout 5 --max-time 15 "$url/" 2>/dev/null); then
    return 1
  fi
  # extract href values
  while IFS= read -r href; do
    [ -z "$href" ] && continue
    file=$(basename "$href")
    if [[ $file =~ \.(webp|png)$ ]]; then
      remote_files+=("$file")
    fi
  done < <(printf "%s\n" "$html" | grep -oiE 'href="[^"]+"' | sed -E 's/href="([^\"]+)"/\1/' || true)
  return 0
}

fetch_and_parse "$WEBP_URL" || true
fetch_and_parse "$PNG_URL" || true

# dedupe
if [ ${#remote_files[@]} -gt 0 ]; then
  IFS=$'\n' read -r -d '' -a remote_files < <(printf "%s\n" "${remote_files[@]}" | sort -u && printf '\0')
  echo "Found ${#remote_files[@]} file(s) from remote directory listings."
else
  echo "No usable directory listing parsed from remote; will fall back to per-file HEAD checks."
fi

# Download loop
for texture in "${TEXTURES[@]}"; do
  printf "%-60s " "$texture"

  # Skip if already present
  if [ -f "$TEXTURE_DIR/$texture" ]; then
    echo "already present"
    continue
  fi

  # Determine candidate URLs (prefer WEBP_URL for .webp files, otherwise site root)
  if [[ $texture == *.webp ]]; then
    candidate_url="$WEBP_URL/$texture"
    alt_url="$PNG_URL/$texture"
  else
    candidate_url="$PNG_URL/$texture"
    alt_url="$WEBP_URL/$texture"
  fi

  available=0
  # If we have remote listing, check there first
  if [ ${#remote_files[@]} -gt 0 ]; then
    if printf "%s\n" "${remote_files[@]}" | grep -xq -- "$texture"; then
      available=1
      # determine which base matches
      if [[ $texture == *.webp ]]; then
        candidate_url="$WEBP_URL/$texture"
      else
        # could be on site root too
        candidate_url="$PNG_URL/$texture"
      fi
    else
      # not in listing
      available=0
    fi
  else
    # No listing: try HEAD on candidate, then alt
    if curl -I -sS -A "$USER_AGENT" --connect-timeout 5 --max-time 10 "$candidate_url" 2>/dev/null | head -n 1 | grep -qE 'HTTP/.* (200|206)'; then
      available=1
    elif curl -I -sS -A "$USER_AGENT" --connect-timeout 5 --max-time 10 "$alt_url" 2>/dev/null | head -n 1 | grep -qE 'HTTP/.* (200|206)'; then
      candidate_url="$alt_url"
      available=1
    fi
  fi

  if [ $available -eq 0 ]; then
    echo "NOT FOUND"
    ((FAILED++))
    continue
  fi

  # Download with retries
  retry=0
  success=0
  while [ $retry -lt $MAX_RETRIES ]; do
    if curl -f -s -A "$USER_AGENT" --connect-timeout 5 --max-time 30 -o "$TEXTURE_DIR/$texture" "$candidate_url"; then
      echo "OK"
      ((SUCCESS++))
      success=1
      break
    fi
    ((retry++))
    if [ $retry -lt $MAX_RETRIES ]; then
      printf "[retry %d/%d] " "$retry" "$MAX_RETRIES"
      sleep $RETRY_DELAY
    fi
  done

  if [ $success -eq 0 ]; then
    echo "FAILED"
    ((FAILED++))
  fi

done

# Final report

echo "\nDownload complete. Success: $SUCCESS | Failed: $FAILED"
if [ $FAILED -gt 0 ]; then
  echo "\nTroubleshooting:"
  echo "- Check if the asset servers are online"
  echo "- WebP directory: curl -I $WEBP_URL/"
  echo "- Site root: curl -I $PNG_URL/"
  echo "- Verify network connectivity"
  echo "- Check available disk space in $TEXTURE_DIR"
fi
