function [ U,V ] = mean_flow( U,V )
%MEAN_FLOW Perform a mean filter on optical flow to smooth out the
%direction and magnitude of each point in a dense flow 


U = medfilt2(U);
V = medfilt2(V);


end

