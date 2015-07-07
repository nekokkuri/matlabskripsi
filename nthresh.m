function [nt, level]=nthresh(nog, factor)
	I_max=max(max(nog));
	I_min=min(min(nog));
	level=factor*(I_max-I_min)+I_min;
	nt=max(nog,level.*ones(size(nog)));
end
