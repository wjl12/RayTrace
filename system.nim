import Surface

type
    system* = object
        name*: string = ""
        numSurfaces*: int = 0
        surfaces*: seq[Surface] = @[]

var
    lens = System()

proc name*(s: System, name: string) =
    s.name = name