function ARE = area_overlap_GZ(BL_a,BL_data,exp_a,exp_data)

    pg_BL = polyshape(BL_a',BL_data);
    pg_exp = polyshape(exp_a,exp_data);

    %计算交集
    pg_inter = intersect(pg_BL, pg_exp);
    area_inter = area(pg_inter);

    %计算并集
    pg_union = union(pg_BL, pg_exp);
    area_union = area(pg_union);

    % 非重叠面积
    area_nonoverlap = area_union - area_inter;

    ARE = area_nonoverlap;
end  