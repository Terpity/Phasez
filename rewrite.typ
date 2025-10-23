#import "@preview/elembic:1.1.1" as e
#import "@preview/cetz:0.4.1"
#set page(width: auto, height: auto, margin: .5cm)
#show math.equation: block.with(fill: white, inset: 1pt)
#import cetz.draw: *


#let position = e.types.declare(
  "position",
  prefix: "@local/phasez,v1",
  doc: "A pair of (x,y) position coordinates",
  fields: (
    e.field("x", e.types.union(int, float), doc: "The horizontal x coordinate of the position", required: true),
    e.field("y", e.types.union(int, float), doc: "The vertical y coordinate of the position", required: true),
  ),
  casts: ((from: dictionary),),
)

#let phasor = e.types.declare(
  "phasor",
  prefix: "@local/phasez,v1",
  doc: "A phasor, to be placed onto a plot",
  fields: (
    e.field("key", str, doc: "A key for you to refer to, useful for chaining phasors. Must be unique", required: true),
    e.field("mag", float, doc: "The phasor magnitude", required: true),
    e.field("angle", angle, doc: "The phasor angle, from zero", required: true),
    e.field("origin", e.types.union(position), default: (0, 0)),
    e.field("end", e.types.union(position, none), default: none),
  ),
)

#let plot = e.element.declare(
  "plot",
  prefix: "@local/phasez,v1",
  doc: "A phasor plot, able to be styled and ready to plot some phasors!",
  display: it => [
    #cetz.canvas(
      length: it.width,
      {
        for phasor in it.phasors {
          group(
            name: phasor.key,
            {
              let endPoint = if (phasor.end != none) { phasor.end } else { (0, 0) }
              line((phasor.origin.x, phasor.origin.y), (endPoint.x, endPoint.y))
            },
          )
        }
      },
    )
  ],
  fields: (
    e.field("width", length, doc: "Width of the graph as a length", default: 5cm),
    e.field("step", float, doc: "The step size for ticks", default: 0.5),
    e.field("phasors", e.types.array(phasor)),
  ),
)

#plot(step: 2, phasors: (phasor("a", 1, 10deg, end: (1, 1)),))


