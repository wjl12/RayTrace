
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
