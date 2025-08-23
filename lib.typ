#import "@preview/cetz:0.4.1"
#set page(width: auto, height: auto, margin: .5cm)

#show math.equation: block.with(fill: white, inset: 1pt)

#let phasorPlot = (
  showLabels: true,
  axesLabels: ($Re$, $Im$),
  xlimits: none,
  ylimits: none,
  greyscale: false,
  length: 5cm,
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
      let greatestX = 0
      for element in phasors {
        if element.mag > greatestX {
          greatestX = element.mag
        }
      }

      let xAxis = ()
      let yAxis = ()

      let smallestX = if (xlimits != none) { xlimits.from } else { calc.round(-(greatestX)) }
      let greatestX = if (xlimits != none) { xlimits.to } else { calc.round((greatestX)) }
      let smallestY = if (ylimits != none) { ylimits.from } else { calc.round(-(greatestX)) }
      let greatestY = if (ylimits != none) { ylimits.to } else { calc.round((greatestX)) }

      let xStepper = smallestX
      while (xStepper <= greatestX) {
        let x = xStepper
        let ct = $xStepper$
        let res = (x, ct)
        xAxis.push(res)
        xStepper += 0.5
      }

      let yStepper = smallestY
      while (yStepper <= greatestY) {
        let y = yStepper
        let ct = $yStepper$
        let res = (y, ct)
        yAxis.push(res)
        yStepper += 0.5
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

      let phasor(
        mag,
        angle,
        traces: false,
        prefix: none,
        label: true,
        suffix: none,
        colour: none,
        arcPath: none,
        labelOffset: none,
      ) = {
        let getColour = (angle, saturation: 100%, value: 75%, alpha: 100%) => {
          if (colour != none) { colour.transparentize(100% - alpha) } else {
            color.hsv(angle * autoHueScale, saturation, if (greyscale) { 0% } else { value }, alpha)
          }
        }
        on-layer(1, line(
          (0, 0),
          (mag * calc.cos(angle), mag * calc.sin(angle)),
          mark: (end: "stealth"),
          stroke: { getColour(angle) },
          name: "phasorLine",
        ))

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
            // ("phasorLine.start",110%,"phasorLine.end"),
            (
              (
                mag * calc.cos(angle) * length * 1.1
              )
                + labelOffset.x,
              (
                mag * calc.sin(angle) * length * 1.1
              )
                + labelOffset.y,
            ),
            text(getColour(angle), .8em)[#prefix#label#suffix],
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
            stroke: if (arcPath.colour != none) { arcPath.colour } else if (colour != none) {
              colour
            } else { getColour(angle) },
            mode: "PIE",
            fill: if (arcPath.doFill != false) {
              if (arcPath.colour != none) {
                arcPath.colour.transparentize(90%)
              } else {
                getColour(angle, alpha: 10%)
              }
            },
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
        (
          if (xlimits != none) { xlimits.from } else { -(greatestX + 0.5) },
          if (ylimits != none) { ylimits.from } else { -(greatestX + 0.5) },
        ),
        (
          if (xlimits != none) { xlimits.to } else { greatestX + 0.5 },
          if (ylimits != none) { ylimits.to } else { greatestX + 0.5 },
        ),
        step: 0.25,
        stroke: gray + 0.02em,
      )

      // circle((0,0), radius: 1)

      // --- Draws the x axis line ---
      line(
        name: "xAxisLine",
        (
          if (xlimits != none) { xlimits.from } else { -(greatestX + 0.5) },
          0,
        ),
        (
          if (xlimits != none) { xlimits.to } else { (greatestX + 0.5) },
          0,
        ),
        mark: (start: if (smallestX < 0) { "stealth" }, end: if (greatestX > 0) { "stealth" }),
      )
      content((), axesLabels.at(0), anchor: "west")

      // --- Draws the y axis line ---
      line(
        name: "yAxisLine",
        (
          0,
          if (ylimits != none) { ylimits.from } else { -(greatestX + 0.5) },
        ),
        (
          0,
          if (ylimits != none) { ylimits.to } else { (greatestX + 0.5) },
        ),
        mark: (start: if (smallestY < 0) { "stealth" }, end: if (greatestY > 0) { "stealth" }),
      )
      content((), axesLabels.at(1), anchor: /*if (greatestY <= 0) { "north" } else {*/ "south" /*}*/)

      for (x, ct) in xAxis {
        line((x, .3em), (x, -.3em), stroke: if (x == 0) { 0pt } else { .2pt })
        content((), anchor: if (x == 0) { "north-east" } else { "north" }, text(.6em, ct))
      }

      for (y, ct) in yAxis {
        if (y != 0) {
          line((3pt, y), (-3pt, y))
          content((), anchor: "east", text(.6em, ct))
        }
      }


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
              element.arc.labelOffset = (x: 0em, y: 0em, r: 0deg)
            }
            if ("colour" not in element.arc) {
              element.arc.colour = none
            }
          }
        }

        phasor(
          element.mag,
          element.angle,
          colour: if ("colour" in element) { element.colour } else { none },
          traces: if ("traces" in element) { element.traces } else { false },
          label: if ("label" in element) {
            if (element.label == true) {
              [$#repr(element.mag)angle #repr(element.angle).replace("deg", sym.degree)$]
            } else {
              if (showLabels == false) { none } else {
                element.label
              }
            }
          } else {},
          arcPath: if ("arc" in element) { if (element.arc != none) { element.arc } } else {
            none
          },
          labelOffset: if ("labelOffset" in element) {
            (
              x: if ("x" in element.labelOffset) { element.labelOffset.x } else { 0pt },
              y: if ("y" in element.labelOffset) { element.labelOffset.y } else { 0pt },
              r: if ("r" in element.labelOffset) { element.labelOffset.r } else { 0deg },
            )
          } else {
            (x: 0pt, y: 0pt, r: 0deg)
          },
          prefix: if ("prefix" in element) {
            element.prefix
          } else { none },
          suffix: if ("suffix" in element) {
            element.suffix
          } else { none },
        )
      }
    },
  )
}
