# UI Guidelines

## Layout & Composition
- **Consistency**: Keep UI elements in standard locations (e.g., Inventory on the right, Quest log on the left).
- **Accents**: Use `Corner_` accents on all primary frames. Ensure they are animated via `ZundaFrameAnim.client.lua`.
- **Scaling**: UI should be responsive across different screen sizes. Use `UIScale` where appropriate.

## User Experience (UX)
- **Immediate Feedback**: Every click should have a visual or auditory response.
- **Clarity**: Use tooltips for complex items.
- **Navigation**: Minimize clicks to reach core functions (Cooking, Inventory).

## Dialogue System
- **Visual Novel (VN) Style**: Use the `VNController` for character-driven dialogue.
- **Speaker Attributes**: Ensure `VNDialogueData.lua` is updated with correct speaker emojis and accent colors.
- **Pacing**: Use `task.wait` to pace dialogue reveals; allow players to skip with a click.

## Polishing
- **Tweens**: Use `TweenService` for all transitions (opening/closing windows).
- **Accents**: Use `UIStroke` and `UIGradient` to give depth to frames.
- **Glow**: Use `ImageLabel` shadows/glows for important buttons.
