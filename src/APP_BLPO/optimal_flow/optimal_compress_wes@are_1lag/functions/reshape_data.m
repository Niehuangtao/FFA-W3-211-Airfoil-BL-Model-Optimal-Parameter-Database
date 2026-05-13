function [up,dw] = reshape_data(data)
    up_1 = [];
    up_2 = [];
    dw = [];
    turn = 0 ;
    for j = 1 : length(data(:,1))
        if j < length(data(:,1))
            if data(j+1,1) > data(j,1)
                if turn == 0
                    up_1 = [up_1;[data(j,1) data(j,2)]];
                end
                if turn == 1
                    up_2 = [up_2;[data(j,1) data(j,2)]];
                end
            else
                turn = 1;
                dw = [dw;[data(j,1) data(j,2)]];
            end
        else
            up_2 = [up_2;[data(j,1) data(j,2)]];
        end
    end

    up = [up_2;up_1];

    % figure
    % plot(up(:,1), up(:,2))
    % hold on
    % plot(dw(:,1), dw(:,2))
    % legend('up','dw')
end