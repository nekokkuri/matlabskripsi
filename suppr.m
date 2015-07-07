function y=suppr(eX, eY)
	%grt=atan(abs(eY)./abs(eX));
	grt=atan(eY./eX);
	grf=grt./(atan(1));
	gr=round(grf);
	max(max(gr))
	min(min(gr))
	v=nog(eX, eY);
	for i=2:size(eX,1)-1;
		for j=2:size(eX,2)-1;
			g=gr(i,j);
			%if ((g==0)||(g==4))
			if (g==0)
				s=max(max([v(i-1,j) v(i,j) v(i+1,j)]));
			%elseif ((g==1)||(g==5))
			elseif (g==1)
				s=max(max([v(i-1,j-1) v(i,j) v(i+1,j+1)]));
			%elseif ((g==2)||(g==6)||(g==-2))
			elseif ((g==2)||(g==-2))
				s=max(max([v(i,j-1) v(i,j) v(i,j+1)]));
			%elseif ((g==3)||(g==7)||(g==-1))
			elseif (g==-1)
				s=max(max([v(i-1,j+1) v(i,j) v(i+1,j-1)]));
			end
			if (v(i,j)<s)
				y(i,j)=0;
			else
				y(i,j)=v(i,j);
			end
		end
	end
end
