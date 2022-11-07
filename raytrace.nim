import std/sequtils

type
    Surface* = object
        c*: float64
        t*: float64
        n*: float64
    Surfaces* = seq[Surface]
    
    RayTraceData* = object
        y*: float64
        u*: float64
        nu*: float64
        n*: float64

    LensDesign* = object
        ## holds full optical system
        name*: string
        surfaces*: seq[Surface]

func rayTrace*(surf: Surface, initial: RayTraceData): RayTraceData =
    discard """
    traces a ray through Surface surf
    """
    let τ = surf.t/surf.n
    let φ = (surf.n-initial.n)*surf.c
    result.nu = initial.nu - initial.y * φ
    result.u = result.nu/surf.n
    result.y = initial.y + result.u * surf.t
    result.n = surf.n

func rayTrace*(surfSeq: Surfaces, initial: RayTraceData): RayTraceData =
    var transfer = initial
    for s in surfSeq:
        transfer = s.rayTrace(transfer)
    result = transfer

func rayTrace*(design: LensDesign, initial: RayTraceData): RayTraceData =
    var transfer = initial
    for s in design.surfaces:
        transfer = s.rayTrace(transfer)
    result = transfer

func focalLength*(last: RayTraceData): float64 =
    result = -last.y/last.nu
