function y=hyst(norm, lowT, highT)

%HYSTERESIS PART...

sEdgepoints=(norm>0);

sEdgepoints = sEdgepoints*0.6;
x = find(sEdgepoints > 0 & sNorm < lowT);
sEdgepoints(x)=0;
x = find(sEdgepoints > 0 & sNorm  >= highT);
sEdgepoints(x)=1;

%sFinal(sEdgepoints>0)=1;

%at this point, if 
%    sNorm(pixel) > lowT then sEdgepoints(pixel)=0
%    highT > sNorm(pixel) > lowT then sEdgepoints(pixel)=0.6
%    sNorm(pixel) > highT then sEdgepoints(pixel)=1

% the idea is this: along the neighbouring pixels in that direction
% add 0.4...so all points that were 0.6 will become 1.0
% see if the number of 1's has changed...
% keep doing while number of 1's doesn't change

oldx = [];
x = find(sEdgepoints==1);
while (size(oldx,1) ~= size(x,1))
  oldx = x;
  v = [x+m+1, x+m, x+m-1, x-1, x-m-1, x-m, x-m+1, x+1];
  sEdgepoints(v) = 0.4 + sEdgepoints(v);
  y = find(sEdgepoints==0.4);
  sEdgepoints(y) = 0;
  y = find(sEdgepoints>=1);
  sEdgepoints(y)=1;
  x = find(sEdgepoints==1);
end
		   
x = find(sEdgepoints==1);

sFinal(x)=1;


end
