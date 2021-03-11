clear all;clc;close all

% Reads sample.jpg into an im matrix, whose dimensions are N, M, and 3
im = imread('sample.jpg');


% Reshapes the 3D im matrix into a 2D matrix, called im2, whose
% dimensions are NxM and 3. In thdis 2D matrix, each row corresponds to
% a pixel, and the columns correspond to red, green, and blue channels
% in the RGB color space, respectively
im2 = reshape(im,[size(im,1)*size(im,2) 3]);
red_original=double(im2(:,1));
green_original=double(im2(:,2));
blue_original=double(im2(:,3));


% You need to run the k-means algorithm on the im2 matrix. Your
% k-means algorithm should output the clustering vectors (let’s call
% them V) and the labels of the clustered pixels (let’s call them
% cmap). To implement the k-means algorithm, you can use Matlab.
% However, if you find Matlab too slow (and if you do not know how to
% read images in your preferred programming language), you can write
% the contents of im2 into a file and read this file in your program.
% Similarly, you can calculate clustering vectors V and labels cmap
% in your program, write them into files, and read them from Matlab
% to obtain the clustered image

 
K_vector=[  4 ];
mean_vec_error_treshold=20;
 
for j=1:length(K_vector)     
     K=K_vector(j);
     K
     N=size(im2,1);
     im2double=double(im2);

     % initialize mean vectors
    vector_red=double(im2(:,1));
    vector_green=double(im2(:,2));
    vector_blue=double(im2(:,3));
    centroid_red=(1:K).*max((vector_red(:)))/(K+1);
    centroid_green=(1:K).*max((vector_green(:)))/(K+1);
    centroid_blue=(1:K).*max((vector_blue(:)))/(K+1);
    mean_vectors= [centroid_red' centroid_green' centroid_blue'];
    %% do clustering
     step=1;
     convergence=false;
     cluster = zeros(1, N);

     while convergence==false     
         old_clusters=cluster;
         convergence=false;
         for i=1:N
             %assign each data with cluster with minimum distance- expectation     
             for k=1:K
                 dist_vector(k)= sqrt(sum((im2double(i,:)-mean_vectors(k,:)).^2));        
             end;        
             [min_dist(i),cluster(i)] = min( dist_vector );
         end;     

%         for i = 1:N
%             if cluster(i) ~= old_clusters(i)
%                    convergence = false;
%             break
%             end
%         end   
         old_mean_vector=mean_vectors;
         mean_error=0;
         % assign new mean_vector for all k
         for k=1:K
                indeces=find(cluster==k);
                mean_vectors(k,:)=mean(im2double(indeces,:),1);
                if(length(indeces)>0)
                    mean_error=mean_error+sum(abs(mean_vectors(k,:)-old_mean_vector(k,:)));
                end;
         end;  
         mean_error
         % stopping criterion
         
         if(mean_error<mean_vec_error_treshold)
             convergence=true;
         end;
         mean_vec_error(step)=mean_error;  
         step=step+1;
     end; 

     %% contruct clustered image

     % find cmap from clusters
     cmap=cluster; 
      % cluster vector V is the final mean vector
     V=mean_vectors;

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
    err(j)=mean(mean(distance));
    error=err(j);

%% Shows the clustered image in Matlab and writes it into a bitmap file
figure, imshow(clusteredImage)
imwrite(clusteredImage,['part1_k' num2str(K_vector(j)) '.bmp'])
save(['errors_K' num2str(K_vector(j)) '.mat'],'error','V')

end;