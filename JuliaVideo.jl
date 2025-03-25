using VideoIO, Colors

dur = 60  # duration
wdt = 3840  # linspace width
hgh = 2160  # linspace height
fps = 60  # frame rate
astart = 0  # start angle
aend = 2 * π  # end angle 
r = 0.7885  # radius
nIt = 30  # number of iterations
l = 1.5  # linspace shift
X, Y = meshgrid(linspace(-l, l, wdt), linspace(-l, l, hgh))
VD = VideoWriter("Julia_Set.mp4", "MPEG-4")
VD.fps = fps
open(VD)
SubT = open("Julia_Set.srt", "w")
f = 0

for a in astart + (aend - astart) / (dur * fps):(aend - astart) / (dur * fps):aend
    f += 1
    J, C = JuliaSet(X, Y, a, r, nIt)
    write(VD, frame(J .* 255, colormap=hot(256)))
    CN = string.(C)
    write(SubT, "$(f)\n$(Frame2Time(f, fps)) --> $(Frame2Time(f + 1, fps))\nf(z) = zᶻ $(CN[1]) $(CN[2:8]...) $(CN[9]) $(CN[10:17]...)\n\n")
end

close(VD)
close(SubT)

function JuliaSet(X, Y, a, r, nIt)
    Z = X .+ 1im .* Y
    C = r * cos(a) + 1im * r * sin(a)
    for k in 1:nIt
        Z .= Z .^ 2 .+ C
    end
    J = exp.(-abs.(Z))
    return J, C
end

function Frame2Time(f, fps)
    T = zeros(UInt32, 4)
    fph = 3600 * fps  # frames per hour
    fpm = 60 * fps  # frames per minutes
    fhl = f % fph  # frames excluding hours
    fml = fhl % fpm  # frames excluding minutes and hours
    T[1] = (f - fhl) ÷ fph  # hours
    T[2] = (fhl - fml) ÷ fpm  # minutes
    T[4] = fml % fps  # frames excluding seconds minutes and hours
    T[3] = (fml - T[4]) ÷ fps  # seconds
    return string(T[1], ":", T[2], ":", T[3], ",", lpad(round(999 * Float64(T[4]) / (fps - 1)), 3, "0"))
end
