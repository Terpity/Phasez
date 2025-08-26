# Phasez
Phasez is a Typst package based on cetz for drawing customizable phasor diagrams. It provides a single main function, `phasorPlot`, which allows you to visualize one or more phasors with a variety of options for axes, labels, colors, arcs, and more.

## Usage

First, import the package:

```
#import "../lib.typ" as phasez
```

Then, use the `phasorPlot` function to create a diagram. Example:

```
#figure(
  phasez.phasorPlot(
    length: 4cm,
    phasors: (
      (mag: 1, angle: 45deg),
    ),
  ),
  caption: [The most basic phasor diagram],
)
```

## phasorPlot Function

`phasorPlot` draws a phasor diagram with the following options:

- `phasors`: List of phasor objects. Each phasor can have:
  - `mag`: Magnitude (default: 1)
  - `angle`: Angle in degrees or radians (default: 45deg)
  - `colour`: Color of the phasor (optional)
  - `label`: Label for the phasor (text, true for auto, or none)
  - `labelOffset`: Position offset for the label (x, y, r)
  - `arc`: Draw an arc for the angle (true, false, or dictionary with `start`, `end`, `rad`, `label`, `colour`, `doFill`, `labelOffset`)
  - `traces`: Show projections on axes (true/false)
  - `prefix`/`suffix`: Text before/after the label
- `length`: Diagram size (default: 5cm)
- `showLabels`: Show phasor labels (default: true)
- `axesLabels`: Tuple of axis labels (default: ($Re$, $Im$))
- `xlimits`/`ylimits`: Axis limits (number or dictionary with `from`/`to`)
- `step`: Axis label step (number or dictionary with `x`/`y`)
- `autoHueScale`: Color hue scaling (default: 4)
- `greyscale`: Draw in greyscale (default: false)

## Examples

- Multiple phasors, custom colors, arcs, and labels:

``` typst
#figure(
  phasez.phasorPlot(
    autoHueScale: 6,
    length: 4cm,
    xlimits: (from: -1.6, to: 1),
    ylimits: (from: -.3, to: 1),
    step: (x: .25, y: .3),
    phasors: (
      (
        mag: 1.1,
        angle: 135deg,
        colour: purple,
        label: [$f(x)=1.1cos(omega t + 135degree)$],
        labelOffset: (x: -15pt, y: -1pt, r: 12deg),
        arc: (
          start: 30deg,
          label: text(size: 8pt, fill: orange)[$105degree$],
          colour: orange,
          labelOffset: (x: 10pt, y: 0pt, r: 0deg),
        ),
      ),
      (mag: 0.78, angle: ((calc.pi / 6) * 1rad), label: true, labelOffset: (x: -10pt, y: 5pt)),
    ),
  ),
  caption: [The works],
)
```

- Greyscale, custom arc:

``` typst
#figure(
  phasez.phasorPlot(
    xlimits: .9,
    ylimits: .6,
    step: .24,
    autoHueScale: 5,
    greyscale: true,
    length: 5cm,
    phasors: (
      (mag: 1, angle: 45deg, colour: orange, label: none, arc: (start: 180deg, colour: red, rad: .6cm)),
    ),
  ),
  caption: [Phasor diagram of me testing],
)
```

## Notes
- All arguments are optional except `phasors`.
- Angles can be in degrees (e.g., `45deg`) or radians (e.g., `calc.pi/2`).
- For more advanced customization, see the source code in `lib.typ`.
