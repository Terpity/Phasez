#import "../lib.typ": *
#figure(
  scale(
    100%,
    phasorPlot(
      autoHueScale: 5,
      length: 8em,
      phasors: (
        (mag: 1, angle: 170deg, colour: red, arc: (start: 75deg), traces: true),
        (mag: 1, angle: 75deg, colour: blue),
        // (mag: .5, angle: 30deg),
        // (mag: .5, angle: -60deg),
        // (mag: .5, angle: -153deg),
      ),
    ),
  ),
  caption: [Phasor diagram of me testing],
)
