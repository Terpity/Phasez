#import "@preview/cetz:0.4.1"
#set page(width: auto, height: auto, margin: .5cm)

#show math.equation: block.with(fill: white, inset: 1pt)

#let phasorPlot = (
  showLabels: true,
  axesLabels: ($Re$, $Im$),
  fontSize: 8pt,
  xlimits: none,
  ylimits: none,
  scaleFactor: 1,
  greyscale: false,
  length: 5cm,
  autoHueScale: 4,
  step: 0.5,
  gridstep: 0.25,
  phasors: {},
) => {
  text(size: fontSize)[
    #cetz.canvas(
      length: length,


      {
        import cetz.draw: *
        // set text(
        //   size: 15pt,
        // )
        let greatestX = 0
        let smallestX = 0
        let greatestY = 0
        let smallestY = 0
        for element in phasors {
          if element.mag > greatestX {
            greatestX = element.mag
            greatestY = element.mag
          }
        }

        let xAxis = ()
        let yAxis = ()

        let xscale = 1
        let yscale = 1

        if (type(scaleFactor) == dictionary) {
          xscale = if ("x" in scaleFactor) { scaleFactor.x } else { 1 }
          yscale = if ("y" in scaleFactor) { scaleFactor.y } else { 1 }
        } else {
          xscale = scaleFactor
          yscale = scaleFactor
        }

        if (xlimits != none) {
          if type(xlimits) == dictionary {
            if (xlimits.to > xlimits.from) {
              smallestX = xlimits.from
              greatestX = xlimits.to
            } else if (xlimits.to < xlimits.from) {
              smallestX = xlimits.to
              greatestX = xlimits.from
            }
          } else if (type(xlimits) == int or type(xlimits) == float) {
            smallestX = -calc.abs(xlimits)
            greatestX = calc.abs(xlimits)
          }
        } else {
          smallestX = -greatestX
        }

        if (ylimits != none) {
          if type(ylimits) == dictionary {
            if (ylimits.to > ylimits.from) {
              smallestY = ylimits.from
              greatestY = ylimits.to
            } else if (ylimits.to < ylimits.from) {
              smallestY = ylimits.to
              greatestY = ylimits.from
            }
          } else if (type(ylimits) == int or type(ylimits) == float) {
            smallestY = -calc.abs(ylimits)
            greatestY = calc.abs(ylimits)
          }
        } else {
          greatestY = calc.abs(greatestY)
          smallestY = -calc.abs(greatestY)
        }

        // let smallestX = if (xlimits != none) {
        //   if (xlimits.to < xlimits.from) { xlimits.to } else { xlimits.from }
        // } else { calc.round(-(greatestX)) }
        // let greatestX = if (xlimits != none) {
        //   if (xlimits.from > xlimits.to) { xlimits.from } else { xlimits.to }
        // } else { calc.round((greatestX)) }
        // let smallestY = if (ylimits != none) {
        //   if (ylimits.to < ylimits.from) { ylimits.to } else { ylimits.from }
        // } else { calc.round(-(greatestX)) }
        // let greatestY = if (ylimits != none) {
        //   if (ylimits.from > ylimits.to) { ylimits.from } else { ylimits.to }
        // } else { calc.round((greatestX)) }

        // Set default label step values
        let xStep = .5
        let yStep = .5

        // Overwrite them with any user-defined values
        if (type(step) == dictionary) {
          if ("x" in step) {
            xStep = step.x
          }
          if ("y" in step) {
            yStep = step.y
          }
        } else if (type(step) == int or type(step) == float) {
          xStep = step
          yStep = step
        }

        // Generate labels for -x, +x, -y, +y directions by stepping out from zero until reaching the furthest distances

        let negXLabels = ()
        let negXStepper = 0
        while (negXStepper >= smallestX) {
          let x = negXStepper / xscale
          let roundedct = calc.round(negXStepper, digits: 2)
          let ct = $roundedct$
          let res = (x, ct)
          negXLabels.push(res)
          negXStepper -= xStep
        }

        let posXLabels = ()
        let posXStepper = 0
        while (posXStepper <= greatestX) {
          let x = posXStepper / xscale
          let roundedct = calc.round(posXStepper, digits: 2)
          let ct = $roundedct$
          let res = (x, ct)
          posXLabels.push(res)
          posXStepper += xStep
        }

        let negYLabels = ()
        let negYStepper = 0
        while (negYStepper >= smallestY) {
          let y = negYStepper / yscale
          let roundedct = calc.round(negYStepper, digits: 2)
          let ct = $roundedct$
          let res = (y, ct)
          negYLabels.push(res)
          negYStepper -= yStep
        }

        let posYLabels = ()
        let posYStepper = 0
        while (posYStepper <= greatestY) {
          let y = posYStepper / yscale
          let roundedct = calc.round(posYStepper, digits: 2)
          let ct = $roundedct$
          let res = (y, ct)
          posYLabels.push(res)
          posYStepper += yStep
        }


        // let xStepper = smallestX
        // while (xStepper <= greatestX) {
        //   let x = xStepper
        //   let roundedct = calc.round(xStepper, digits: 2)
        //   let ct = $roundedct$
        //   let res = (x, ct)
        //   xAxis.push(res)
        //   xStepper += step
        // }

        // let yStepper = smallestY
        // while (yStepper <= greatestY) {
        //   let y = yStepper
        //   let roundedct = calc.round(xStepper, digits: 2)
        //   let ct = $roundedct$
        //   let res = (y, ct)
        //   yAxis.push(res)
        //   yStepper += 0.5
        // }

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
            (mag * calc.cos(angle) / xscale, mag * calc.sin(angle) / yscale),
            mark: (end: "stealth"),
            stroke: { getColour(angle) },
            name: "phasorLine",
          ))

          if traces {
            line(
              (mag * calc.cos(angle) / xscale, mag * calc.sin(angle) / yscale),
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
                  mag * calc.cos(angle) * length * 1.1 / xscale
                )
                  + labelOffset.x,
                (
                  mag * calc.sin(angle) * length * 1.1 / yscale
                )
                  + labelOffset.y,
              ),
              angle: labelOffset.r,
              text(getColour(angle), .8em)[#prefix#label#suffix],
              anchor: "north",
            )
          }
          if (arcPath != none) {
            group({
              scale(x: 100% / xscale, y: 100% / yscale)
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
            })


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

        group({
          scale(x: 100% /* / xscale*/, y: 100% /* / yscale*/)
          grid(
            (
              0,
              0,
            ),

            (
              greatestX / xscale,
              greatestY / yscale,
            ),
            step: (gridstep / xscale, gridstep / yscale),
            stroke: gray + 0.02em,
          )
        })

        group({
          set-origin((smallestX / xscale, 0, 0))
          scale(x: -100% /* / xscale*/, y: 100% /* / yscale*/)
          // set-origin((0, 0, 0))
          grid(
            (
              0,
              0,
            ),
            (
              smallestX / xscale,
              greatestY / yscale,
            ),
            step: (gridstep / xscale, gridstep / yscale),
            stroke: gray + 0.02em,
          )
          scale(x: 100%, y: 100%)
        })

        // scale(x: -100%, y: -100%)
        group({
          set-origin((smallestX / xscale, smallestY / yscale, 0))
          scale(x: -100% /* / xscale*/, y: -100% /* / yscale*/)
          grid(
            (
              0,
              0,
            ),
            (
              smallestX / xscale,
              smallestY / yscale,
            ),
            step: (gridstep / xscale, gridstep / yscale),
            stroke: gray + 0.02em,
          )
        })
        group({
          set-origin((0, smallestY / yscale, 0))
          scale(x: 100% /* / xscale*/, y: -100% /* / yscale*/)
          grid(
            (
              0,
              0,
            ),
            (
              greatestX / xscale,
              smallestY / yscale,
            ),
            step: (gridstep / xscale, gridstep / yscale),
            stroke: gray + 0.02em,
          )
        })
        // scale(x: 100%, y: 100%)

        // circle((0,0), radius: 1)

        // --- Draws the x axis line ---
        line(
          name: "xAxisLine",
          (
            smallestX / xscale,
            0,
          ),
          (
            greatestX / xscale,
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
            smallestY / yscale,
          ),
          (
            0,
            greatestY / yscale,
          ),
          mark: (start: if (smallestY < 0) { "stealth" }, end: if (greatestY > 0) { "stealth" }),
        )
        content((), axesLabels.at(1), anchor: /*if (greatestY <= 0) { "north" } else {*/ "south" /*}*/)

        for (x, ct) in negXLabels {
          line((x, .3em), (x, -.3em), stroke: if (x == 0) { 0pt } else { .2pt })
          content((), anchor: if (x == 0) { "north-east" } else { "north" }, text(.6em, ct))
        }

        for (x, ct) in posXLabels {
          line((x, .3em), (x, -.3em), stroke: if (x == 0) { 0pt } else { .2pt })
          content((), anchor: if (x == 0) { "north-east" } else { "north" }, text(.6em, ct))
        }

        for (y, ct) in negYLabels {
          if (y != 0) {
            line((3pt, y), (-3pt, y))
            content((), anchor: "east", text(.6em, ct))
          }
        }

        for (y, ct) in posYLabels {
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
    )]
}
