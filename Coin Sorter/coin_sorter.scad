/******************************************************************************
 *
 *  GLOBALS
 *
 ******************************************************************************/

/* [General] */

trayType = 1; // [1: Tray with holes, 2: Bottom tray (no holes)]
// Diameter of the coin that should stop (!) on this tray
coinDiameter = 24;
// Radius tolerance, so hole diameter will be lowered by twice the hole tolerance
holeTolerance = 0;
holesDistance = 2;
trayDiameter = 100;
trayHeight = 12;
// Should be less than half of the tray height
indentHeight = 3;
bottomThickness = 0.6;
wallThickness = 1;
// Tray radius tolerance on indent
wallTolerance = 0.3;

/* [Hidden] */
$fa = 1;
$fs = 0.5;


/******************************************************************************
 *
 *  EXECUTION
 *
 ******************************************************************************/

// uncomment this line if preview sucks :)
// render(convexity = 2)
difference()
{
    tray();
    if(trayType == 1)
        coinHoles();
}

/***************************************************************************
 *
 *  DIRECT MODULES
 *
 ******************************************************************************/

module tray()
{
    difference()
    {
        union()
        {
            cylinder(h = trayHeight, d = trayDiameter - 2 * wallThickness - 2 * wallTolerance);
            translate([0, 0, trayHeight - indentHeight - wallThickness])
                cylinder(h = indentHeight + wallThickness, d = trayDiameter);
            // supports not needed with the following:
            translate([0, 0, trayHeight - indentHeight - wallThickness])
                rotate_extrude()
                    translate([trayDiameter / 2 - wallThickness - wallTolerance, 0, 0])
                        circle($fn = 4, r = wallThickness+ wallTolerance);            
        }
        translate([0, 0, bottomThickness])
            cylinder(h = trayHeight, d = trayDiameter - 4 * wallThickness - 2 * wallTolerance);
        translate([0, 0, trayHeight - indentHeight])
            cylinder(h = trayHeight, d = trayDiameter - 2 * wallThickness);
    }
  


}

module coinHoles()
{    
    maxRadius = trayDiameter / 2 - 2 * wallThickness - wallTolerance - holesDistance - coinDiameter / 2 + holeTolerance;
    minRadius = coinDiameter - 2 * holeTolerance + 2 * holesDistance;
    holesOnRadius = floor((maxRadius - minRadius) / (coinDiameter + holesDistance - 2 * holeTolerance));
    if(maxRadius > minRadius)
    {
        for(i = [0 : holesOnRadius])
        {
            centersRadius = maxRadius - i * (coinDiameter - 2 * holeTolerance + holesDistance);
            translate([0, 0, -1])
                linear_extrude(height = bottomThickness + 2)
                    _coinHoles(
                                holeDiameter = coinDiameter - 2 * holeTolerance, 
                                centersRadius = centersRadius,
                                holesDistance = holesDistance
                              );
        }
    }
    lastRadius = maxRadius - holesOnRadius * (coinDiameter - 2 * holeTolerance + holesDistance);

    if(lastRadius > 1.6 * (coinDiameter - 2 * holeTolerance + holesDistance))
    {
            centersRadius = lastRadius - coinDiameter + 2 * holeTolerance - holesDistance;
            translate([0, 0, -1])
                linear_extrude(height = bottomThickness + 2)
                    _coinHoles(
                                holeDiameter = coinDiameter - 2 * holeTolerance, 
                                centersRadius = centersRadius,
                                holesDistance = holesDistance
                              );        
    }
    else
        translate([0, 0, -1])
            cylinder(h = bottomThickness + 2, d = coinDiameter - 2 * holeTolerance);

}

/******************************************************************************
 *
 *  HELPER AND COMPONENT MODULES
 *
 ******************************************************************************/

module _coinHoles(holeDiameter, centersRadius, holesDistance)
{
    virtualHoleRadius = holeDiameter / 2 + holesDistance / 1.9; // lowered from factor of 2 to avoid too small distances in the middle
    angle = 2 * asin((virtualHoleRadius) / (centersRadius + holeDiameter / 2 - virtualHoleRadius));
    holesAmount = floor(360 / angle);
    finalAngle = 360 / holesAmount;
    for(i = [0 : holesAmount])
    {
        rotate([0, 0, i * finalAngle])
            translate([centersRadius - holesDistance, 0, 0])
                circle(d = holeDiameter);
    }
}