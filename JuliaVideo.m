dur = 60; % duration
wdt = 3840; % linspace width
hgh = 2160; % linspace height
fps = 60; % frame rate
astart = 0; % start angle
aend = 2*pi; % end angle 
r = 0.7885; % radius
nIt = 30; % number of iterations
l = 1.5; % linspace shift
[X, Y] = meshgrid(linspace(-l, l, wdt), linspace(-l, l, hgh));
VD = VideoWriter('Julia_Set','MPEG-4');
VD.FrameRate = fps;
VD.Quality = 100;
open(VD);
SubT = fopen('Julia_Set.srt','w');
f = 0;
for a = astart+(aend-astart)/(dur*fps):(aend-astart)/(dur*fps):aend
    %a/(aend-astart)
    f = f + 1;
    [J, C] = JuliaSet(X, Y, a, r, nIt);
    writeVideo(VD, im2frame(uint8(J.*255), turbo(256)));
    CN = num2str(C,'%+1.5f');
    fprintf(SubT, strcat(num2str(f), 10, Frame2Time(f, fps), ' -->', 32, Frame2Time(f+1, fps), 10,'f(z) = zᶻ', 32, CN(1), 32, CN(2:8), 32,CN(9), 32, CN(10:17), 10, 10));
end

close(VD);
fclose(SubT);

function [J, C] = JuliaSet(X, Y, a, r, nIt)
    Z = X + 1i*Y;
    C = r.*cos(a) + 1i.*r.*sin(a);
    for k = 1 : nIt
        Z = Z.^2+C;
        J = exp(-abs(Z));
    end
end

function cTime = Frame2Time(f, fps)
    T = uint32(zeros(1, 4));
    fph = 3600*fps; % frames per hour
    fpm = 60*fps; % frames per minutes
    fhl = mod(f, fph); % frames excluding hours
    fml = mod(fhl, fpm); % frames excluding minutes and hours
    T(1) = (f - fhl)/fph; % hours
    T(2) = (fhl - fml)/fpm; % minutes
    T(4) = mod(fml, fps); % frames excluding seconds minutes and hours
    T(3) = (fml - T(4))/fps; % seconds
    cTime = strcat(num2str(T(1),'%02.0f'),':',num2str(T(2),'%02.0f'),':',num2str(T(3),'%02.0f'),',', num2str(round(999*double(T(4))/(fps-1)),'%03.0f'));
end
