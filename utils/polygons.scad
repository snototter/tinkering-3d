/*
 * Common functions to work with polygons.
 *
 */
 
// Examples
pts = [[0, 0], [17, 2], [19,15], [1, -1]];
bounding_rect(pts);
#linear_extrude(height=5)
{
    polygon(pts);
}

// Utils to compute bounding box of polygon
function _minimum_coord(pts2d, idx, dimension) = (idx < len(pts2d)-1) ? min(pts2d[idx][dimension], _minimum_coord(pts2d, idx+1, dimension)) : pts2d[idx][dimension];
function minx(pts2d) = _minimum_coord(pts2d, 0, 0);
function miny(pts2d) = _minimum_coord(pts2d, 0, 1);

function _maximum_coord(pts2d, idx, dimension) = (idx < len(pts2d)-1) ? max(pts2d[idx][dimension], _maximum_coord(pts2d, idx+1, dimension)) : pts2d[idx][dimension];
function maxx(pts2d) = _maximum_coord(pts2d, 0, 0);
function maxy(pts2d) = _maximum_coord(pts2d, 0, 1);

function square(x) = x*x;
function distance2d(x1, y1, x2, y2) = sqrt(square(x1-x2) + square(y1-y2));
function distance2d_pts(pt1, pt2) = distance2d(pt1[0], pt1[1], pt2[0], pt2[1]);

module bounding_rect(points_xy)
{
    min_x = minx(points_xy);
    max_x = maxx(points_xy);
    min_y = miny(points_xy);
    max_y = maxy(points_xy);
    
    w = max_x - min_x;
    h = max_y - min_y;
    
    translate([min_x, min_y])
    square([w, h], center=false);
}
 


