x = [.80 .87 .92 .975 1.0];
yECE18 = [0.0 .05 .45 .85  .99];

xENG = [.80 .87 .92 .975];
yBMESE = [0.0 .02 .10 .50];
yCEMMS = [0.0 .05 .45 .85];
yACCEGMN = [0.0 .45 .85 .95];

xx = .80:.001:1;
yyECE18 = spline(x,yECE18,xx);
yyBMSE = spline(xENG,yBMESE,xx);
yyCEMMS = spline(xENG,yCEMMS,xx);
yyACCEGMN = spline(xENG,yACCEGMN,xx);

plot(
% Plot the csplines
  xx,yyBMSE,'--',"linewidth",3,
  xx,yyCEMMS,'-.',"linewidth",3,
  xx,yyACCEGMN,':',"linewidth",3,
%  xx,yyECE18,"linewidth",3,

% Plot the points
  x,yECE18,'o',
  xENG,yBMESE,'+',
  xENG,yACCEGMN,'*',
  xENG,yCEMMS,'x'
);
xlim([.80 1.0]);
ylim([0.0 1.0]);
xlabel ("Admission Average");
ylabel ("Probability of Offer");
title ("Probability of Admission Based on Top 6 Average, 2019 Season");

% This is how i know i had a 2.75% chance of getting into UWaterlooooo for Computer Engineering