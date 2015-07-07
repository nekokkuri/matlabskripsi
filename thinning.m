function y=thinning(eX, eY, offset)

[m,n]=size(eX);
% crop off the boundary parts...the places where the convolution was partial
sx = eX(offset+1:m-offset, offset+1:n-offset); 
sy = eY(offset+1:m-offset, offset+1:n-offset); 

% norm of gradient
sNorm = sqrt( sx.^2 + sy.^2 );

% direction of gradient
sAngle = atan2( sy, sx) * (180.0/pi);

% handle divide by zero....
sx(sx==0) = eps;
sSlope = abs(sy ./ sx);

sAorig = sAngle;

%for us, x and x-pi are the same....
y = sAngle < 0;
sAngle = sAngle + 180*y;

% bin the angles into 4 principal directions
% 0-45 45-90 90-135 135-180

binDist =    [-inf 45 90 135 inf];

[dummy, b] = histc(sAngle,binDist);

sDiscreteAngles = b;
[m,n] = size(sDiscreteAngles);

% each pixel is set to either 1,2,3 or 4
% set the boundary pixels to 0, so we don't count them in analysis...
sDiscreteAngles(1,:) = 0;
sDiscreteAngles(end,:)=0;
sDiscreteAngles(:,1) = 0;
sDiscreteAngles(:,end) = 0;

sEdgepoints = zeros(m,n);

sFinal = sEdgepoints;

%lowT  = mLow * mean(sNorm(:));
%highT = mHigh * lowT;

%thresh = [ lowT highT];

% NON-MAXIMAL SUPPRESSION

% for each kind of direction, interpolate.... and see if the current point is
% is the local maximum in that direction

%in the following comments, assume that we are currently at (0,0) and
%we have to interpolate from the 8 surrounding pixels, also, we are
%using MATLAB's single index feature...

%gradient direction: 0-45 i.e. gradDir =1
gradDir = 1;
indxs = find(sDiscreteAngles == gradDir);
slp = sSlope(indxs);

% interpolate between (1,1) and (1,0)
% gDiff1 = Gy/Gx*(magtd(0,0) - magtd(1,1)) + (1- Gy/Gx)*(magtd(0,0)-magtd(1,0))
gDiff1 = slp.*(sNorm(indxs)-sNorm(indxs+m+1)) + (1-slp).*(sNorm(indxs)-sNorm(indxs+1));

% interpolate between (-1,-1) and (-1,0)
% gDiff2 = Gy/Gx*(magtd(0,0) - magtd(-1,-1)) +  (1- Gy/Gx)*(magtd(0,0)-magtd(-1,0))
gDiff2 = slp.*(sNorm(indxs)-sNorm(indxs-m-1)) + (1-slp).*(sNorm(indxs)-sNorm(indxs-1));

okIndxs = indxs( gDiff1 >=0 & gDiff2 >= 0);
sEdgepoints(okIndxs) = 1;


%gradient direction: 45-90 i.e. gradDir =2
gradDir = 2;
indxs = find(sDiscreteAngles == gradDir);
invSlp = 1 ./ sSlope(indxs);

% interpolate between (1,1) and (0,1)
% gDiff1 = (Gx/Gy)*(magtd(0,0) - magtd(1,1)) + (1- Gx/Gy)*(magtd(0,0)-magtd(0,1))
gDiff1 =   invSlp.*(sNorm(indxs)-sNorm(indxs+m+1)) + (1-invSlp).*(sNorm(indxs)-sNorm(indxs+m));

% interpolate between (-1,-1) and (0,-1)
% gDiff2 = (Gx/Gy)*(magtd(0,0) - magtd(-1,-1)) + (1- Gx/Gy)*(magtd(0,0)-magtd(0,-1))
gDiff2 =   invSlp.*(sNorm(indxs)-sNorm(indxs-m-1)) + (1-invSlp).*(sNorm(indxs)-sNorm(indxs-m));

okIndxs = indxs( gDiff1 >=0 & gDiff2 >= 0);
sEdgepoints(okIndxs) = 1;



%gradient direction: 90-135 i.e. gradDir =3
gradDir = 3;
indxs = find(sDiscreteAngles == gradDir);
invSlp = 1 ./ sSlope(indxs);

% interpolate between (-1,1) and (0,1)
% gDiff1 = (Gx/Gy)*(magtd(0,0) - magtd(-1,1)) + (1- Gx/Gy)*(magtd(0,0)-magtd(0,1))
gDiff1 =   invSlp.*(sNorm(indxs)-sNorm(indxs+m-1)) + (1-invSlp).*(sNorm(indxs)-sNorm(indxs+m));

% interpolate between (1,-1) and (0,-1)
% gDiff2 = (Gx/Gy)*(magtd(0,0) - magtd(1,-1)) + (1- Gx/Gy)*(magtd(0,0)-magtd(0,-1))
gDiff2 =   invSlp.*(sNorm(indxs)-sNorm(indxs-m+1)) + (1-invSlp).*(sNorm(indxs)-sNorm(indxs-m));

okIndxs = indxs( gDiff1 >=0 & gDiff2 >= 0);
sEdgepoints(okIndxs) = 1;



%gradient direction: 135-180 i.e. gradDir =4
gradDir = 4;
indxs = find(sDiscreteAngles == gradDir);
slp = sSlope(indxs);

% interpolate between (-1,1) and (-1,0)
% gDiff1 = Gy/Gx*(magtd(0,0) - magtd(-1,1)) + (1- Gy/Gx)*(magtd(0,0)-magtd(-1,0))
gDiff1 = slp.*(sNorm(indxs)-sNorm(indxs+m-1)) + (1-slp).*(sNorm(indxs)-sNorm(indxs-1));

% interpolate between (1,-1) and (1,0)
% gDiff2 = Gy/Gx*(magtd(0,0)-magtd(1,-1)) +  (1- Gy/Gx)*(magtd(0,0)-magtd(1,0))
gDiff2 = slp.*(sNorm(indxs)-sNorm(indxs-m+1)) + (1-slp).*(sNorm(indxs)-sNorm(indxs+1));

okIndxs = indxs( gDiff1 >=0 & gDiff2 >= 0);
sEdgepoints(okIndxs) = 1;

y=sNorm.*sEdgepoints;

end
