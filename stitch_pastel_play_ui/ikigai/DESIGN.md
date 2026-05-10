---
name: Ikigai
colors:
  surface: '#f9f9f7'
  surface-dim: '#dadad8'
  surface-bright: '#f9f9f7'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f4f4f2'
  surface-container: '#eeeeec'
  surface-container-high: '#e8e8e6'
  surface-container-highest: '#e2e3e1'
  on-surface: '#1a1c1b'
  on-surface-variant: '#434843'
  inverse-surface: '#2f3130'
  inverse-on-surface: '#f1f1ef'
  outline: '#737872'
  outline-variant: '#c3c8c1'
  surface-tint: '#506354'
  primary: '#334537'
  on-primary: '#ffffff'
  primary-container: '#4a5d4e'
  on-primary-container: '#c0d5c2'
  inverse-primary: '#b7ccb9'
  secondary: '#5a5c79'
  on-secondary: '#ffffff'
  secondary-container: '#dcddff'
  on-secondary-container: '#5e617d'
  tertiary: '#394610'
  on-tertiary: '#ffffff'
  tertiary-container: '#505e26'
  on-tertiary-container: '#c6d792'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d3e8d5'
  primary-fixed-dim: '#b7ccb9'
  on-primary-fixed: '#0e1f13'
  on-primary-fixed-variant: '#394b3d'
  secondary-fixed: '#dfe0ff'
  secondary-fixed-dim: '#c2c4e5'
  on-secondary-fixed: '#161a32'
  on-secondary-fixed-variant: '#424560'
  tertiary-fixed: '#d9eaa3'
  tertiary-fixed-dim: '#bdce89'
  on-tertiary-fixed: '#161f00'
  on-tertiary-fixed-variant: '#3e4c16'
  background: '#f9f9f7'
  on-background: '#1a1c1b'
  surface-variant: '#e2e3e1'
typography:
  display-lg:
    fontFamily: Source Serif 4
    fontSize: 48px
    fontWeight: '600'
    lineHeight: '1.1'
    letterSpacing: -0.02em
  display-lg-mobile:
    fontFamily: Source Serif 4
    fontSize: 36px
    fontWeight: '600'
    lineHeight: '1.2'
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Source Serif 4
    fontSize: 32px
    fontWeight: '500'
    lineHeight: '1.3'
  headline-sm:
    fontFamily: Source Serif 4
    fontSize: 24px
    fontWeight: '500'
    lineHeight: '1.4'
  body-lg:
    fontFamily: Manrope
    fontSize: 18px
    fontWeight: '400'
    lineHeight: '1.6'
  body-md:
    fontFamily: Manrope
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.6'
  label-md:
    fontFamily: Manrope
    fontSize: 14px
    fontWeight: '600'
    lineHeight: '1.2'
    letterSpacing: 0.03em
  label-sm:
    fontFamily: Manrope
    fontSize: 12px
    fontWeight: '700'
    lineHeight: '1.2'
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 8px
  container-max: 1280px
  gutter: 24px
  margin-desktop: 64px
  margin-mobile: 24px
---

## Brand & Style

This design system is built on the philosophy of finding balance through intentionality. The brand personality is grounded and serene, avoiding the frantic energy of typical digital interfaces in favor of a stable, architectural presence. It targets users seeking clarity and focus, providing an environment that feels integrated with natural rhythms rather than isolated from them.

The visual style leans into a refined minimalism that prioritizes high-contrast readability and "purposeful" whitespace. It avoids the visual noise of gradients or excessive decoration, relying instead on structural integrity, generous proportions, and a sophisticated interplay between nature-inspired hues and crisp typography. The goal is to evoke an emotional response of calm confidence and quiet authority.

## Colors

The palette is derived from an earthy, botanical spectrum to ground the digital experience in the physical world. 

- **Primary (Sage Green):** A muted, deep sage used for core actions and primary brand moments. It represents growth and stability.
- **Secondary (Muted Indigo):** A scholarly, deep blue used for links, secondary accents, and to denote "purpose" and depth.
- **Tertiary (Earthy Green):** A lighter, moss-like green used for subtle accents and success states.
- **Neutral (Warm Gray):** A range of "stone" grays that replace harsh whites and blacks, ensuring the interface feels warm and tactile rather than clinical.
- **High Contrast:** Text elements must maintain a high contrast ratio against the parchment-like background surfaces to ensure maximum legibility and accessibility.

## Typography

The typography strategy pairs the structural reliability of a modern sans-serif with the intellectual weight of a refined serif.

- **Headlines:** We use **Source Serif 4**. Its sturdy yet elegant letterforms provide a sense of history and purpose. It should be used for all major page headings and section titles.
- **Body & Interface:** We use **Manrope**. Its geometric but warm characteristics offer exceptional legibility at small sizes. It provides the "stability" needed for functional UI elements.
- **Rhythm:** Generous line heights (1.6x for body) are mandatory to maintain the feeling of breathability and calm. Use uppercase labels with slight tracking for metadata to create a distinct visual hierarchy between content and navigation.

## Layout & Spacing

The layout is governed by a **fixed-column grid** that provides a grounded, architectural foundation. 

- **Desktop:** A 12-column grid with a 1280px maximum container width. Margins are intentionally wide (64px) to frame the content like a page in a high-end journal.
- **Mobile:** A 4-column fluid grid with 24px side margins. 
- **Spacing Logic:** All spacing follows an 8px base unit. Vertical rhythm is critical; sections should be separated by large "voids" (80px or 120px) to prevent the user from feeling overwhelmed.
- **Alignment:** Content is generally center-aligned within the container to enhance the feeling of balance and symmetry.

## Elevation & Depth

This design system avoids heavy shadows and floating effects in favor of **Tonal Layering**. 

Depth is communicated through subtle color shifts between the background and container surfaces. If elevation is required for clarity (such as a dropdown or modal), use a very soft, diffused ambient shadow: `0px 4px 24px rgba(61, 64, 91, 0.08)`. 

Instead of traditional "cards" with heavy borders, use **low-contrast outlines** (1px solid in a slightly darker earthy gray) or simple shifts in background color to define boundaries. This keeps the interface feeling "flat" and integrated with the base layer, reinforcing the theme of stability.

## Shapes

The shape language is **architectural and intentional**. We move away from the "bubbly" aesthetic of modern consumer apps.

- **Radius:** The standard corner radius is 8px for smaller components (buttons, inputs) and 12px for larger containers (cards, modals). 
- **Consistency:** All interactive elements must share these precise radii to create a sense of structural unity.
- **Stroke:** Use 1px or 1.5px strokes. Avoid thick, heavy borders that disrupt the visual serenity.

## Components

- **Buttons:** Primary buttons use the Sage Green background with white text. They are rectangular with an 8px radius. Secondary buttons use a Muted Indigo outline.
- **Inputs:** Fields are defined by a bottom border or a very light gray fill. High-contrast labels always sit above the field. Focus states utilize a subtle 2px Indigo bottom border.
- **Chips:** Used for categorization, these have a 12px radius and use the Warm Earthy Gray background with small, bolded Manrope text.
- **Cards:** Cards should be borderless with a subtle background color shift (e.g., from `#FAF9F6` to `#F2F2F0`). They use 12px corners.
- **Lists:** High-contrast separators (0.5px) and generous vertical padding (16px-24px) between list items to maintain the "serene" whitespace.
- **Navigation:** Top-level navigation uses the Serif font in a smaller size to emphasize the "purposeful" nature of the application's structure.