# Zundamon's Kitchen - UI Texture Specifications

This document outlines all UI textures needed for the game, their specifications, and creation guidelines.

## Overview
All textures should follow the cozy, whimsical aesthetic with hand-drawn elements, soft colors, and rounded corners.

## Texture Categories

### 1. Button Textures

#### Primary Button
- **File**: `button_primary_default.png`
- **Size**: 200x48 (base), scalable
- **Colors**: Primary green (#7CB87C) with subtle gradient
- **Style**: Rounded pill shape, soft shadow
- **States**: default, hover, pressed, disabled
- **Format**: PNG with transparency

#### Secondary Button
- **File**: `button_secondary_default.png`
- **Size**: 200x48 (base), scalable
- **Colors**: Wood light (#D4B896) with subtle gradient
- **Style**: Rounded pill shape, 2px border
- **States**: default, hover, pressed, disabled

### 2. Panel Textures

#### Info Panel Background
- **File**: `panel_info_bg.png`
- **Size**: 400x300 (base), scalable
- **Colors**: Cream white (#FCF8F0) with subtle paper texture
- **Style**: Rounded corners, wood border
- **Border**: 3px wood color (#D4B896)

#### Modal Window
- **File**: `modal_window_bg.png`
- **Size**: 600x400 (base), scalable
- **Colors**: Gradient from light green to cream
- **Style**: Rounded corners, green border
- **Border**: 4px primary green (#7CB87C)

### 3. Card Textures

#### Recipe Card Background
- **File**: `card_recipe_bg.png`
- **Size**: 200x250
- **Colors**: Cream white with subtle texture
- **Style**: Rounded corners, wood border
- **States**: default, hover, selected, locked

#### Ingredient Card
- **File**: `card_ingredient_bg.png`
- **Size**: 100x120
- **Colors**: Cream white
- **Style**: Circular or rounded square

### 4. HUD Elements

#### Chef Pill Background
- **File**: `hud_chef_pill.png`
- **Size**: 300x40
- **Colors**: Dark purple gradient (#3D2A4A to #4A325A)
- **Style**: Pill shape, green border
- **Border**: 2px primary green

#### XP Bar Background
- **File**: `hud_xp_bar_bg.png`
- **Size**: 120x8
- **Colors**: Dark purple (#2D2A3A)
- **Style**: Rounded ends

#### XP Bar Fill
- **File**: `hud_xp_bar_fill.png`
- **Size**: 120x8
- **Colors**: Primary green gradient
- **Style**: Rounded ends
- **Variants**: green, gold, epic, legendary

### 5. Cooking Minigame Textures

#### Cooking Track Background
- **File**: `cooking_track_bg.png`
- **Size**: 680x130
- **Colors**: Light green (#EBFFE1)
- **Style**: Rounded corners, subtle border
- **Border**: 2px green (#8CD282)

#### Hit Ring
- **File**: `cooking_hit_ring.png`
- **Size**: 80x80
- **Colors**: Semi-transparent green (#B4F5BE)
- **Style**: Circular with border
- **Border**: 4px green (#64C86E)

#### Perfect Ring
- **File**: `cooking_perfect_ring.png`
- **Size**: 36x36
- **Colors**: Semi-transparent gold (#FFF0C8)
- **Style**: Circular with border
- **Border**: 3px gold (#FFC864)

#### Cook Button
- **File**: `cooking_button.png`
- **Size**: 360x78
- **Colors**: Primary green (#64C36E)
- **Style**: Rounded corners, border
- **Border**: 3px dark green (#3C9B46)

### 6. Icon Textures

#### Navigation Icons
- **File**: `icon_home.png`, `icon_settings.png`, `icon_search.png`, etc.
- **Size**: 48x48
- **Style**: Simple, rounded, hand-drawn feel
- **Colors**: Primary green or wood colors

#### Ingredient Icons
- **File**: `icon_carrot.png`, `icon_tomato.png`, `icon_onion.png`, etc.
- **Size**: 64x64
- **Style**: Cute, stylized, hand-drawn
- **Colors**: Natural ingredient colors

#### Rarity Icons
- **File**: `icon_rarity_common.png`, `icon_rarity_uncommon.png`, etc.
- **Size**: 32x32
- **Style**: Star or gem shapes
- **Colors**: Corresponding rarity colors

### 7. Decorative Elements

#### Border Flourishes
- **File**: `border_corner_leaf.png`, `border_corner_floral.png`, etc.
- **Size**: 80x80
- **Style**: Hand-drawn decorative corners
- **Colors**: Green or wood tones

#### Texture Overlays
- **File**: `texture_paper.png`, `texture_wood.png`, `texture_fabric.png`
- **Size**: 512x512 (seamless)
- **Style**: Subtle, repeatable textures
- **Colors**: Neutral tones

### 8. Progress Elements

#### Progress Bar Background
- **File**: `progress_bar_bg.png`
- **Size**: 200x8
- **Colors**: Cream dark (#F8F0E6)
- **Style**: Rounded ends

#### Progress Bar Fill
- **File**: `progress_bar_fill.png`
- **Size**: 200x8
- **Colors**: Primary green gradient
- **Style**: Rounded ends

### 9. Notification Elements

#### Notification Background
- **File**: `notification_bg.png`
- **Size**: 340x70
- **Colors**: Dark purple gradient
- **Style**: Rounded corners, border
- **Border**: 2px gold (#FFCF50)

#### Achievement Banner
- **File**: `achievement_banner.png`
- **Size**: 400x80
- **Colors**: Dark purple with gold accents
- **Style**: Decorative, celebratory

## Creation Guidelines

### Color Palette
Use the design system colors:
- Primary Green: #7CB87C
- Wood Light: #D4B896
- Cream White: #FCF8F0
- Text Primary: #2D2D2D
- Success: #7ED97E
- Warning: #FFCF50
- Error: #FF7878

### Style Guidelines
- **Rounded Corners**: Use 8-24px radius depending on element size
- **Shadows**: Soft, subtle shadows (2-4px offset, 10-20% opacity)
- **Gradients**: Subtle, natural-looking gradients
- **Borders**: 2-4px thickness, matching element colors
- **Textures**: Hand-drawn, paper-like textures for backgrounds

### File Format
- **Format**: PNG with transparency
- **Resolution**: 2x or 4x for Retina/High-DPI displays
- **Color Depth**: 32-bit RGBA
- **Compression**: Lossless PNG

### Naming Convention
- Format: `[category]_[element]_[state].png`
- Examples: `button_primary_default.png`, `card_recipe_hover.png`
- Use lowercase with underscores

## Export Settings

### For Photoshop
1. File > Export > Export As...
2. Format: PNG
3. Quality: Maximum
4. Transparency: Checked
5. Size: 2x for high-DPI

### For Figma
1. Select frame
2. Export settings: PNG @2x or @4x
3. Suffix: none or @2x
4. Transparent background

### For Illustrator
1. File > Export > Export As...
2. Format: PNG
3. Resolution: 144 PPI (2x)
4. Background: Transparent

## Texture Atlas

For optimal performance in Roblox, consider creating texture atlases:

### UI Atlas
- **File**: `ui_atlas.png`
- **Size**: 1024x1024 or 2048x2048
- **Contents**: All UI elements packed efficiently
- **Spacing**: 2px between elements

### Icon Atlas
- **File**: `icon_atlas.png`
- **Size**: 512x512
- **Contents**: All icons packed in a grid
- **Grid**: 64x64 or 128x128 cells

## Implementation Notes

### Roblox ImageLabel/ImageButton
```lua
local imageLabel = Instance.new("ImageLabel")
imageLabel.Image = "rbxassetid://YOUR_ASSET_ID"
imageLabel.ScaleType = Enum.ScaleType.Slice
imageLabel.SliceCenter = Rect.new(16, 16, 48, 32) -- Adjust based on texture
```

### Nine-Slice Scaling
- For buttons and panels, use 9-slice scaling
- Slice margins: 16px for large elements, 8px for small
- Ensures proper scaling without distortion

### Performance
- Use texture atlases to reduce draw calls
- Limit texture sizes to 2048x2048 maximum
- Use appropriate compression for final export

## Checklist

- [ ] Create all button textures (4 states × 2 types = 8 files)
- [ ] Create panel textures (2 types)
- [ ] Create card textures (4 states)
- [ ] Create HUD element textures (5 types)
- [ ] Create cooking minigame textures (4 types)
- [ ] Create navigation icons (8 icons)
- [ ] Create ingredient icons (12 icons)
- [ ] Create rarity icons (5 types)
- [ ] Create decorative elements (6 types)
- [ ] Create texture overlays (3 types)
- [ ] Create progress elements (2 types)
- [ ] Create notification elements (2 types)
- [ ] Create texture atlases (2 atlases)
- [ ] Test all textures in Roblox
- [ ] Optimize for performance
