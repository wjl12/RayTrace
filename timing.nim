import std/strformat
import std/strutils
import std/times
import raytrace
import decimal

let paraxialInitional = ParaxialRayTraceData(u: 0, y: 2, nu: 0, n: 1.00)
let paraxialSurf = Surface(c: 0.1353271, d: 1.05, n: 1.517)

let trace = paraxialSurf.paraxialRayTrace(paraxialInitional)

setPrec(6)

let paraxialSurfaces = @[
    Surface(c: 0.1353271, d: 1.05, n: 1.517),
    Surface(c: -0.1931098, d: 0.4, n: 1.649),
    Surface(c: -0.0616427, d: 0.0, n: 1.000)
]

let lastParaxial = paraxialSurfaces.paraxialRayTrace(paraxialInitional)

let meridionalSurfaces = @[
    Surface(c: 0.1353271, d: 1.05, n: 1.517),
    Surface(c: -0.1931098, d: 0.4, n: 1.649),
    Surface(c: -0.0616427, d: 0.0, n: 1.000)
]

let meridionalSurfaces2 = @[
    Surface(c: 0.1166589, d: 2.4, n: 1.52240),
    Surface(c: -0.1377790, d: 0.4, n: 1.61644),
    Surface(c: 0, d: 7.738, n: 1.00000),
    Surface(c: 0.1743679, d: 1.8, n: 1.51625),
    Surface(c: -0.2626740, d: 0.4, n: 1.61644),
    Surface(c: -0.0592487, d: 0.0, n: 1.00000)
]

let numLoops = 10000000 # 10 million
let meridionalInitional = MeridionalRayTraceData(Q: 2.0, U: 0.0, n: 1.00)
let cpuTimeStart = cpuTime()
var last: MeridionalRayTraceData
for i in 1..numLoops:
    last = meridionalSurfaces.meridionalRayTrace(meridionalInitional)
echo "Focal length=",$(last.L)  # Force evaluation instead of optimizing function out of existence
let cpuTime = cpuTime()-cpuTimeStart
echo "CPU time=",$cpuTime
echo "Ray traces per second=",$(numLoops.toFloat/cpuTime)

# let meridionalInitionalFast = MeridionalRayTraceData(Q: 2.0, U: 0.0, n: 1.00)
# let cpuTimeStartFast = cpuTime()
# for i in 1..numLoops:
#     last = meridionalSurfaces.meridionalRayTraceFast(meridionalInitionalFast)
# echo "Focal length=",$(last.L)  # Force evaluation instead of optimizing function out of existence
# let cpuTimeFast = cpuTime()-cpuTimeStartFast
# echo "Fast CPU time=",$cpuTimeFast
# echo "Ray traces per second=",$(numLoops.toFloat/cpuTimeFast)

# echo "Speedup=",$(100*(cpuTimeSlow-cpuTimeFast)/cpuTimeSlow)