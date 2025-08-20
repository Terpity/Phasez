#import "../lib.typ": *
#figure(
  scale(
    100%,
    phasorPlot(
      autoHueScale: 5,
      greyscale: true,
      length: 6em,
      phasors: (
        (mag: 1, angle: 16deg),
        (mag: 1, angle: 75deg),
        (mag: 1, angle: 120deg, colour: orange),
        // (mag: .5, angle: 30deg),
        // (mag: .5, angle: -60deg),
        // (mag: .5, angle: -153deg),
      ),
    ),
  ),
  caption: [Phasor diagram of me testing],
)
