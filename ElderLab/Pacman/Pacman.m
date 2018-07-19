function [returnAnswers, humanResponses] = Pacman(numRepBlock, timing)
  more off;
  close all;
  %%%%%% Screen Init %%%%%%%
  PsychDefaultSetup(2);
  Screen('Preference','SkipSyncTests', 1);
  Screen('Preference','VisualDebugLevel', 0);
  screens = Screen('Screens');
  endSc = max(screens);
  global white = 0;
  global black = 1;
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
  inter = 0.1;
  
  %%%%% Experiment Stuff %%%%%%
  ListenChar(2);
  numSecs = 2;%%%%%%%% Double check value
  correctAnswers = [];
  responses = [];
  centerDist = 400;
  circleSize = centerDist-300;
  startAngle = 180;
  arcAngle = 270;
  noiseAngle = 20;
  rect = [[xCenter-centerDist yCenter-centerDist xCenter-circleSize yCenter-circleSize],
          [xCenter+circleSize yCenter-centerDist xCenter+centerDist yCenter-circleSize],
          [xCenter+circleSize yCenter+circleSize xCenter+centerDist yCenter+centerDist],
          [xCenter-centerDist yCenter+circleSize xCenter-circleSize yCenter+centerDist]];
  
  %%%%% Drawing Functions %%%%%%
  
  function drawPacRepeat(rotatedCoords)
    global window;
    global white;
    lineWidthPix = 1;
    Screen('DrawLines', window, rotatedCoords, lineWidthPix, white, [xCenter yCenter], 2);
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
  DrawFormattedText(window, '"Steareoscopic surface interpolation from Illusory contours" Recreation by Kunal Chandan', xCenter*.20, yCenter*.20, white);
  Screen('TextSize', window, 60);
  DrawFormattedText(window, 'Press "F" if you see the tall shape', xCenter*.20, yCenter*.80, white);
  
  DrawFormattedText(window, 'Press "J" if you see the wide shape', xCenter*.20, yCenter*.90, white);
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
  tGuess = log2(8);
  tGuessSd = 3;
  q=QuestCreate(tGuess,tGuessSd,pThreshold,beta,delta,gamma);
  %%%%%%% BEGIN experiment LOOP %%%%%%%%%%%%
  for c = 1:numRepBlock
    numNoise = 2^QuestMean(q);
    %%%%%% Drawing %%%%%%%
    tallOrNah = randi([0,1]);
    correctAnswers = [correctAnswers, tallOrNah];
    tic();
    if(tallOrNah)
      for b = 1:4
        startAngle = (b-1)*90 + 180;
        if(mod(b,2) == 1)
          startAngle-=tGuess;
        elseif(mod(b,2) == 0)
          startAngle+=tGuess;
        endif
        Screen('FillArc',window, white, rect(b,:,:), startAngle, arcAngle)
      endfor
    elseif(!tallOrNah)
      for b = 1:4
        startAngle = (b-1)*90 + 180;
        if(mod(b,2) == 0)
          startAngle-=tGuess;
        elseif(mod(b,2) == 1)
          startAngle+=tGuess;
        endif
        Screen('FillArc',window, white, rect(b,:,:), startAngle, arcAngle)
      endfor
    endif
    drawCross(xCenter, yCenter);
    timeRequest = GetSecs()+inter;
    Screen('Flip', window, timeRequest);
    toc();
    
    tic();
    for b = 1:4
      anAngle = rand()*90;
      for d = 1:4
        Screen('FillArc',window, white, rect(b,:,:), anAngle, noiseAngle)
        anAngle+=90;
      endfor
    endfor
    drawCross(xCenter, yCenter);
    timeRequest = GetSecs()+inter;
    Screen('Flip', window, timeRequest);
    toc();
    
    drawCross(xCenter, yCenter);
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
      if (tallOrNah && (button == 102))%F Key
        Beeper('med', 0.4, 0.1);
        q = QuestUpdate(q,numNoise,1);
      elseif ((!tallOrNah) && (button == 106))%J Key
        Beeper('med', 0.4, 0.1);
        q = QuestUpdate(q,numNoise,1);
      else
        Beeper('high', 0.4, 0.3);
        q = QuestUpdate(q,numNoise,0);
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
  fprintf(fileID, '%d%2d\n',[returnAnswers; humanResponses]);
  fclose(fileID);
  %%%% Quit %%%%
  ListenChar(1);
  sca;
  Priority(0);
  clear all;%%%%%%%%%%%%%%% THIS LINE IS IMPORTANT IF YOU WANT TO LISTEN TO MUSIC %%%%%%% [a,b] = Pacman(10,10)
 endfunction