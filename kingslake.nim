import std/[sequtils, strformat, strutils, times]
import raytrace

# Surface data from "Lens Design Fundamentals", 1st ed. Rudolf Kingslake, p. 28
let surfaces = @[
    Surface(c: 0.1353271, d: 1.05, n: 1.517),
    Surface(c: -0.1931098, d: 0.4, n: 1.649),
    Surface(c: -0.0616427, d: 0.0, n: 1.000)
]

let diameter = 4.0
let field = 1.0

# echo "========= paraxial ========="
# echo "meridional ray"
# var paraxialMeridional = @[ParaxialRayTraceTransfer(y: 2, u: 0, nu: 0, n: 1.00)]
# surfaces.rayTrace(paraxialMeridional)
# paraxialMeridional.dumpRayTrace

# echo "chief ray"
# var paraxialChiefRay = @[ParaxialRayTraceTransfer(y: 0, u: 0.0174550649, nu: 0.0174550649, n: 1.00)]
# surfaces.rayTrace(paraxialChiefRay)
# paraxialChiefRay.dumpRayTrace

# echo "========= meridional ========="
# echo "meridional ray"
# @[MeridionalRayTraceTransfer(Q: 2, U: 0, n: 1.00)]
# surfaces.rayTrace(meridionalMeridional)
# meridionalMeridional.dumpRayTrace

# var meridionalChiefRay = @[MeridionalRayTraceTransfer(Q: 0, U: 0.0174550649, n: 1.00)]
# surfaces.rayTrace(meridionalChiefRay)
# meridionalChiefRay.dumpRayTrace

var initial: RayTraceTransfer
var height: float64
let semiDiameter = diameter/2.0

var transfers: RayTraceTransfers;
var longitudinalIntercept: array[0..999, float64]
var sphericalAberration: array[0..999, float64]
echo "i, longitudinalIntercept, sphericalAberration"
for i in 0 .. 999:
    height = i.toFloat*semiDiameter/1000.0
    initial = RayTraceTransfer(Q: height, U: 0, n: 1.00)
    longitudinalIntercept[i] = rayTrace(surfaces,initial).L
    sphericalAberration[i] = longitudinalIntercept[i] - longitudinalIntercept[1]
    echo i,"\t",longitudinalIntercept[i],"\t",sphericalAberration[i]


# echo longitudinalIntercept[0],", ",longitudinalIntercept[999]

    # if i == 0:
    #     echo $transfers
    #     break
    # # let
    #     last: RayTraceTransfer = transfers[transfers.len]
    #     l = last.L
    # var
    #     LA: seq[float64] = @[]
    # for i in 0 .. rays.len:
    #     LA[i] = rays[i].L - l
    #     echo i,": ", LA[i]



