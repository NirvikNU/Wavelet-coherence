function [dx,dy] = determinearrow(axhandle)
% Get the data aspect ratio of the y and x axis
dataaspectratio = get(axhandle,'DataAspectRatio');
axesposition = get(axhandle,'position');
widthheight = axesposition(3:4);
ar = widthheight./dataaspectratio(1:2);

ar(2)=ar(1)/ar(2);
ar(1)=1;

xlim = axhandle.XLim;
dxlim = xlim(2)-xlim(1);

dx=ar(1).*0.02*dxlim;
dy=ar(2).*0.02*dxlim;
end