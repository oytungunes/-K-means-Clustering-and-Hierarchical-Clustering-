clear all;clc;close all

load part2_data_K4.mat;

im = imread('onion.png');
im2 = reshape(im,[size(im,1)*size(im,2) 3]);
 im2double=double(im2);

red_original=double(im2(:,1));
green_original=double(im2(:,2));
blue_original=double(im2(:,3));

% compute similarity matrix
K=length(V);
[ sim_matrix ] = compute_sim_matrix( K,V );


% Contruct  node
Matrix = struct('sim_matrix',{},'similar_clusters',{},'cmap',{},'min_value',{},'numberofclusters',{},'mean_vectors',{},'error',{},'image',{});
Matrix(1).sim_matrix=sim_matrix;
Matrix(1).mean_vectors=V;
Matrix(1).numberofclusters=size(V,1);
N=size(im2,1);

step=1;
while(Matrix(step).numberofclusters>1)
step
% find two most similar clusters
A=Matrix(step).sim_matrix;
[minValue, linearIndexesOfMaxes] = sort(unique(A(:)),'ascend');
[rowsOfMaxes colsOfMaxes] = find(A == minValue(2));% returns the second min element
rand_row=randi(length(rowsOfMaxes),1);
Matrix(step).similar_clusters= [rowsOfMaxes(rand_row) colsOfMaxes(rand_row)];


% merge two clusters
old=Matrix(step).mean_vectors; % old mean vectors matrix
merged_mean_vector=round(mean([old(Matrix(step).similar_clusters(1),:); old(Matrix(step).similar_clusters(2),:)]));
old(Matrix(step).similar_clusters,:)=[];
new=[old;merged_mean_vector]; % new mean_vectors matrix
Matrix(step+1).mean_vectors=new;
K=size(new,1);
% update distance matrix
[ Matrix(step+1).sim_matrix ] = compute_sim_matrix( K,new );

%find clusters
for i=1:N
    %assign each data with cluster with minimum distance- expectation     
    for k=1:K
         dist_vector(k)= sqrt(sum((im2double(i,:)-new(k,:)).^2));        
    end;        
         [min_dist(i),cluster(i)] = min( dist_vector );
end; 
Matrix(step+1).cmap=cluster;

%number of clusters
Matrix(step+1).numberofclusters=K;

%calculate error and show image
[ Matrix(step+1).error, Matrix(step+1).image ] = show_image(im, Matrix(step+1).cmap, Matrix(step+1).mean_vectors ,red_original,green_original,blue_original );

step=step+1;
end;




    
   




