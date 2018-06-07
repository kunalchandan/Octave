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
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

%%% TIMING %%%
%flipInterval = Screen('GetFlipInterval', window);
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);
inter = 0.03;

%%%%% Experiment Stuff %%%%%%
ListenChar(2);
numNoise = 100;
numSecs = 2;
correctAnswers = [];
responses = [];

%%%%% Drawing Functions %%%%%%
function drawRandLines(xCenter, yCenter, size)
  global window;
  global white;
  coords = [0 size;0 size];
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
  lineWidthPix = 2;
  Screen('DrawLines', window, rotatedCoords, lineWidthPix, white, [xCenter yCenter], 2);
endfunction

function drawNoise(xCenter, yCenter, number, size)
  for a = 1:number
    drawRandLines(xCenter, yCenter, size)
  endfor
endfunction

drawNoise(xCenter, yCenter, 20, 5);
ListenChar(1);
sca;
Priority(0);
%clear all;%%%%%%%%%%%%%%% THIS LINE IS IMPORTANT IF YOU WANT TO LISTEN TO MUSIC %%%%%%%