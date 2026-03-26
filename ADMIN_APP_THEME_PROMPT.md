# Forever Fit Admin App - Green Theme Implementation Prompt

## Instructions for Admin App AI Assistant

Apply the following green look and feel theme throughout the entire admin application to match the Forever Fit Boxing gym brand identity.

---

## 1. Color Scheme

**Primary Color (Lime Green):**
- Hex Code: `#39FF14`
- RGB: `rgb(57, 255, 20)`
- Use this color for all primary buttons, active states, highlights, and brand elements

**Color Replacements:**
- Replace ALL blue colors (`#102A66`, `#5452F6`, or any blue variants) with the lime green `#39FF14`
- Replace ALL coral/red accent colors with lime green where appropriate
- Keep white and black for text and backgrounds as needed

---

## 2. Splash Screen Implementation

**Background Image:**
- Use the image file saved as: `splash enhanced.jpeg` (or the image file you provide)
- Image should fill the entire screen using `BoxFit.cover`
- Apply a dark overlay (50% black opacity) over the image for text readability

**Splash Screen Elements:**
- Display "Prototype 1.0" text at the bottom center of the screen
- Text should be white with shadow effects for visibility
- Add a lime green button at the bottom with white text saying "Prototype 1.0"
- Button should have rounded corners (18px radius) and shadow
- Splash screen duration: 6.5 to 8.5 seconds
- Add smooth fade-in animation (1.5 seconds duration)

**Image Enhancement:**
- Apply color enhancement filter to boost green saturation (green channel: 1.18x, red/blue: 1.12x)
- Add slight brightness boost (0.02 offset to all channels)
- Use high-quality image filtering

---

## 3. Navigation & UI Elements

**Navigation Bar:**
- Background color: Lime green (`#39FF14`)
- Active/selected items: White text and icons
- Inactive items: White with 70% opacity (`Colors.white70`)
- Icons: White when selected, white70 when not selected

**Buttons:**
- Primary buttons: Lime green background (`#39FF14`) with white text
- Button text: White, font weight 600
- Button corners: Rounded (16-18px radius)
- Hover/pressed states: Slightly darker green or add shadow

**Text Buttons & Links:**
- All text buttons and clickable links: Lime green text color
- No background, just green text

**Input Fields:**
- Focused border: Lime green, 2px width
- Unfocused border: Light gray or white30
- Background: White or white with 10% opacity overlay
- Text color: White or dark depending on background

**Checkboxes & Switches:**
- Active color: Lime green (`#39FF14`)
- Check color: White
- Inactive: Gray

**Progress Indicators:**
- Active progress bars: Lime green
- Background: Light gray or white with opacity

**Cards & Containers:**
- Accent borders or highlights: Lime green where appropriate
- Icons within cards: Lime green
- Action buttons in cards: Lime green background

---

## 4. Gradients & Backgrounds

**Where gradients are used:**
- Replace blue gradients with lime green gradients
- Use variations: `limeGreen`, `limeGreen.withOpacity(0.8)`, `limeGreen.withOpacity(0.9)`
- For dark backgrounds, use lime green with varying opacities

**Background Images:**
- When using background images, apply dark overlay (black with 50-60% opacity) for text readability
- Ensure white text is used on dark/colored backgrounds

---

## 5. Specific UI Components

**App Bar / Header:**
- Background: Can be lime green or white with lime green accents
- Title text: White (if green background) or dark (if white background)
- Action icons: Lime green or white depending on background

**Sidebar / Drawer:**
- Active menu items: Lime green background or lime green text
- Icons: Lime green when active
- Avatar circles: Lime green background

**Tables & Lists:**
- Row highlights: Lime green with 10% opacity
- Selected rows: Lime green background
- Action buttons: Lime green

**Modals & Dialogs:**
- Primary action buttons: Lime green background
- Secondary buttons: Outlined with lime green border and text
- Close buttons: Can remain default or use lime green

**Badges & Tags:**
- Success/active badges: Lime green background with white text
- Status indicators: Use lime green for positive/active states

---

## 6. Typography & Text

**Headings:**
- Can use white text on dark backgrounds (with shadow for visibility)
- Or dark text on light backgrounds
- Ensure good contrast with lime green backgrounds

**Links:**
- All hyperlinks: Lime green color
- Hover state: Slightly darker green or underline

**Emphasis:**
- Important text: Can use lime green color
- Labels: Lime green for active/selected states

---

## 7. Animation & Transitions

**Color Transitions:**
- Smooth transitions when changing from inactive to active states
- Use lime green for all active/hover states

**Loading Indicators:**
- Spinner/loading colors: Lime green
- Progress bars: Lime green

---

## 8. Implementation Checklist

Apply lime green (`#39FF14`) to:
- [ ] All primary buttons
- [ ] Navigation bar background
- [ ] Active menu items
- [ ] Selected states
- [ ] Focused input borders
- [ ] Checkboxes and switches
- [ ] Progress indicators
- [ ] Links and text buttons
- [ ] Icon colors (where appropriate)
- [ ] Card accents and highlights
- [ ] Badges and tags
- [ ] Table row highlights
- [ ] Modal primary actions
- [ ] Splash screen button
- [ ] All gradients (replace blue with green)

**Splash Screen:**
- [ ] Use `splash enhanced.jpeg` as background
- [ ] Apply dark overlay (50% opacity)
- [ ] Add "Prototype 1.0" text/button at bottom
- [ ] Implement fade-in animation
- [ ] Set duration to 6.5-8.5 seconds
- [ ] Apply color enhancement filters

---

## 9. Color Code Reference

```dart
// Primary Lime Green
const Color limeGreen = Color(0xFF39FF14);

// Usage Examples:
backgroundColor: limeGreen
color: limeGreen
borderColor: limeGreen
selectedColor: limeGreen
activeColor: limeGreen
```

---

## 10. Visual Consistency

- Maintain consistent use of lime green throughout the entire admin app
- Ensure all interactive elements use lime green for active/selected states
- Keep white text on green backgrounds for contrast
- Use shadows and overlays to ensure text readability on image backgrounds
- Maintain the same rounded corner radius (16-18px) for buttons and cards
- Use the same shadow styles for depth and elevation

---

## Final Notes

The goal is to create a cohesive green brand identity throughout the admin app that matches the Forever Fit Boxing gym mobile app. Every blue element should be replaced with lime green, and the splash screen should use the provided enhanced image with the same styling approach used in the mobile app.

Apply these changes systematically across all screens, components, and UI elements in the admin application.



