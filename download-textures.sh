#!/bin/bash
# Download missing character textures for Cyberpunk Megapolis
# This script fetches .webp and .png textures for the character models

TEXTURE_DIR="chars/textures"
mkdir -p "$TEXTURE_DIR"

WEBP_URL="https://zrlxxdaz56kym.ok.kimi.link/chars/textures"
PNG_URL="https://zrlxxdaz56kym.ok.kimi.link"

TEXTURES=(
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

echo "Downloading character textures to $TEXTURE_DIR..."
echo "WebP source: $WEBP_URL"
echo "PNG source: $PNG_URL"
echo ""

FAILED=0
SUCCESS=0
MAX_RETRIES=3
RETRY_DELAY=2

for texture in "${TEXTURES[@]}"; do
  # Determine URL based on file extension
  if [[ $texture == *.webp ]]; then
    url="${WEBP_URL}/${texture}"
  else
    url="${PNG_URL}/${texture}"
  fi
  
  printf "%-50s " "$texture"
  
  retry=0
  while [ $retry -lt $MAX_RETRIES ]; do
    if curl -f -s -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" \
            --connect-timeout 5 --max-time 30 \
            -o "$TEXTURE_DIR/$texture" "$url"; then
      echo "✓"
      ((SUCCESS++))
      break
    fi
    ((retry++))
    if [ $retry -lt $MAX_RETRIES ]; then
      printf "[retry %d/$MAX_RETRIES] " $retry
      sleep $RETRY_DELAY
    fi
  done
  
  if [ $retry -eq $MAX_RETRIES ]; then
    echo "✗ FAILED"
    ((FAILED++))
  fi
done

echo ""
echo "Download complete!"
echo "Success: $SUCCESS | Failed: $FAILED"

if [ $FAILED -gt 0 ]; then
  echo ""
  echo "Troubleshooting:"
  echo "- Check if the asset servers are online"
  echo "- WebP server: curl -I $WEBP_URL"
  echo "- PNG server: curl -I $PNG_URL"
  echo "- Verify network connectivity"
  echo "- Check available disk space in $TEXTURE_DIR"
fi
