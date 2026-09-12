---
name: Agro-Modernist
colors:
  surface: '#f9f9f9'
  surface-dim: '#dadada'
  surface-bright: '#f9f9f9'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f3f3'
  surface-container: '#eeeeee'
  surface-container-high: '#e8e8e8'
  surface-container-highest: '#e2e2e2'
  on-surface: '#1a1c1c'
  on-surface-variant: '#40493d'
  inverse-surface: '#2f3131'
  inverse-on-surface: '#f0f1f1'
  outline: '#707a6c'
  outline-variant: '#bfcaba'
  surface-tint: '#1b6d24'
  primary: '#0d631b'
  on-primary: '#ffffff'
  primary-container: '#2e7d32'
  on-primary-container: '#cbffc2'
  inverse-primary: '#88d982'
  secondary: '#556158'
  on-secondary: '#ffffff'
  secondary-container: '#d9e6da'
  on-secondary-container: '#5b675e'
  tertiary: '#734e00'
  on-tertiary: '#ffffff'
  tertiary-container: '#926500'
  on-tertiary-container: '#ffefda'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#a3f69c'
  primary-fixed-dim: '#88d982'
  on-primary-fixed: '#002204'
  on-primary-fixed-variant: '#005312'
  secondary-fixed: '#d9e6da'
  secondary-fixed-dim: '#bdcabe'
  on-secondary-fixed: '#131e17'
  on-secondary-fixed-variant: '#3e4a41'
  tertiary-fixed: '#ffdeac'
  tertiary-fixed-dim: '#ffba38'
  on-tertiary-fixed: '#281900'
  on-tertiary-fixed-variant: '#604100'
  background: '#f9f9f9'
  on-background: '#1a1c1c'
  surface-variant: '#e2e2e2'
typography:
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  headline-sm:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  xs: 8px
  sm: 12px
  md: 16px
  lg: 24px
  xl: 32px
  touch-target: 48px
  margin-mobile: 16px
  gutter-mobile: 12px
---

## Brand & Style

The design system is built on a foundation of **Modern Minimalism** infused with agricultural warmth. The goal is to provide a sense of reliability and clarity for users who need critical information at a glance.

The visual style prioritizes high-quality white space and a "Human-Centric Agricultural" aesthetic. It avoids technical jargon in the interface, opting for clear metaphors and an "open" feel. By combining professional stability with organic color tones, the system builds immediate trust with farmers and field agents, ensuring the technology feels like a supportive tool rather than an obstacle.

## Colors

The palette is rooted in the natural lifecycle of farming. 

- **Primary Green (#2E7D32):** Used for primary actions, success states, and brand-defining moments.
- **Secondary Light Green (#E8F5E9):** Used for large surface areas, background containers, and subtle highlighting to reduce visual fatigue.
- **Accent Orange/Yellow (#FFB300):** Reserved for notifications, warnings, and weather-related alerts to ensure high visibility without causing alarm.
- **Background (#FAFAFA):** A slightly warm neutral that prevents screen glare in outdoor sunlight.
- **Typography:** Headings use a deep Forest Green to maintain brand presence, while body text uses a functional Dark Grey for maximum legibility.

## Typography

This design system utilizes **Inter** for its exceptional legibility and neutral, professional tone. 

To accommodate users with varying degrees of technical literacy, font sizes are bumped 10-15% larger than standard enterprise apps. Line heights are generous to prevent text from feeling cramped. For mobile headlines, we use a tighter letter-spacing to maintain impact, while body text remains open for effortless reading in field conditions.

## Layout & Spacing

The layout follows a **Fluid Grid** model optimized for one-handed mobile use. 

A strict 4px baseline grid ensures vertical rhythm. On mobile devices, a 4-column grid is used with 16px outer margins. Key interactive elements must maintain a minimum **48px touch target** to ensure accessibility for users who may be working outdoors or have less precision. Use "Generous Padding" as a rule—never crowd content to the edges of cards or screens.

## Elevation & Depth

Hierarchy is established through **Tonal Layering** and **Ambient Shadows**. 

1. **Base:** The background sits at the lowest level (#FAFAFA).
2. **Cards/Surface:** Information containers use a pure white background with a very soft, diffused shadow (10% opacity of the primary green or neutral grey) to indicate interactability.
3. **Floating Actions:** Primary buttons use a slightly more pronounced shadow to appear "lifted" from the surface, inviting a press.
4. **Modals:** Use a semi-transparent dark overlay (Scrim) to pull focus, but keep the modal container edges soft to maintain the friendly brand personality.

## Shapes

The design system employs a **Rounded** shape language (Level 2). This eliminates the "harshness" of sharp corners, making the app feel more approachable and modern. 

- Standard components (Inputs, Chips): 0.5rem (8px)
- Cards and Large Containers: 1rem (16px)
- Primary Action Buttons: 1.5rem (24px) or fully pill-shaped to stand out from data cards.

## Components

### Buttons
Primary buttons use the Primary Green background with White text. They should span the full width of their container on mobile for easy reach. Secondary buttons use the Light Green background with Primary Green text.

### Cards
Cards are the primary vehicle for data (crop health, weather). They must feature a 16px internal padding and 16px corner radius. Headlines inside cards should be `headline-sm`.

### Input Fields
Inputs use a thick 2px border when focused. Label text must be `label-lg` and always visible (no disappearing placeholders) to ensure users don't lose context while typing.

### Chips & Tags
Used for filtering crops or soil types. These should have a `rounded-xl` (pill) shape. Active states use Primary Green; inactive states use a light grey stroke.

### Icons
Use 24px line icons with a 2px stroke weight. Icons should be paired with text labels whenever possible to ensure clarity across different regions and languages.

### Weather/Status Indicators
Use large, clear weather icons paired with the Accent Orange/Yellow for "High Alert" items (e.g., "Heavy Rain Warning") and Primary Green for "Optimal Conditions."