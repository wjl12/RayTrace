import std/strformat
import std/strutils
import surface

let initial = RayTraceData(u: 0, y: 2, nu: 0, n: 1.00)
let surf = Surface(c: 0.1353271, t: 1.05, n: 1.517)

let trace = surf.raytrace(initial)

assert cmpIgnoreCase(fmt"{trace.nu:>9.7f}", "-0.1399282")==0
assert cmpIgnoreCase(fmt"{trace.y:>9.7f}", "1.9031479")==0

let surfaces = @[
    Surface(c: 0.1353271, t: 1.05, n: 1.517),
    Surface(c: -0.1931098, t: 0.4, n: 1.649),
    Surface(c: -0.0616427, t: 0.0, n: 1.000)
]

let last = surfaces.rayTrace(initial)
assert cmpIgnoreCase(fmt"{last.nu:>9.7f}", "-0.1666665")==0
assert cmpIgnoreCase(fmt"{last.y:>9.7f}", "1.8809730")==0
assert cmpIgnoreCase(fmt"{focalLength(last):>9.6f}", "11.285852")==0
