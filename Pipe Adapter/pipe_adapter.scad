/******************************************************************************
 *
 *  GLOBALS
 *
 ******************************************************************************/

/* [General] */
innerDiameter1 = 56.6;
innerDiameter2 = 37.6;
collar1Length = 25;
collar2Length = 25;
collar1Thickness = 2;
collar2Thickness = 2;
distanceLength = 16;

/* [Tightening Gaps] */
collar1TighteningGap = 1; // [0: No, 1: Yes]
collar1TighteningGapWidth = 2;
collar1TighteningGapLength = 20;
collar2TighteningGap = 1; // [0: No, 1: Yes]
collar2TighteningGapWidth = 2;
collar2TighteningGapLength = 20;
tighteningGapsPosition = 2; // [0: Same side, 1: 90 degrees, 2: Opposite sides]
//39,5/40
/* [Hidden] */
$fa = 1;
$fs = 0.5;


/******************************************************************************
 *
 *  EXECUTION
 *
 ******************************************************************************/

union()
{
    collar1();
    translate([0, 0, collar1Length + distanceLength])
    {
        if(tighteningGapsPosition > 0)
        {
            if(tighteningGapsPosition == 1)
            {
                rotate([0, 0, 90])
                    collar2();
            }
            else
                rotate([0, 0, 180])
                    collar2();                
        }
        else
            collar2();
    }
    
    translate([0, 0, collar1Length])
        distance(innerDiameter1, innerDiameter1 + 2 * collar1Thickness, 
                 innerDiameter2, innerDiameter2 + 2 * collar2Thickness, distanceLength);
}

/***************************************************************************
 *
 *  DIRECT MODULES
 *
 ******************************************************************************/

module collar1()
{
    render(convexity = 2)    
        difference()
        {
            collar(innerDiameter1, collar1Length, collar1Thickness);
            gap1();
        }
}

module collar2()
{
    render(convexity = 2)    
        difference()
        {
            collar(innerDiameter2, collar2Length, collar2Thickness);
            gap2();
        }
}

module gap1()
{
    if(collar1TighteningGap == 1)
    {
        translate([-collar1TighteningGapWidth / 2, innerDiameter1 / 2 - 1, -1])
            cube([collar1TighteningGapWidth, collar1Thickness + 2, collar1TighteningGapLength + 1]);
    }
}

module gap2()
{
    if(collar2TighteningGap == 1)
    {
        translate([-collar2TighteningGapWidth / 2, innerDiameter2 / 2 - 1, collar2Length - collar2TighteningGapLength])
            cube([collar2TighteningGapWidth, collar2Thickness + 2, collar2TighteningGapLength + 1]);
    }
}

 
module distance(bottomInnerDiameter, bottomOuterDiameter, topInnerDiameter, topOuterDiameter, length)
{
    difference()
    {
        cylinder(h = length, d1 = bottomOuterDiameter, d2 = topOuterDiameter);
        cylinder(h = length, d1 = bottomInnerDiameter, d2 = topInnerDiameter);
        translate([0, 0, -0.001])
            cylinder(h = 0.002, d = bottomInnerDiameter);
        translate([0, 0, length - 0.001])
            cylinder(h = 0.002, d = topInnerDiameter);
    }
}

/******************************************************************************
 *
 *  HELPER AND COMPONENT MODULES
 *
 ******************************************************************************/

module collar(diameter, length, thickness)
{
    linear_extrude(height = length)    
        difference()
        {
            circle(r = diameter/2 + thickness, center = true);
            circle(r = diameter/2, center = true);
        }
}
