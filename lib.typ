#import "@preview/cetz:0.4.1"
#set page(width: auto, height: auto, margin: .5cm)

#show math.equation: block.with(fill: white, inset: 1pt)

#let phasorPlot = (
  showLabels: true,
  axesLabels: ($Re$, $Im$),
  greyscale: false,
  length: 10em,
  autoHueScale: 4,
  phasors: {},
) => {
  cetz.canvas(
    length: length,
    {
      import cetz.draw: *
      // set text(
      //   size: 15pt,
      // )

      let greatestMag = 0
      for element in phasors {
        if element.mag > greatestMag {
          greatestMag = element.mag
        }
      }
      let xAxis = ()
      let furthestNeg = -(greatestMag)

      // Fix for weird numbers :)
      let furthestNeg = calc.round(furthestNeg)
      let greatestMag = calc.round(greatestMag)

      while (furthestNeg <= greatestMag) {
        let x = furthestNeg
        let ct = $furthestNeg$
        let res = (x, ct)
        xAxis.push(res)
        furthestNeg += 0.5
      }
      set-style(
        mark: (fill: black, scale: .75),
        stroke: (thickness: 0.4pt, cap: "round"),
        angle: (
          radius: 0.3,
          label-radius: .22,
          fill: green.lighten(80%),
          stroke: (paint: green.darken(50%)),
        ),
        content: (padding: 1pt),
      )

      let phasor(mag, angle, traces: false, label: true, colour: none, arcPath: none) = {
        let getColour = (angle, saturation: 100%, value: 75%, alpha: 100%) => {
          if (colour != none) { colour.transparentize(100% - alpha) } else {
            color.hsv(angle * autoHueScale, saturation, if (greyscale) { 0% } else { value }, alpha)
          }
        }

        line(
          (0, 0),
          (mag * calc.cos(angle), mag * calc.sin(angle)),
          mark: (end: "stealth"),
          stroke: { getColour(angle) },
        )
        if traces {
          line(
            (mag * calc.cos(angle), mag * calc.sin(angle)),
            ((), "|-", (0, 0)),
            stroke: (.1em + red.transparentize(30%)),
            name: "sin",
          )
          line("sin.end", (0, 0), stroke: (.1em + blue.transparentize(30%)), name: "cos")
          let xVal = calc.round(mag * calc.cos(angle), digits: 3)
          let yVal = calc.round(mag * calc.sin(angle), digits: 3)
          content(("cos.start", 50%, "cos.end"), text(.5em, fill: blue, $xVal$))
          content(("sin.start", 50%, "sin.end"), text(.5em, fill: red, $yVal$))
        }
        if (label != none) {
          content(
            ((mag * 1.15) * calc.cos(angle), (mag * 1.15) * calc.sin(angle)),
            text(getColour(angle), .8em)[#label],
            anchor: "north",
          )
        }
        if (arcPath != none) {
          arc(
            (
              arcPath.rad * calc.cos(arcPath.start),
              arcPath.rad * calc.sin(arcPath.start),
            ),
            start: arcPath.start,
            stop: arcPath.end,
            radius: arcPath.rad,
            stroke: if (colour != none) { colour } else { getColour(angle) },
            mode: "PIE",
            fill: if (arcPath.doFill != false) { getColour(angle, alpha: 10%) },
          )
          content(
            (
              arcPath.rad * 1.1 * calc.cos(arcPath.end - (arcPath.end - arcPath.start) / 2) + arcPath.labelOffset.x,
              arcPath.rad * 1 * calc.sin(arcPath.end - (arcPath.end - arcPath.start) / 2) + arcPath.labelOffset.y,
            ),
            angle: arcPath.labelOffset.r,
            text(size: .5em)[
              #if (arcPath.label == none) {} else if (arcPath.label == true) {
                repr(arcPath.end - arcPath.start).replace("deg", sym.degree)
              } else {
                arcPath.label
              }
            ],
            anchor: "south",
          )
        }
      }

      grid(
        (-(greatestMag + 0.5), -(greatestMag + 0.5)),
        (
          (greatestMag + 0.5),
          (greatestMag + 0.5),
        ),
        step: 0.25,
        stroke: gray + 0.02em,
      )

      // circle((0,0), radius: 1)

      line((-(greatestMag + 0.5), 0), ((greatestMag + 0.5), 0), mark: (start: "stealth", end: "stealth"))
      content((), axesLabels.at(0), anchor: "west")
      line((0, -(greatestMag + 0.5)), (0, (greatestMag + 0.5)), mark: (start: "stealth", end: "stealth"))
      content((), axesLabels.at(1), anchor: "south")

      for (x, ct) in xAxis {
        line((x, .3em), (x, -.3em))
        content((), anchor: if (x == 0) { "north-east" } else { "north" }, text(.6em, ct))
      }

      for (y, ct) in xAxis {
        if (y != 0) {
          line((3pt, y), (-3pt, y))
          content((), anchor: "east", text(.6em, ct))
        }
      }

      // Draw the green angle

      set-style(stroke: (thickness: 1.2pt))
      // phasor(calc.pi/2)
      // phasor(calc.pi/3)
      for element in phasors {
        if (element.mag == none) {
          element.mag = 1
        }
        if (element.angle == none) {
          element.angle = 45deg
        }
        if ("arc" in element) {
          if (element.arc == true) {
            element.arc = (start: 0deg, end: element.angle, rad: 1em, label: "", doFill: true)
          } else if (element.arc == false) {
            element.arc = none
          } else {
            if ("start" not in element.arc) {
              element.arc.start = 0deg
            }
            if ("end" not in element.arc) {
              element.arc.end = element.angle
            }
            if ("rad" not in element.arc) {
              element.arc.rad = 3em
            }
            if ("label" not in element.arc) {
              element.arc.label = ""
            }
            if ("doFill" not in element.arc) {
              element.arc.doFill = true
            }
            if ("labelOffset" not in element.arc) {
              element.arc.labelOffset.x = 0em
              element.arc.labelOffset.y = 0em
              element.arc.labelOffset.r = 0deg
            }
          }
        }
        phasor(
          element.mag,
          element.angle,
          colour: if ("colour" in element) { element.colour } else { none },
          traces: if ("traces" in element) { element.traces } else { false },
          label: if ("label" in element) { element.label } else {
            if (showLabels == false) { none } else { repr(element.angle).replace("deg", sym.degree) }
          },
          arcPath: if ("arc" in element) { if (element.arc != none) { element.arc } } else {
            none
          },
        )
      }
    },
  )
}
