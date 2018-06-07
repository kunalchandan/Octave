more off;
close all;
%%%%%% Screen Init %%%%%%%
PsychDefaultSetup(2);
Screen('Preference','SkipSyncTests', 1);
Screen('Preference','VisualDebugLevel', 0);
screens = Screen('Screens');
endSc = max(screens);
global white = 1;
global black = 0;
global windowRect
global window
[window, windowRect] = PsychImaging('OpenWindow', endSc, black);
[xCenter, yCenter] = RectCenter(windowRect);
[xPix, yPix] = Screen('WindowSize', window);
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

global newScreen = zeros(yPix, xPix)

  function drawLine(x1, y1, x2, y2)
    global newScreen;
    global white ;
    m = (x1-x2)/(y1-y2);
    if (m <= 1 || m >= -1)
      b = y1 - x1*m;
      for x = min(x1,x2):0.01:max(x1,x2)
        newScreen(uint32(x),uint32(m*x + b)) = white;
      endfor
    else
      m = (y1-y2)/(x1-x2);
      b = x1 - y1*m;
      for y = min(x1,x2):0.01:max(x1,x2)
        newScreen(uint32(y),uint32(m*y + b)) = white;
      endfor
    endif
  endfunction

  function drawRandLines(xCenter, yCenter, len)
    global newScreen;
    coords = [0 len;0 len];
    theta = rand(1)*2*pi;
    t = 2*pi*rand(1);
    u = rand()+rand();
    if u>2
      u -=2;
    endif
    spot = [u*cos(t); u*sin(t)]*yCenter*.6;
    rotationMatrix = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    rotatedCoords = (rotationMatrix*coords);
    rotatedCoords += spot;
    rotatedCoords += [xCenter;yCenter];
    drawLine(rotatedCoords(1,1), rotatedCoords(2,1), rotatedCoords(1,2), rotatedCoords(2,2));
  endfunction

  function drawNoise(xCenter, yCenter, number, len)
    for a = 1:number
      drawRandLines(xCenter, yCenter, len)
    endfor
  endfunction

ifi = Screen('GetFlipInterval', window)
drawNoise(xCenter, yCenter, 10, 10);
newScreen;
screenTex = Screen('MakeTexture', window, newScreen);

Screen('DrawTextures', window, screenTex);

Screen('Flip', window);


KbStrokeWait;
sca;