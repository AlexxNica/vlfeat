function P = click(N,varargin) ;
% CLICK  Click a point
%  P=CLICK() let the user click a point in the current figure and
%  returns its coordinates in P. The user can abort the operation
%  by pressing any key, in which case the empty matrix is returned.
%
%  P=CLICK(N) lets the user select N points in a row. The user can
%  stop inserting points by pressing any key, in which case the
%  partial list is returned.
%
%  CLICK(V,N,'Opt',val,...) accepts the following options:
%
%    'PlotMarker' [0]
%      Put a marker as points are selected. The markers are
%      deleted on exiting the function.
%
%  See also CLICKPOINT().

% AUTORIGHTS
% Copyright 2007 (c) Andrea Vedaldi and Brian Fulkerson
% 
% This file is part of VLFeat, available in the terms of the GNU
% General Public License version 2.

plot_marker = 0 ;
for k=1:2:length(varargin)
  switch lower(varargin{k}) 
    case 'plotmarker'
      plot_marker = varargin{k+1} ;
    otherwise
      error(['Uknown option ''', varargin{k}, '''.']) ;
  end
end

if nargin < 1
  N=1;
end

% --------------------------------------------------------------------
%                                                               Do job
% --------------------------------------------------------------------

fig = gcf ;

is_hold = ishold ;
hold on ;

bhandler = get(fig,'WindowButtonDownFcn') ;
khandler = get(fig,'KeyPressFcn') ;
pointer  = get(fig,'Pointer') ;

set(fig,'WindowButtonDownFcn',@click_handler) ;
set(fig,'KeyPressFcn',@key_handler) ;
set(fig,'Pointer','crosshair') ;

P=[] ;
h=[] ;
data.exit=0;
guidata(fig,data) ;
while size(P,2) < N
  uiwait(fig) ;
  data = guidata(fig) ;
  if(data.exit)
    break ;
  end
  P = [P data.P] ;
  if( plot_marker ) 
    h=[h plot(data.P(1),data.P(2),'rx')] ;
  end
end
  
if ~is_hold
  hold off ;  
end

if( plot_marker )
  pause(.1);
  delete(h) ;
end

set(fig,'WindowButtonDownFcn',bhandler) ;
set(fig,'KeyPressFcn',khandler) ;
set(fig,'Pointer',pointer) ;

% ====================================================================
function click_handler(obj,event)
% --------------------------------------------------------------------
data = guidata(gcbo) ;

P = get(gca, 'CurrentPoint') ;
P = [P(1,1); P(1,2)] ;

data.P = P ;
guidata(obj,data) ;
uiresume(gcbo) ;

% ====================================================================
function key_handler(obj,event)
% --------------------------------------------------------------------
data = guidata(gcbo) ;
data.exit = 1 ;
guidata(obj,data) ;
uiresume(gcbo) ;