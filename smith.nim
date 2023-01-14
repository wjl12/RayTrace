import raytrace
import decimal

let surfaces = @[
    Surface(c: 1.0/37.40, d: 5.90, n: 1.613),
    Surface(c: -1.0/341.48, d: 12.93, n: 1.000),
    Surface(c: -1.0/42.65, d: 2.50, n: 1.648),
    Surface(c: 1.0/36.40, d: 11.85, n: 1.000),
    Surface(c: 1.0/204.52, d: 5.90, n: 1.613),
    Surface(c: -1.0/37.05, d: 0.00, n: 1.000)
]

var transfers = @[ParaxialRayTraceTransfer(u: 0, y: 2, nu: 0, n: 1.00)]
surfaces.paraxialRayTrace(transfers)

transfers.dumpRayTrace