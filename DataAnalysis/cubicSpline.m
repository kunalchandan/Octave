x = [.85 .87 .92 .975 1.0];
y = [0.0 .05 .45 .85  1.0];
xx = .85:.001:1;
yy = spline(x,y,xx);
plot(x,y,'o',xx,yy)

% This is how i know i had a 2.75% chance of getting into UWaterlooooo for Computer Engineering