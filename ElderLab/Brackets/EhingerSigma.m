function [returnAnswers, humanResponses, numNoise] = EhingerSigma(numRepBlock, timing)
  %% Timing is the number of milliseconds for the interval between stimulus
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
  inter = 0.01;
  
  %%%%% Experiment Stuff %%%%%%
  ListenChar(2);
  numNoise = 100;
  noiseLength = 10;
  numSecs = 2;%%%% Double check value
  correctAnswers = [];
  responses = [];
  
  %%%%% Drawing Functions %%%%%%
  function rotatedCoords = drawSigma(xCenter, yCenter)
    global window;
    global white;
    coords = [ 000 040 040 020 020 040 040 000 -50 -90 -90 -70 -70 -90 -90 -50;
               000 000 000 080 080 160 160 160 000 000 000 080 080 160 160 160] * .5;
    do
      theta = rand(1)*2*pi;
      t = 2*pi*rand(1);
      u = rand()+rand();
      if u>2
        u -=2;
      endif
      spot = [u*cos(t); u*sin(t)]*yCenter*.5;
      xPos = spot(1);
      yPos = spot(2);
      rotationMatrix = [cos(theta) -sin(theta); sin(theta) cos(theta)];
      rotatedCoords = (rotationMatrix*coords);
      rotatedCoords += spot;
    until(max(rotatedCoords') <= [xCenter yCenter] && min(rotatedCoords') >= [-xCenter -yCenter])
    lineWidthPix = 1;
    Screen('DrawLines', window, rotatedCoords, lineWidthPix, white, [xCenter yCenter], 2);
  endfunction
  
  function drawSigmaRepeat(rotatedCoords)
    global window;
    global white;
    lineWidthPix = 1;
    Screen('DrawLines', window, rotatedCoords, lineWidthPix, white, [xCenter yCenter], 2);
  endfunction

  function rotatedCoords = drawSigmaInvert(xCenter, yCenter)
    global window;
    global white;
    coords = [ 000 040 040 060 060 040 040 000 -50 -90 -90 -110 -110 -90 -90 -50;
               000 000 000 080 080 160 160 160 000 000 000  080  080 160 160 160] * .5;
    do
      theta = rand(1)*2*pi;
      t = 2*pi*rand(1);
      u = rand()+rand();
      if u>2
        u -=2;
      endif
      spot = [u*cos(t); u*sin(t)]*yCenter*.5;
      xPos = spot(1);
      yPos = spot(2);
      rotationMatrix = [cos(theta) -sin(theta); sin(theta) cos(theta)];
      rotatedCoords = (rotationMatrix*coords);
      rotatedCoords += spot;
    until(max(rotatedCoords') <= [xCenter*2 yCenter*2] && min(rotatedCoords') >= [0 0])
    lineWidthPix = 1;
    Screen('DrawLines', window, rotatedCoords, lineWidthPix, white, [-xCenter -yCenter], 2);
  endfunction

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
    lineWidthPix = 1;
    Screen('DrawLines', window, rotatedCoords, lineWidthPix, white, [xCenter yCenter], 2);
  endfunction

  function drawNoise(xCenter, yCenter, number, size)
    for a = 1:number
      drawRandLines(xCenter, yCenter, size)
    endfor
  endfunction

  function [dotXpos, dotYpos] = drawDots(screenXpixels, screenYpixels)
    global window;
    %Colour  =  R G B
    dotColor = [1 1 1];
    dotSizePix = 20;
    dotXpos = rand * screenXpixels;
    dotYpos = rand * screenYpixels;
    Screen('DrawDots', window, [dotXpos dotYpos], dotSizePix, dotColor, [], 2);
  endfunction

  function drawCross(xCenter, yCenter)
    global window;
    global white;
    fixCrossDimPix = 25;
    xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
    yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
    allCoords = [xCoords; yCoords];
    lineWidthPix = 8;
    Screen('DrawLines', window, allCoords, lineWidthPix, white*.5, [xCenter yCenter], 2);
  endfunction
  
  %%%%%%% Display Basic Info %%%%%%%
  Screen('TextSize', window, 20);
  Screen('TextFont', window, 'Ubuntu Mono');
  DrawFormattedText(window, 'Dr.Ehinger "Brackets Experiment" Recreation by Kunal Chandan', xCenter*.20, yCenter*.20, white);
  Screen('TextSize', window, 60);
  DrawFormattedText(window, 'Press "F" if you see the Sigma Shape', xCenter*.20, yCenter*.80, white);
  
  coords = [ 000 040 040 000 000 040 040 000 -50 -90 -90 -50 -50 -90 -90 -50;
             000 000 000 080 080 160 160 160 000 000 000 080 080 160 160 160];
  coords = coords-[100;-100];
  Screen('DrawLines', window, coords, 2, [1 1 1], [xCenter yCenter], 2);
  
  coords = [ 000 040 040 080 080 040 040 000 -50 -90 -90 -130 -130 -90 -90 -50;
             000 000 000 080 080 160 160 160 000 000 000  080  080 160 160 160];
  coords = coords+[100;100];
  Screen('DrawLines', window, coords, 2, [1 1 1], [xCenter yCenter], 2);
  DrawFormattedText(window, 'Press "J" if you see the Hexagon Shape', xCenter*.20, yCenter*.90, white);
  DrawFormattedText(window, 'Press any button to begin', xCenter*.20, yCenter, white);
  Screen('DrawingFinished', window);
  Screen('Flip', window);
  Beeper('low', 0.4, 0.1);
  FlushEvents();
  GetChar();
  FlushEvents();
  %%%%%% INITIALIZE QUEST %%%%%%%%%
  
  beta = 3.5;
  delta=0.01;
  gamma=0.5;
  pThreshold = 0.75;
  tGuess = log2(30);
  tGuessSd = 3;
  q=QuestCreate(tGuess,tGuessSd,pThreshold,beta,delta,gamma);
  tGuess = 2^tGuess;
  %%%%%%% BEGIN experiment LOOP %%%%%%%%%%%%
  for c = 1:numRepBlock
    numNoise = 2^QuestMean(q);
    %%%%%% Drawing %%%%%%%
    sigmaOrNah = randi([0,1]);
    correctAnswers = [correctAnswers, sigmaOrNah];
    %%%%%% IF BLOCK HAS MULTIPLE FLASHES OR 1 %%%%%
    if(timing == 0)
      prev = int32((rand*25) + 25);
      after = 100-prev;
      for a = 1:prev
        tic();
        drawNoise(xCenter, yCenter, numNoise, noiseLength);
        drawCross(xCenter, yCenter);
        Screen('DrawingFinished', window);
        timeRequest = GetSecs()+inter;
        Screen('Flip', window, timeRequest);
        toc();
      endfor
      tic();
      %[dotXpos, dotYpos] = drawDots(screenXpixels, screenYpixels);
      drawCross(xCenter, yCenter);
      if sigmaOrNah
        coordsOfShape = drawSigma(xCenter, yCenter);
      elseif !sigmaOrNah
        coordsOfShape = drawSigmaInvert(xCenter, yCenter);
      endif
      drawNoise(xCenter, yCenter, numNoise, noiseLength);
      Screen('DrawingFinished', window);
      timeRequest = GetSecs()+inter;
      Screen('Flip', window, timeRequest);
      toc();
      for a = 1:after
        tic();
        drawNoise(xCenter, yCenter, numNoise, noiseLength); 
        drawCross(xCenter, yCenter);
        Screen('DrawingFinished', window);
        timeRequest = GetSecs()+inter;
        Screen('Flip', window, timeRequest);
        toc();
      endfor
    else
      prev = int32((rand*25) + 25);
      middle = timing/10;
      after = max(100-prev-middle, 2);
      for a = 1:prev
        tic();
        drawNoise(xCenter, yCenter, numNoise, noiseLength);
        drawCross(xCenter, yCenter);
        Screen('DrawingFinished', window);
        timeRequest = GetSecs()+inter;
        Screen('Flip', window, timeRequest);
        toc();
      endfor
      
      tic();
      drawCross(xCenter, yCenter);
      if sigmaOrNah
        coordsOfShape = drawSigma(xCenter, yCenter);
      elseif !sigmaOrNah
        coordsOfShape = drawSigmaInvert(xCenter, yCenter);
      endif
      drawNoise(xCenter, yCenter, numNoise, noiseLength);
      Screen('DrawingFinished', window);
      timeRequest = GetSecs()+inter;
      Screen('Flip', window, timeRequest);
      toc();
      
      for a = 1:middle
        tic();
        drawNoise(xCenter, yCenter, numNoise, noiseLength); 
        drawCross(xCenter, yCenter);
        Screen('DrawingFinished', window);
        timeRequest = GetSecs()+inter;
        Screen('Flip', window, timeRequest);
        toc();
      endfor
      
      tic();
      drawSigmaRepeat(coordsOfShape);
      drawNoise(xCenter, yCenter, numNoise, noiseLength);
      Screen('DrawingFinished', window);
      timeRequest = GetSecs()+inter;
      Screen('Flip', window, timeRequest);
      toc();
      
      for a = 1:after
        tic();
        drawNoise(xCenter, yCenter, numNoise, noiseLength); 
        drawCross(xCenter, yCenter);
        Screen('DrawingFinished', window);
        timeRequest = GetSecs()+inter;
        Screen('Flip', window, timeRequest);
        toc();
      endfor
    endif
    drawCross(xCenter, yCenter);
    Screen('DrawingFinished', window);
    timeRequest = GetSecs()+inter;
    Screen('Flip', window, timeRequest);
    FlushEvents();
    isGoodKey = false;
    %Move on if you got some valid input
    while ! isGoodKey
      button = int32(GetChar());
      if (button == 113)%q Key
        sca;
        clear all;
      endif
      numNoise = log2(numNoise);
      %%% Check answer
      if (sigmaOrNah && (button == 102))%F Key
        Beeper('med', 0.4, 0.1);
        q = QuestUpdate(q,numNoise,0);
      elseif ((!sigmaOrNah) && (button == 106))%J Key
        Beeper('med', 0.4, 0.1);
        q = QuestUpdate(q,numNoise,0);
      else
        Beeper('high', 0.4, 0.3);
        q = QuestUpdate(q,numNoise,1);
      endif
      if(button == 102)
        responses = [responses, 1];
      elseif (button == 106)
        responses = [responses, 0];
      endif
      if(button == 102 || button == 106)
        isGoodKey = true;
      endif
    endwhile
  endfor
  numNoise = 2^QuestMean(q);
  returnAnswers = correctAnswers;
  humanResponses = responses;
  %%%%% Save to file %%%%%%%
  fileID = fopen(strcat(strftime ("%Y-%m-%d_%H:%M:%S", localtime(time())), 'KC.txt'),'w');
  fprintf(fileID, '%.5f\n',numNoise);
  fprintf(fileID, '%d %d\n',[returnAnswers; humanResponses]);
  fclose(fileID);
  %%%% Quit %%%%
  ListenChar(1);
  sca;
  Priority(0);
  %clear all;%%%%%%%%%%%%%%% THIS LINE IS IMPORTANT IF YOU WANT TO LISTEN TO MUSIC %%%%%%%
 endfunction