/******************************************************************************
 *
 *  GLOBALS
 *
 ******************************************************************************/


width = 100;
thickness = 4;
wallThickness = 6;
wallHeight = 10;
wallCornerDistance = 10;
radius1 = 20;
radius2 = 40;

/* [Hidden] */
$fa = 1;
$fs = 0.5;


/******************************************************************************
 *
 *  EXECUTION
 *
 ******************************************************************************/


rotate([90, 0, 45])
{
    plate();
    walls();
}

/***************************************************************************
 *
 *  DIRECT MODULES
 *
 ******************************************************************************/

module plate()
{
    linear_extrude(thickness)
        _platePlane();
}

module walls()
{
    linear_extrude(wallHeight)
        _wallsPlane1();

    translate([0, 0, thickness - wallHeight])        
        linear_extrude(wallHeight)
            _wallsPlane2();
}

/******************************************************************************
 *
 *  HELPER AND COMPONENT MODULES
 *
 ******************************************************************************/

module _platePlane()
{
    difference()
    {
        square(width - 2 * wallThickness);
        _roundingsPlane();
    }
}

module _roundingsPlane()
{
    _cornerRoundingPlane(radius1);
    translate([width - 2 * wallThickness, width - 2 * wallThickness, 0])
        rotate([0, 0, 180])
            _cornerRoundingPlane(radius2);
}

module _cornerRoundingPlane(radius)
{
    translate([radius, radius, 0])
        rotate([0, 0, 180])
            difference()
            {
                square(radius + 1);
                circle(r = radius);
            }
}

module _wallsPlane1()
{
    translate([-wallThickness, radius1 + wallCornerDistance, 0])
        square([wallThickness, width - radius1 - wallCornerDistance - wallThickness ]);
    translate([radius1 + wallCornerDistance, -wallThickness, 0])
            square([width - radius1 - wallCornerDistance - wallThickness, wallThickness]);
}

module _wallsPlane2()
{
    translate([width - 2 * wallThickness, -wallThickness, 0])
            square([wallThickness, width - radius2 - wallCornerDistance + wallThickness]);
    translate([-wallThickness, width - 2 * wallThickness, 0])
            square([width - radius2 - wallCornerDistance + wallThickness, wallThickness]);
}


