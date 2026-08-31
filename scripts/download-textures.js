#!/usr/bin/env node
/**
 * Download and organize character textures locally
 * Fixes 404 errors for missing texture files in /chars/textures/
 * 
 * This script downloads all character textures from the remote server
 * and stores them locally in the project.
 * 
 * Usage: node scripts/download-textures.js
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import https from 'https';
import http from 'http';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const PROJECT_ROOT = path.join(__dirname, '..');
const CHARS_TEXTURES_DIR = path.join(PROJECT_ROOT, 'public', 'chars', 'textures');

// Remote source for textures
const TEXTURE_SOURCE_URL = 'https://zrlxxdaz56kym.ok.kimi.link/chars/textures';

// List of missing textures from the error log
const MISSING_CHAR_TEXTURES = [
  'T_SurvGirl_Hair_basecolor.webp',
  'T_SurvGirl_Hat02_BaseColor.webp',
  'T_SurvGirl_Hair_normal.webp',
  'T_SurvGirl_Backpack01_BaseColor.webp',
  'T_SurvGirl_Backpack01_Normal.webp',
  'T_SurvGirl_Backpack01_MetallicSmoothness.webp',
  'T_SurvGirl_Hat02_MetallicSmoothness.webp',
  'T_SurvGirl_Tshirt01_MetallicSmoothness.webp',
  'T_SurvGirl_Pants04_BaseColor.webp',
  'T_SurvGirl_Eyes_Normal.webp',
  'T_SurvGirl_Tshirt01_Normal.webp',
  'T_SurvGirl_Teeth_BaseColor.webp',
  'T_SurvGirl_Shoes01_BaseColor.webp',
  'T_SurvGirl_Body_Normal.webp',
  'T_SurvGirl_Eyelashes.webp',
  'T_SurvGirl_Tshirt01_BaseColor.webp',
  'T_SurvGirl_Head_BaseColor_01.webp',
  'T_SurvGirl_Pants04_Normal.webp',
  'T_SurvGirl_Shoes01_Normal.webp',
  'T_SurvGirl_Head_MetallicSmoothness.webp',
  'T_SurvGirl_Head_Normal.webp',
  'T_SurvGirl_Eyes_BaseColorBlue.webp',
  'T_SurvGirl_Body_Dirt_MetallicSmoothness.webp',
  'T_SurvGirl_Teeth_Normal.webp',
  'T_SurvGirl_Pants04_MetallicSmoothness.webp',
  'T_SurvGirl_Body_BaseColor_01.webp',
  'T_SurvGirl_Shoes01_MetallicSmoothness.webp',
  'T_SurvGirl_eyeshadow.webp',
  'T_SurvGirl_Hair_AO.webp',
];

/**
 * Download file from URL
 */
function downloadFile(url, destPath) {
  return new Promise((resolve, reject) => {
    const protocol = url.startsWith('https') ? https : http;
    const filename = path.basename(destPath);
    
    protocol.get(url, (res) => {
      if (res.statusCode !== 200) {
        reject(new Error(`HTTP ${res.statusCode}`));
        return;
      }
      
      const chunks = [];
      let downloadedBytes = 0;
      
      res.on('data', (chunk) => {
        chunks.push(chunk);
        downloadedBytes += chunk.length;
      });
      
      res.on('end', () => {
        try {
          fs.writeFileSync(destPath, Buffer.concat(chunks));
          console.log(`  ✓ ${filename} (${(downloadedBytes / 1024).toFixed(2)} KB)`);
          resolve();
        } catch (err) {
          reject(err);
        }
      });
    }).on('error', (err) => {
      reject(new Error(`Download failed: ${err.message}`));
    });
  });
}

/**
 * Main download function
 */
async function downloadTextures() {
  console.log('🎨 Cyberpunk Megapolis - Texture Downloader\n');
  console.log(`Source: ${TEXTURE_SOURCE_URL}\n`);
  
  // Create directories if they don't exist
  if (!fs.existsSync(CHARS_TEXTURES_DIR)) {
    fs.mkdirSync(CHARS_TEXTURES_DIR, { recursive: true });
    console.log(`📁 Created directory: ${path.relative(PROJECT_ROOT, CHARS_TEXTURES_DIR)}\n`);
  }
  
  console.log(`📥 Downloading ${MISSING_CHAR_TEXTURES.length} character textures...\n`);
  
  let successCount = 0;
  let skipCount = 0;
  let failCount = 0;
  const failedFiles = [];
  
  for (const texture of MISSING_CHAR_TEXTURES) {
    const destPath = path.join(CHARS_TEXTURES_DIR, texture);
    
    // Skip if already exists
    if (fs.existsSync(destPath)) {
      console.log(`  ⊘ ${texture} (already exists)`);
      skipCount++;
      continue;
    }
    
    try {
      const textureUrl = `${TEXTURE_SOURCE_URL}/${texture}`;
      await downloadFile(textureUrl, destPath);
      successCount++;
    } catch (err) {
      console.error(`  ✗ ${texture} - ${err.message}`);
      failCount++;
      failedFiles.push(texture);
    }
  }
  
  // Summary
  console.log(`\n${'='.repeat(60)}`);
  console.log(`📊 Download Summary:`);
  console.log(`   ✓ Downloaded: ${successCount}`);
  console.log(`   ⊘ Skipped (existing): ${skipCount}`);
  console.log(`   ✗ Failed: ${failCount}`);
  console.log(`${'='.repeat(60)}\n`);
  
  if (failCount > 0) {
    console.log(`⚠️  Failed to download:`);
    failedFiles.forEach(f => console.log(`   - ${f}`));
    console.log(`\nTry again later or verify the source URL is accessible.\n`);
    process.exit(1);
  } else {
    console.log(`✅ All textures ready at: ${path.relative(PROJECT_ROOT, CHARS_TEXTURES_DIR)}\n`);
  }
}

// Run the downloader
downloadTextures().catch((err) => {
  console.error('❌ Fatal error:', err.message);
  process.exit(1);
});
