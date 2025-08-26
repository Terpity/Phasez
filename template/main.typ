#import "../lib.typ" as phasez

#figure(
  phasez.phasorPlot(
    length: 4cm,
    phasors: (
      (mag: 1, angle: 45deg),
    ),
  ),
  caption: [The most basic phasor diagram],
)

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

#figure(
  phasez.phasorPlot(
    xlimits: .9,
    ylimits: .6,
    step: .24,
    autoHueScale: 5,
    greyscale: true,
    length: 6cm,
    phasors: (
      // (
      //   mag: 0.45,
      //   angle: 75deg,
      //   arc: (
      //     label: [Custom label],
      //     labelOffset: (x: 0pt, y: 5pt, r: -45deg),
      //   ),
      // ),
      (mag: 1, angle: 45deg, colour: orange, label: none, arc: (start: 180deg, colour: red, rad: .6cm)),
    ),
  ),
  caption: [Phasor diagram of me testing],
)

#pagebreak(weak: true)

#figure(
  phasez.phasorPlot(
    autoHueScale: 5,
    greyscale: true,
    step: 10,
    gridstep: 5,
    fontSize: 20pt,
    length: 7cm,
    phasors: (
      (mag: 50, angle: 45deg, colour: orange, label: none, arc: (start: 180deg, colour: red, rad: .6cm)),
    ),
  ),
  caption: [],
)

