function [ sim_matrix ] = compute_sim_matrix( K,mean_vectors )
%%compute similarity matrix
% K=128;
sim_matrix=zeros(K,K);
% mean_vectors=V;
for i=1:K
   for j=1:K
       x=mean_vectors(i,:);
       y=mean_vectors(j,:);
       sim_matrix(i,j)=similarity(x,y);
   end;
end;
end

