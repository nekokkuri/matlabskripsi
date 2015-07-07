function y=msuppr(eX, eY)
	%grt=atan(eY./(eX+eps));
	grt=atan(eY./(eX));
	grf=grt./(atan(1));
	gr=round(grf);
	max(max(gr))
	min(min(gr))
	v=nog(eX, eY);
	dmask0=(gr==0);
	sum(sum(dmask0))
	dmask1=(gr==1);
	sum(sum(dmask1))
	dmask2=((gr==2)|(gr==-2));
	sum(sum(dmask2))
	dmask3=(gr==-1);
	sum(sum(dmask3))
	% direction 0
	sw=zeros(size(v,1), size(v,2), 3);
	vmask=v.*dmask0;
	sw(2:size(v,1),:,1)=vmask(1:size(v,1)-1,:);
	sw(:,:,2)=vmask(:,:);
	sw(1:size(v,1)-1,:,3)=vmask(2:size(v,1),:);
	%lmax0=max(sw,[],3).*dmask0;
	lmax0=max(sw,[],3);
	%lmask0=(lmax0==vmask);
	lmask0=(lmax0==vmask).*dmask0;
	% direction 1
	vmask=v.*dmask1;
	sw=zeros(size(v,1), size(v,2), 3);
	sw(2:size(v,1),2:size(v,2),1)=vmask(1:size(v,1)-1,1:size(v,2)-1);
	sw(:,:,2)=vmask(:,:);
	sw(1:size(v,1)-1,1:size(v,2)-1,3)=vmask(2:size(v,1),2:size(v,2));
	lmax1=max(sw,[],3);
	%lmax1=max(sw,[],3).*dmask1;
	lmask1=(lmax1==vmask).*dmask1;
	%lmask1=(lmax1==v);
	% direction 2
	vmask=v.*dmask2;
	sw=zeros(size(v,1), size(v,2), 3);
	sw(:,2:size(v,2),1)=vmask(:,1:size(v,2)-1);
	sw(:,:,2)=vmask(:,:);
	sw(:,1:size(v,2)-1,3)=vmask(:,2:size(v,2));
	lmax2=max(sw,[],3);
	%lmax2=max(sw,[],3).*dmask2;
	lmask2=(lmax2==vmask).*dmask2;
	%lmask2=(lmax2==v);
	% direction -1
	vmask=v.*dmask3;
	sw=zeros(size(v,1), size(v,2), 3);
	sw(2:size(v,1),1:size(v,2)-1,1)=vmask(1:size(v,1)-1,2:size(v,2));
	sw(:,:,2)=vmask(:,:);
	sw(1:size(v,1)-1,2:size(v,2),3)=vmask(2:size(v,1),1:size(v,2)-1);
	lmax3=max(sw,[],3);
	%lmax3=max(sw,[],3).*dmask3;
	lmask3=(lmax3==vmask).*dmask3;
	%lmask3=(lmax3==v);
	%y=(lmask1||lmask2||lmask3).*v;
	sum(sum(lmask1||lmask2||lmask3));
	y=(lmask0|lmask1|lmask2|lmask3).*v;
end
