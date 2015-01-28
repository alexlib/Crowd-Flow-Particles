function [ U,V ] = mean_flow( U,V )
%MEAN_FLOW Perform a mean filter on optical flow to smooth out the
%direction and magnitude of each point in a dense flow 

filterSize = 30;
H = fspecial('gaussian', filterSize) ;
U = imfilter(U,H,'replicate');
V = imfilter(V,H,'replicate');
%U = medfilt2(U);
%V = medfilt2(V);


end

