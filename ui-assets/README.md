# Zundamon's Kitchen - UI Assets

This directory contains all UI assets for the Zundamon's Kitchen Roblox game, organized for easy integration and maintenance.

## Directory Structure

```
ui-assets/
├── preview/              # HTML/CSS preview of design system
│   ├── index.html       # Main preview page
│   └── css/             # Stylesheet files
│       ├── design-system.css
│       ├── buttons.css
│       ├── inputs.css
│       ├── cards.css
│       ├── panels.css
│       ├── cooking.css
│       └── hud.css
├── textures/            # UI texture assets (PNG)
│   ├── generate-textures.py  # Script to generate placeholder textures
│   ├── TEXTURE-SPECIFICATIONS.md  # Detailed texture requirements
│   └── *.png            # Generated texture files
└── README.md            # This file
```

## Design System Integration

### Roblox Integration

The design system is integrated into the Roblox project through:

1. **DesignSystemConfig.lua** (`src/ReplicatedStorage/ConfigurationFiles/DesignSystemConfig.lua`)
   - Central color palette
   - Typography settings
   - Spacing and sizing tokens
   - Helper functions for creating styled UI elements

2. **GameUIComponents.lua** (`src/ReplicatedStorage/ConfigurationFiles/GameUIComponents.lua`)
   - Game-specific UI components
   - Recipe cards, ingredient cards, HUD elements
   - Achievement toasts, level-up banners
   - Pre-styled with design system colors

### Usage Example

```lua
local DesignSystemConfig = require(game.ReplicatedStorage.ConfigurationFiles.DesignSystemConfig)
local GameUIComponents = require(game.ReplicatedStorage.ConfigurationFiles.GameUIComponents)

-- Create a recipe card
local recipeCard = GameUIComponents.createRecipeCard({
    RecipeName = "Vegetable Soup",
    Description = "A warm and comforting soup",
    Rarity = "Epic",
    IsLocked = false,
    IsSelected = false,
    Parent = playerGui
})

-- Create a chef pill (HUD)
local chefPill = GameUIComponents.createChefPill({
    Level = 5,
    TierName = "Apprentice",
    TierBadge = "🌱",
    XP = 60,
    XPNeeded = 100,
    TierColor = DesignSystemConfig.COLORS.PrimaryGreen,
    Parent = playerGui
})
```

## Color Palette

### Primary Colors
- **Primary Green**: #7CB87C - Main action color, success states
- **Primary Light**: #A8D4A3 - Hover states
- **Primary Dark**: #5A9A5A - Pressed states
- **Primary Deep**: #3D7A3D - Disabled states

### Secondary Colors
- **Wood Light**: #D4B896 - Secondary elements, borders
- **Wood Default**: #C4B494 - Neutral wood tones
- **Wood Dark**: #A89070 - Dark wood accents

### Background Colors
- **Cream White**: #FCF8F0 - Main backgrounds
- **Cream Light**: #FFFAF5 - Light backgrounds
- **Cream Dark**: #F8F0E6 - Darker backgrounds

### Text Colors
- **Text Primary**: #2D2D2D - Main text
- **Text Secondary**: #4D4D4D - Secondary text
- **Text Disabled**: #909090 - Disabled text
- **Text White**: #FFFFFF - White text on dark backgrounds

### Semantic Colors
- **Success**: #7ED97E - Success states
- **Warning**: #FFCF50 - Warnings, important info
- **Error**: #FF7878 - Error states
- **Info**: #78B8F8 - Informational

### Rarity Colors
- **Common**: #A8A8A8
- **Uncommon**: #7ED97E
- **Rare**: #78B8F8
- **Epic**: #B89FF7
- **Legendary**: #FFCF50

## Typography

### Font Families
- **Title**: FredokaOne - Headings, important text
- **Heading**: GothamBold - Secondary headings
- **Body**: Gotham - Body text, labels
- **Label**: Gotham - Small text, labels

### Font Sizes
- **Title Large**: 36px
- **Title**: 28px
- **Heading**: 20px
- **Body**: 16px
- **Small**: 14px
- **Tiny**: 12px

## Components

### Buttons
- Primary Button (default, hover, pressed, disabled)
- Secondary Button (default, hover, pressed, disabled)
- Destructive Button
- Icon Button
- Button Sizes (large, default, small)

### Inputs
- Text Input (default, focused, error, disabled)
- Text Area
- Search Input
- Number Input
- Select Dropdown

### Cards
- Recipe Card (default, hover, selected, locked)
- Ingredient Card
- Achievement Card

### Panels
- Info Panel
- Modal Window
- Progress Panel
- Notification Panel

### HUD Elements
- Chef Pill (level display)
- XP Bar
- Combo Meter
- Daily Widget
- Minimap
- Quick Actions

### Game-Specific
- Cooking Minigame Interface
- Achievement Toast
- Level Up Banner
- Popup Notifications

## Preview

To preview the UI components:

1. Open `ui-assets/preview/index.html` in a web browser
2. All components are displayed with their various states
3. Styles are organized by category in the CSS files

## Texture Assets

Placeholder textures have been generated using the Python script. For production:

1. Review `textures/TEXTURE-SPECIFICATIONS.md` for detailed requirements
2. Create final textures in Photoshop, Figma, or your preferred tool
3. Follow the naming convention and export settings
4. Replace placeholder files with final assets
5. Upload to Roblox and update asset IDs in the code

### Generating Placeholders

To regenerate placeholder textures:

```bash
cd ui-assets/textures
python generate-textures.py
```

This requires Python and Pillow:
```bash
pip install pillow
```

## Integration Checklist

- [ ] Update existing UI scripts to use DesignSystemConfig
- [ ] Replace hardcoded colors with design system colors
- [ ] Integrate GameUIComponents into relevant scripts
- [ ] Upload final texture assets to Roblox
- [ ] Update texture asset IDs in code
- [ ] Test all UI elements in-game
- [ ] Verify accessibility and readability
- [ ] Check performance with texture atlases

## Maintenance

### Adding New Components

1. Create component in `GameUIComponents.lua`
2. Add preview to `preview/index.html`
3. Add styles to appropriate CSS file
4. Update this README

### Updating Colors

1. Modify colors in `DesignSystemConfig.lua`
2. Update CSS variables in `preview/css/design-system.css`
3. Regenerate textures if needed
4. Test in both preview and Roblox

### Adding New Textures

1. Add specification to `TEXTURE-SPECIFICATIONS.md`
2. Create texture file
3. Update `generate-textures.py` if needed
4. Upload to Roblox

## Performance Considerations

- Use texture atlases to reduce draw calls
- Limit texture sizes to 2048x2048 maximum
- Use 9-slice scaling for buttons and panels
- Optimize image compression for web deployment
- Consider using ImageButtons with ScaleType.Slice for scalable elements

## Accessibility

- Ensure text contrast ratios meet WCAG AA standards
- Use clear visual indicators for interactive elements
- Provide alternative text for icon-only buttons
- Consider colorblind-friendly color choices
- Test with different screen sizes and resolutions

## Credits

Design System created for Zundamon's Kitchen Roblox game.
Based on cozy, whimsical aesthetic for farming and cooking gameplay.
