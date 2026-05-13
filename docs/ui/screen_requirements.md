# Screen Requirements

## Target Devices

古い端末で縦向き・横向きの両方を使う前提。

- iPhone landscape compact reference: 667 x 375 pt
- iPhone smaller landscape risk check: 568 x 320 pt
- iPhone portrait reference: 375 x 667 pt
- iPhone smaller portrait risk check: 320 x 568 pt
- iPad mini landscape reference: 1024 x 768 pt
- iPad landscape reference: 1024 x 768 pt
- iPad mini portrait reference: 768 x 1024 pt
- iPad portrait reference: 768 x 1024 pt
- OS baseline: iOS 12 generation

## Main Screen

### Required Elements

- Left analog clock display
- Right monthly calendar
- Blue highlight for today's date
- Top-right settings button with a simple `i` icon

### Settings Screen

- `Light` and `Dark`
- `Sunday`, `Monday`, and `Saturday`
- English UI text only
- Works in portrait and landscape on iPhone and iPad

### Clock Display Variants

- Analog clock only for the current direction
- Hour numerals are visible
- Tick marks are visible
- Red seconds hand is visible

### Not Included

- Alarm
- Weather
- Schedule details
- Theme picker beyond `Light` / `Dark`
- Interactive clock mode switching

## Layout Priorities

1. Left side keeps the selected clock display readable
2. Right side keeps the calendar readable
3. Today's date highlight is visible without becoming visually noisy
4. No controls compete with the clock or calendar
5. The layout works from compact iPhone portrait/landscape to iPad portrait/landscape

## Orientation Behavior

- The prototype must support both portrait and landscape
- Landscape uses a left clock / right calendar split
- Portrait uses a top clock / bottom calendar stack
- Main screen should be designed for fullscreen use
- Status bar should not be required for the core UI
- The layout must not break whether the status bar is hidden or visible during early testing

## Analog Clock

- Clock face must remain circular
- Hands should be thick enough for old displays
- Show tick marks
- Show numerals
- Use a red seconds hand
- Avoid extra decorative effects beyond the screenshot-driven design

## Calendar

- Show one month
- Use 7 columns
- Support up to 6 week rows
- Sunday's text must be red
- Saturday's text must be blue
- Today's date must be highlighted with a blue marker and white text
- Other days should stay visually quiet
- Calendar labels must remain readable on iPhone portrait and landscape

## Night Use

- Default design should be usable in a dark room
- Avoid maximum-brightness pure white as the dominant display color
- Use soft white as the primary display color
- Today's date highlight should be clear but not glaring
- Real device brightness control is out of scope for this prototype phase

## Implementation Notes

The UI prototype should only assume the minimum logic needed to draw the screen:

- Month calculation
- Date rollover at midnight
- Theme persistence
- Week-start persistence

These are implementation notes for the visible clock and calendar, not additional user-facing features.

## Manual Device Checks Later

These require real device or simulator review later.

- iPhone landscape readability
- iPhone portrait readability
- iPad mini landscape balance
- iPad mini portrait balance
- iPad landscape balance
- iPad portrait balance
- Whether the analog clock is large enough on iPhone
- Whether calendar day numbers are readable on iPhone
- Whether today's highlight is too bright in a dark room
- Whether any important UI is hidden by legacy status bar behavior
- Whether the top-right settings button stays easy to tap on old iPhone screens
