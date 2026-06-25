function ARE = area_overlap_GZ(BL_a,BL_data,exp_a,exp_data)

    pg_BL = polyshape(BL_a',BL_data);
    pg_exp = polyshape(exp_a,exp_data);

    %Compute intersection
    pg_inter = intersect(pg_BL, pg_exp);
    area_inter = area(pg_inter);

    %Compute union
    pg_union = union(pg_BL, pg_exp);
    area_union = area(pg_union);

    % Non-overlapping area
    area_nonoverlap = area_union - area_inter;

    ARE = area_nonoverlap;
end  