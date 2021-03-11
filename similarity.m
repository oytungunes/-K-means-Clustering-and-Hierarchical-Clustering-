function [ output_args ] = similarity( x,y )

output_args=norm(x-y)^2;
end

