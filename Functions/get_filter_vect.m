function [H] = get_filter_vect(data,start_A_vect,b)
    H=zeros(length(data),1);
    approaching= 2; % 0 false, 1 true, 2 null
    margin=0;

    for i=2:length(data) %% Get H
        if (data(i)> start_A_vect(i)) 
                if approaching==1
                    margin=0;
                    H(i)=1; %% if the car is already approaching
                else if approaching==2  % if the car starts to approach
                        H(i)=1;
                        approaching=1;
                        margin=0;
                    else 
                        approaching=0;
                    end
                end
        else if margin< b && approaching==1
                H(i)=1;
                margin=margin+1;  
            else
                approaching=2;
            end
        end
    end
end
