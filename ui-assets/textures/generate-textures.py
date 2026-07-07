"""
Zundamon's Kitchen - Texture Generation Script
This script generates placeholder UI textures using PIL (Pillow)
Run with: pip install pillow
"""

from PIL import Image, ImageDraw, ImageFont
import os

# Color definitions (RGB)
COLORS = {
    'primary_green': (124, 184, 124),
    'primary_green_light': (168, 212, 163),
    'primary_green_dark': (92, 154, 92),
    'wood_light': (212, 184, 150),
    'wood_default': (196, 180, 148),
    'wood_dark': (168, 144, 112),
    'cream_white': (252, 248, 240),
    'cream_light': (255, 250, 245),
    'cream_dark': (248, 240, 230),
    'text_primary': (45, 45, 45),
    'text_white': (255, 255, 255),
    'success': (125, 217, 125),
    'warning': (255, 207, 80),
    'error': (255, 120, 120),
    'hud_bg': (61, 42, 74),
    'hud_bg_light': (74, 50, 90),
}

def create_rounded_rectangle(width, height, radius, color, border_color=None, border_width=0):
    """Create a rounded rectangle image"""
    image = Image.new('RGBA', (width, height), color + (255,))
    draw = ImageDraw.Draw(image)
    
    # Draw rounded rectangle
    draw.rounded_rectangle(
        [(0, 0), (width, height)],
        radius=radius,
        fill=color + (255,),
        outline=border_color + (255,) if border_color else None,
        width=border_width
    )
    
    return image

def create_button_primary_default():
    """Create primary button texture"""
    image = create_rounded_rectangle(
        200, 48, 24,
        COLORS['primary_green'],
        COLORS['primary_green_dark'],
        2
    )
    return image

def create_button_secondary_default():
    """Create secondary button texture"""
    image = create_rounded_rectangle(
        200, 48, 24,
        COLORS['wood_light'],
        COLORS['wood_default'],
        2
    )
    return image

def create_panel_info_bg():
    """Create info panel background"""
    image = create_rounded_rectangle(
        400, 300, 22,
        COLORS['cream_white'],
        COLORS['wood_light'],
        3
    )
    return image

def create_card_recipe_bg():
    """Create recipe card background"""
    image = create_rounded_rectangle(
        200, 250, 16,
        COLORS['cream_white'],
        COLORS['wood_light'],
        3
    )
    return image

def create_hud_chef_pill():
    """Create HUD chef pill background"""
    image = create_rounded_rectangle(
        300, 40, 20,
        COLORS['hud_bg'],
        COLORS['primary_green'],
        2
    )
    return image

def create_xp_bar_bg():
    """Create XP bar background"""
    image = create_rounded_rectangle(
        120, 8, 4,
        COLORS['hud_bg_light'],
        None,
        0
    )
    return image

def create_xp_bar_fill():
    """Create XP bar fill"""
    image = create_rounded_rectangle(
        120, 8, 4,
        COLORS['primary_green'],
        None,
        0
    )
    return image

def create_cooking_track_bg():
    """Create cooking track background"""
    image = create_rounded_rectangle(
        680, 130, 22,
        (235, 255, 225),
        (140, 210, 130),
        2
    )
    return image

def create_hit_ring():
    """Create cooking hit ring"""
    image = Image.new('RGBA', (80, 80), (0, 0, 0, 0))
    draw = ImageDraw.Draw(image)
    
    # Draw semi-transparent circle
    draw.ellipse(
        [(0, 0), (80, 80)],
        fill=(180, 245, 190, 128),
        outline=(100, 200, 110, 255),
        width=4
    )
    
    return image

def create_perfect_ring():
    """Create cooking perfect ring"""
    image = Image.new('RGBA', (36, 36), (0, 0, 0, 0))
    draw = ImageDraw.Draw(image)
    
    # Draw semi-transparent circle
    draw.ellipse(
        [(0, 0), (36, 36)],
        fill=(255, 240, 200, 102),
        outline=(255, 200, 100, 255),
        width=3
    )
    
    return image

def create_cook_button():
    """Create cook button texture"""
    image = create_rounded_rectangle(
        360, 78, 22,
        (100, 195, 110),
        (60, 155, 70),
        3
    )
    return image

def create_icon_circle(color, size=48):
    """Create a simple circular icon placeholder"""
    image = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(image)
    
    draw.ellipse(
        [(4, 4), (size-4, size-4)],
        fill=color + (255,),
        outline=color + (200,),
        width=2
    )
    
    return image

def create_progress_bar_bg():
    """Create progress bar background"""
    image = create_rounded_rectangle(
        200, 8, 4,
        COLORS['cream_dark'],
        None,
        0
    )
    return image

def create_progress_bar_fill():
    """Create progress bar fill"""
    image = create_rounded_rectangle(
        200, 8, 4,
        COLORS['primary_green'],
        None,
        0
    )
    return image

def main():
    """Generate all textures"""
    output_dir = os.path.dirname(os.path.abspath(__file__))
    
    textures = {
        'button_primary_default.png': create_button_primary_default,
        'button_secondary_default.png': create_button_secondary_default,
        'panel_info_bg.png': create_panel_info_bg,
        'card_recipe_bg.png': create_card_recipe_bg,
        'hud_chef_pill.png': create_hud_chef_pill,
        'hud_xp_bar_bg.png': create_xp_bar_bg,
        'hud_xp_bar_fill.png': create_xp_bar_fill,
        'cooking_track_bg.png': create_cooking_track_bg,
        'cooking_hit_ring.png': create_hit_ring,
        'cooking_perfect_ring.png': create_perfect_ring,
        'cooking_button.png': create_cook_button,
        'progress_bar_bg.png': create_progress_bar_bg,
        'progress_bar_fill.png': create_progress_bar_fill,
    }
    
    # Generate icon placeholders
    icon_colors = [
        COLORS['primary_green'],
        COLORS['wood_light'],
        COLORS['success'],
        COLORS['warning'],
        COLORS['error'],
    ]
    
    for i, color in enumerate(icon_colors):
        textures[f'icon_placeholder_{i}.png'] = lambda c=color: create_icon_circle(c)
    
    # Generate all textures
    for filename, create_func in textures.items():
        try:
            image = create_func()
            filepath = os.path.join(output_dir, filename)
            image.save(filepath, 'PNG')
            print(f"Created: {filename}")
        except Exception as e:
            print(f"Error creating {filename}: {e}")
    
    print("\nTexture generation complete!")

if __name__ == "__main__":
    main()
