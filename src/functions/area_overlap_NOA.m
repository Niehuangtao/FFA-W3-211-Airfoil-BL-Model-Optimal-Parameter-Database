function nonOverlapArea = area_overlap_NOA(BL_a, BL_data, exp_a, exp_data)
%AREA_OVERLAP_NOA Compute the non-overlap area between BL and reference loops.

    pgBL = polyshape(BL_a', BL_data);
    pgExp = polyshape(exp_a, exp_data);

    areaIntersection = area(intersect(pgBL, pgExp));
    areaUnion = area(union(pgBL, pgExp));
    nonOverlapArea = areaUnion - areaIntersection;
end
