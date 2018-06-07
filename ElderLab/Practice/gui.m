function gui
  f = figure('Visible','on','Position',[360,500,450,285]);
  htext = uicontrol('Style','text','String','Select Data','Position',[325,90,60,15]);
  hpopup = uicontrol('Style','popupmenu','String',{'Peaks','Membrane','Sinc'}, 'Position',[300,50,100,25]);
endfunction