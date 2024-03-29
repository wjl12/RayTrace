import std/[lists, math, sequtils]
import system/iterators
import decimal128

# Variable names follow those in Rudolf Kingslake, except 
#   distance to next surface, which is designated "t" (instead of "d") 
#   as followed by OPTI-121 at the University of Arizona. The
#   optical path length is then τ=t/n
type BasePrecisionType = float64

type
    Surface* = object
        ## A surface to refract light through.
        c*: BasePrecisionType
        d*: BasePrecisionType
        n*: BasePrecisionType
    Surfaces* = seq[Surface]
    
    RayTraceTransfer* = object
        Q*: BasePrecisionType
        U*: BasePrecisionType
        n*: BasePrecisionType
        L*: BasePrecisionType
    RayTraceTransfers* = seq[RayTraceTransfer]
    RayFan = seq[RayTraceTransfers]

proc rayTrace*(surf: Surface, transfer: RayTraceTransfer): RayTraceTransfer =
    discard """
    traces a meridional ray through Surface surf
    """

    # NB: the character "´" is U+00B4, the acute accent
    #       NOT the character "'" (U+0027), the apostrophe
    #
    #     This was neccessary because when the apostrophe 
    #         is enclosed in backticks, Nim still thinks it 
    #         starts a character literal
    let sinI = transfer.Q*surf.c - sin(transfer.U)
    let sinI´ = (transfer.n/surf.n)*sinI
    let I = arcsin(sinI)
    let cosI = cos(I)

    let I´ = arcsin(sinI´)
    let U´ = transfer.U + I - I´

    let cosI´ = cos(I´)
    let sinU´ = sin(U´)
    let cosU´ = cos(U´)

    let G = transfer.Q/(cos(transfer.U)+cosI)
    let Q´ = G*(cosU´+cosI´)
    let Q₂ = Q´ - surf.d*sinU´
    let L = Q´/sinU´

    result.Q = Q₂
    result.U = U´
    result.n = surf.n
    result.L = L

proc rayTrace*(surfaces: Surfaces, transfers: var RayTraceTransfers): RayTraceTransfer =
    var t: RayTraceTransfer
    for idx in 0..high(surfaces):
        t = rayTrace(surfaces[idx], transfers[idx])
        transfers.add(t)
        # echo $idx,", ",$t
    echo $t
    result = t

proc rayTrace*(surfaces: Surfaces, 
               initial: RayTraceTransfer): RayTraceTransfer =
    var t: RayTraceTransfer = initial
    type
        TransferArray = array[-1..100, RayTraceTransfer]
    var transfers: array[-1..100, RayTraceTransfer]
    transfers[-1] = initial
    for idx in 0..high(surfaces):
        var t = rayTrace(surfaces[idx], transfers[idx-1])
        transfers[idx] = t
    result = transfers[surfaces.high]

proc dumpRayTrace*(transfers: RayTraceTransfers) =
    for idx in 0..high(transfers):
        let Q = newDecimal128(transfers[idx].Q, 10, 6)
        let U = newDecimal128(transfers[idx].U, 10, 6)
        let n = newDecimal128(transfers[idx].n, 10, 6)
        let L = newDecimal128(transfers[idx].L, 10, 6)
        echo $idx, " | ", $Q, " | ", $U, " | ", $n, " | ", L
