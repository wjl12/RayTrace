import std/sequtils
import std/math

type
    Surface* = object
        ## A surface to refract light through.
        c*: float64
        d*: float64
        n*: float64
    Surfaces* = seq[Surface]
    
    ParaxialRayTraceData* = object
        ## Intermediate data after ray tracing through a surface
        y*: float64
        u*: float64
        nu*: float64
        n*: float64
        l*: float64
    
    MeridionalRayTraceData* = object
        Q*: float64
        U*: float64
        n*: float64
        L*: float64

    LensDesign* = object
        ## holds full optical system
        name*: string
        surfaces*: seq[Surface]

func paraxialRayTrace*(surf: Surface, initial: ParaxialRayTraceData): ParaxialRayTraceData =
    discard """
        traces a paraxial ray through Surface surf
    """
    let φ = (surf.n-initial.n)*surf.c
    result.nu = initial.nu - initial.y * φ
    result.u = result.nu/surf.n
    result.y = initial.y + result.u * surf.d
    result.n = surf.n
    result.l = -result.y/result.nu

func paraxialRayTrace*(surfSeq: Surfaces, initial: ParaxialRayTraceData): ParaxialRayTraceData =
    var transfer = initial
    for s in surfSeq:
        transfer = s.paraxialRayTrace(transfer)
    result = transfer

# func paraxialRayTrace*(design: LensDesign, initial: ParaxialRayTraceData): ParaxialRayTraceData =
#     result = design.surfaces.paraxialRayTrace(initial)

func paraxialFocalLength*(last: ParaxialRayTraceData): float64 =
    result = -last.y/last.nu

func meridionalRayTrace*(surf: Surface, initial: MeridionalRayTraceData): MeridionalRayTraceData =
    discard """
    traces a meridional ray through Surface surf
    """

    # NB: the character "´" is U+00B4, the acute accent
    #       NOT the character "'" (U+0027), the apostrophe
    #
    #     This was neccessary because when the apostrophe is enclosed in backticks, 
    #       Nim still thinks it starts a character literal
    let sinI = initial.Q*surf.c - sin(initial.U)
    let sinI´ = (initial.n/surf.n)*sinI
    let I = arcsin(sinI)
    let cosI = cos(I)

    let I´ = arcsin(sinI´)
    let U´ = initial.U + I - I´

    let cosI´ = cos(I´)
    let sinU´ = sin(U´)
    let cosU´ = cos(U´)

    let G = initial.Q/(cos(initial.U)+cosI)
    let Q´ = G*(cosU´+cosI´)
    let Q₂ = Q´ - surf.d*sinU´
    let L = Q´/sinU´

    result.U = U´
    result.Q = Q₂
    result.n = surf.n
    result.L = L

    # echo "Q= ",initial.Q
    # echo "Q´= ",Q´
    # echo "Q₂= ",Q₂
    # echo "I= ",radToDeg(I)
    # echo "I'= ",radToDeg(I´)
    # echo "U= ",radToDeg(initial.U)
    # echo "U´= ",radToDeg(U´)
    # echo "Q=",Q₂,", U=",radToDeg(U´), ", L= ", L

func meridionalRayTrace*(surfSeq: Surfaces, initial: MeridionalRayTraceData): MeridionalRayTraceData =
    var transfer = initial
    for s in surfSeq:
        transfer = s.meridionalRayTrace(transfer)
    result = transfer

# func `sin(a+b)` (a,b: float64): float64 = sin(a)*cos(b) + cos(a)*sin(b)
# func `cos(a+b)` (a,b: float64): float64 = cos(a)*cos(b) - sin(a)*sin(b)

# func meridionalRayTraceFast*(surf: Surface, initial: MeridionalRayTraceData): MeridionalRayTraceData =
#     discard """
#     traces a meridional ray through Surface surf
#     """

#     # NB: the character "´" is U+00B4, the acute accent
#     #       NOT the character "'" (U+0027), the apostrophe
#     #
#     #     This was neccessary because when the apostrophe is enclosed in backticks, 
#     #       Nim still thinks it starts a character literal
#     let sinI = initial.Q*surf.c - sin(initial.U)
#     let cosI = (1-sinI^2).sqrt
#     let I = arctan2(sinI, cosI)
#     let `sin(U+I)` = `sin(a+b)`(initial.U, I)
#     let `cos(U+I)` = `cos(a+b)`(initial.U, I)

#     let sinI´ = (initial.n/surf.n)*sinI
#     let cosI´ = (1+sinI´^2).sqrt

#     let I´ = arctan2(sinI´, cosI´)
#     let sinU´ = `sin(a+b)`(initial.U+I, -I´)
#     let cosU´ = `cos(a+b)`(initial.U+I, -I´)
#     let U´ = arctan2(sinU´, cosU´)

#     let G = initial.Q/(cos(initial.U)+cosI)
#     let Q´ = G*(cosU´+cosI´)
#     let Q₂ = Q´ - surf.d*sinU´
#     let L = Q´/sinU´

#     result.U = U´
#     result.Q = Q₂
#     result.n = surf.n
#     result.L = L

#     # echo "Q= ",initial.Q
#     # echo "Q´= ",Q´
#     # echo "Q₂= ",Q₂
#     # echo "I= ",radToDeg(I)
#     # echo "I'= ",radToDeg(I´)
#     # echo "U= ",radToDeg(initial.U)
#     # echo "U´= ",radToDeg(U´)
#     # echo "Q=",Q₂,", U=",radToDeg(U´), ", L= ", L

# func meridionalRayTraceFast*(surfSeq: Surfaces, initial: MeridionalRayTraceData): MeridionalRayTraceData =
#     var transfer = initial
#     for s in surfSeq:
#         transfer = s.meridionalRayTraceSlow(transfer)
#     result = transfer

# # func meridionalRayTrace*(design: LensDesign, initial: MeridionalRayTraceData): MeridionalRayTraceData =
# #     result = design.surfaces.meridionalRayTrace(initial)
