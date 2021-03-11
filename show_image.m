function [ err,clusteredImage ] = show_image(im, cmap,V,red_original,green_original,blue_original )
%SHOW_IMAGE Summary of this function goes here
%   Detailed explanation goes here
%% contruct clustered image
% 
%      % find cmap from clusters
%      cmap=cluster; 
%       % cluster vector V is the final mean vector
%      V=mean_vectors;

    % Suppose that your program outputs matrix V, whose dimensions are k
    % and 3, and vector cmap, whose dimension is NxM. Also suppose that
    % your labels are in between 1 and k. Then you may use the following
    % Matlab codes to produce the clustered image
    cmap2 = reshape(cmap,[size(im,1) size(im,2)]);
    M = V / 255;
    clusteredImage = label2rgb(cmap2,M);
    clusteredImage2=reshape(clusteredImage,[size(clusteredImage,1)*size(clusteredImage,2) 3]);

    %% calculate clustering error
    red_clustered=double(clusteredImage2(:,1));
    green_clustered=double(clusteredImage2(:,2));
    blue_clustered=double(clusteredImage2(:,3));

    distred=(((red_original-red_clustered)).^2);
    distgreen=(((green_original-green_clustered)).^2);
    distblue=(((blue_original-blue_clustered)).^2);

    distance = sqrt(distred+distgreen+distblue);
    err=mean(mean(distance));

%% Shows the clustered image in Matlab and writes it into a bitmap file
%figure, imshow(clusteredImage)

end

