# Design System

## Visual Language
The game uses a **"Kawaii / Cozy Sim"** visual language. Everything should feel soft, inviting, and whimsical.

## Color Palette
- **Primary Green**: `RGB(120, 200, 130)` (Zundamon Green)
- **Secondary Green**: `RGB(150, 230, 160)` (Zundapal Green)
- **Accent Pink/Lavender**: `RGB(225, 185, 255)` (Used for UI strokes, highlights, and magical effects)
- **Warm Gold**: `RGB(255, 215, 0)` (Progress, rewards, rare items)
- **Dark Text**: `RGB(45, 45, 45)` (For readability on light backgrounds)

## Typography & Iconography
- **Emojis**: Use emojis liberally in UI and notifications to represent items and emotions.
    - `🍙` Zundamon / Rice
    - `🍡` Zundapal / Mochi
    - `✨` Magic / Success
    - `🌼` Flowers / Nature
    - `🍳` Cooking / Kitchen
- **Fonts**: Use rounded, friendly fonts (e.g., Fredoka One, Patrick Hand) in Studio.

## UI Components
- **Corners**: UI frames should use animated corner accents (see `ZundaFrameAnim.client.lua`).
- **Feedback**:
    - **Toasts**: Brief, non-intrusive notifications for gathering/cooking success.
    - **FX**: Particles and tweens should accompany all major player actions.
    - **Breathing**: Interactive elements should have a subtle "breathing" animation (scale pulse).

## State Indicators
- **Available**: Items that can be interacted with should pulse or have a slight glow.
- **Cooldown**: Use semi-transparent overlays or grayscale filters for items on cooldown.
