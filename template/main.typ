#import "../lib.typ": *
#figure(
  scale(
    100%,
    phasorPlot(
      autoHueScale: 5,
      greyscale: true,
      length: 6em,
      phasors: (
        (
          mag: 0.645,
          angle: 75deg,
          arc: (
            label: [Custom label],
            labelOffset: (x: 0pt, y: 5pt, r: -45deg),
          ),
        ),
        (mag: 1.4, angle: 120deg, colour: orange, label: none, arc: (start: 180deg, colour: red)),
      ),
    ),
  ),
  caption: [Phasor diagram of me testing],
)
