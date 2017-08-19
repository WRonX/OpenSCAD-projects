/******************************************************************************
 *
 *  GLOBALS
 *
 ******************************************************************************/


/* [General] */

// Effective (internal) length of the clip
armLength = 55;
// Should not be less than two times latch arm hickness plus movement gap :)
armThickness = 5;
height = 10;
latchArmThickness = 2; // [1:0.1:3]
// Simply just tollerance, must be positive for movement
movementGap = 0.4; // [0.2:0.05:0.8]

/* [Hidden] */
$fa = 1;
$fs = 0.5;


/******************************************************************************
 *
 *  EXECUTION
 *
 ******************************************************************************/


lockArm();
freeArm();


/***************************************************************************
 *
 *  DIRECT MODULES
 *
 ******************************************************************************/

module lockArm()
{
    difference()
    {
        linear_extrude(height = height, convexity = 8)
            _lockArmPlane();
        translate([-armThickness - 1, -1, height / 4 - movementGap])
            cube([2 * armThickness + 1, armThickness + 1, height / 2 + 2 * movementGap]);

        translate([armThickness + movementGap, armThickness + movementGap / 2, height / 2 - sqrt(2) / 2])
            rotate([45, 0, 0])
                cube([armLength, 1, 1]);
    }
}

module freeArm()
{
    translate([0, armThickness, 0])
        rotate([0, 0, -45]) 
            translate([0, -armThickness, 0])
            {
                difference()
                {
                    union()
                    {
                        linear_extrude(height = height, convexity = 8)
                            _freeArmPlane();
                        translate([0, 0, height / 4])
                            cube([armThickness + movementGap, armThickness - movementGap, height / 2]);
                        translate([armThickness + movementGap, armThickness - movementGap / 2, height / 2 - sqrt(2) / 2])
                            rotate([45, 0, 0])
                                cube([armLength, 1, 1]);
                    }
                    translate([0, 0, -1])
                        linear_extrude(height = height + 2, convexity = 8)
                            polygon([[-1, -1], [armThickness + movementGap, 0], [0, armThickness / 2]]);

                    translate([0, 0, -1])
                        linear_extrude(height = height + 2, convexity = 8)
                            polygon([
                                [armLength + armThickness + movementGap, armThickness / 2],
                                [armLength + armThickness + movementGap + 1, armThickness / 2],
                                [armLength + armThickness + movementGap, armThickness + sqrt(2)],
                                [armLength + armThickness + movementGap - latchArmThickness, armThickness + sqrt(2)]
                                ], center = true);
                }
            }
}

/******************************************************************************
 *
 *  HELPER AND COMPONENT MODULES
 *
 ******************************************************************************/

module _freeArmPlane()
{
    translate([0, armThickness, 0])
        circle(armThickness / 2);
    translate([armThickness + movementGap, 0, 0])
        square([armLength, armThickness - movementGap / 2]);
}

 module _lockArmPlane()
 {
    union()
    {
        difference()
        {
            union()
            {
                translate([0, armThickness, 0])
                    circle(armThickness);
                translate([0, armThickness + movementGap / 2, 0])
                    square([armLength + armThickness + movementGap, armThickness - movementGap / 2]);
                translate([armLength + armThickness - 2 * latchArmThickness + movementGap, 2 * armThickness - latchArmThickness, 0])
                    square([3 * latchArmThickness + movementGap, latchArmThickness]);
                translate([armLength + armThickness + 2 * movementGap, - movementGap, 0])
                    square([latchArmThickness, 2 * armThickness + movementGap]);
                polygon([
                    [armLength + armThickness + 2 * movementGap + latchArmThickness, -movementGap],
                    [armLength + armThickness + movementGap - latchArmThickness * 0.75, -movementGap],
                    [armLength + armThickness + movementGap - latchArmThickness * 0.75, -movementGap - latchArmThickness / 2],
                    [armLength + armThickness + 2 * movementGap, -movementGap - latchArmThickness * 1.5],
                    [armLength + armThickness + 2 * movementGap + latchArmThickness, -movementGap - latchArmThickness * 1.5]
                    ]);
            }
                translate([0, armThickness, 0])
                    circle(armThickness / 2 + movementGap);
                translate([armLength + armThickness - 2 * latchArmThickness, armThickness * 2 - latchArmThickness - movementGap, 0])
                    square([2 * latchArmThickness + movementGap, movementGap]);
                translate([armLength + armThickness + 2 * movementGap + latchArmThickness, armThickness * 2 - latchArmThickness/2, 0])
                    rotate([0, 0, 45])
                        square(latchArmThickness);
            
        }    
    }
 }