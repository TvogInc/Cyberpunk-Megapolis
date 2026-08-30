#!/bin/bash
# Download missing character textures for Cyberpunk Megapolis
# This script fetches .webp textures for the character models

TEXTURE_DIR="chars/textures"
mkdir -p "$TEXTURE_DIR"

ASSET_URL="https://zrlxxdaz56kym.ok.kimi.link/chars/textures"

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
echo "Source: $ASSET_URL"
echo ""

FAILED=0
SUCCESS=0

for texture in "${TEXTURES[@]}"; do
  url="${ASSET_URL}/${texture}"
  printf "%-50s " "$texture"
  if curl -f -s -o "$TEXTURE_DIR/$texture" "$url"; then
    echo "✓"
    ((SUCCESS++))
  else
    echo "✗ FAILED"
    ((FAILED++))
  fi
done

echo ""
echo "Download complete!"
echo "Success: $SUCCESS | Failed: $FAILED"
