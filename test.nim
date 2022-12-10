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

let cpuTimeStartParaxial = cpuTime()
let lastParaxial = paraxialSurfaces.paraxialRayTrace(paraxialInitional)
let cpuTimeParaxial = cpuTime()-cpuTimeStartParaxial
echo "Paraxial CPU time=",$cpuTimeParaxial,", traces per second=",$(1.0/cpuTimeParaxial)

try:
    assert newDecimal("11.285856")==newDecimal($lastParaxial.l)
    echo "Paraxial ray trace passed"
except AssertionDefect as e:
    echo "l=",$lastParaxial.l
    echo e.msg

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

let meridionalInitional = MeridionalRayTraceData(Q: 2.0, U: 0.0, n: 1.00)
let cpuTimeStartMeridional = cpuTime()
let lastMeridional = meridionalSurfaces.meridionalRayTrace(meridionalInitional)
let cpuTimeMeridional = cpuTime()-cpuTimeStartMeridional
echo "Meridional CPU time=",$cpuTimeMeridional,", traces per second=",$(1.0/cpuTimeMeridional)

try:
    assert newDecimal("11.293900")==newDecimal($lastMeridional.L)
    echo "Meridional ray trace test passed"
except AssertionDefect as e:
    echo e.msg

let meridionalInitional2 = MeridionalRayTraceData(Q: 3.172, U: 0.0, n: 1.00)
let cpuTimeStartMeridional2 = cpuTime()
let lastMeridional2 = meridionalSurfaces2.meridionalRayTrace(meridionalInitional2)
let cpuTimeMeridional2 = cpuTime()-cpuTimeStartMeridional2
echo "Meridional CPU time=",$cpuTimeMeridional2,", traces per second=",$(1.0/cpuTimeMeridional2)

try:
    assert newDecimal("3.840978")==newDecimal($lastMeridional2.L)
    echo "Meridional ray trace 2 test passed"
except AssertionDefect as e:
    echo "Meridional ray trace 2 test failed: ","L´=",$lastMeridional2.L
    echo e.msg

# let meridionalInitionalFast = MeridionalRayTraceData(Q: 2.0, U: 0.0, n: 1.00)
# let cpuTimeStartFast = cpuTime()
# let lastMeridionalFast = meridionalSurfaces.meridionalRayTraceFast(meridionalInitionalFast)
# echo "Fast CPU time=",$(cpuTime()-cpuTimeStartFast)

# try:
#     assert newDecimal("11.293900")==newDecimal($lastMeridionalFast.L)
#     echo "Fast meridional ray trace test passed"
# except AssertionDefect as e:
#     echo e.msg
