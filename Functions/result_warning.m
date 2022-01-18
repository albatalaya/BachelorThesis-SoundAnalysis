function [result_warn] = result_warning(filtered_vect)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    result_warn=[];
    tup=0;
    j=0;
    for i=1:length(filtered_vect)
        if filtered_vect(i)>0 && tup==0
                j=j+1;
                result_warn(j,1)=i-1;
                tup=1;
        else
            if filtered_vect(i)==0 && tup==1
                result_warn(j,2)=i-1;
                tup=0;
            end
        end
    end
end

