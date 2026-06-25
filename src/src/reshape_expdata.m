function [final_up,final_dw] = reshape_expdata(data)
    l = 250;
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

    v_up = linspace(min(up(:,1)),max(up(:,1)),l);
    v_dw = linspace(max(up(:,1)),min(up(:,1)),l);

    up_interp = interp1(up(:,1),v_up);
    dw_interp = interp1(dw(:,1),v_dw);

    up_data = interp1(up(:,1),up(:,2),v_up,'linear','extrap');
    dw_data = interp1(dw(:,1),dw(:,2),v_dw,'linear','extrap');

    final_up = [v_up' up_data'];
    final_dw = [v_dw' dw_data'];

    % figure
    % plot(final_up(:,1), final_up(:,2))
    % hold on
    % plot(final_dw(:,1), final_dw(:,2))
    % legend('up','dw')
end