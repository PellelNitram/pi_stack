//
// Units in mm.
//

/*
 * Two ribbons.
 *
 * :param thickness: Material thickness.
 * :param width: Width of each ribbon.
 * :param length: Length of each ribbon.
 * :param distance: Distance between the two ribbons. Measured from the middle of each ribbon.
 * :param eps: Tolerance added to thickness, width and length. The distance remains unchanged.
 *
 * Position: Centered in the middle of the whole object.
 *
 */
module Ribbons(
                thickness, width, length,     // Single ribbon
                distance,                     // Two ribbons
                eps=0                        // Tolerance
              )
{

    translate([0, +distance/2.0, 0])
        cube([length+eps, width+eps, thickness+2*eps], center=true);
    translate([0, -distance/2.0, 0])
        cube([length+eps, width+eps, thickness+2*eps], center=true);
    
}

//thickness = 3;
//width = 5;
//length = 20;
//distance = 20;
//eps = 0;
//Ribbons(thickness, width, length, distance, eps);

/*
 * Nutcatch for flat sheets used in laser cutters.
 *
 * :param thickness: Thickness of the nutcatch.
 * :param screwLength: Length of screw. Without its head.
 * :param screwDia: Diameter of the screw.
 * :param nutWidth: Width of nut.
 * :param nutHeight: Height of nut.
 * :param nutOffset: Distance from nut slot to beginning of screw.
 * :param epsCut=0.1: Small value appended to thickness and the screwLength (at its origin).
 *
 * Position:   At the beginning of the screw, z-centered.
 *
 * Tolerances: Tolerance epsCut is only added for using the object
 *             as difference easier. Tolerances in screwDia and
 *             others should be added manually. Thus, make it a
 *             little wider, longer, higher than exactly necessary
 *             yourself.
 *
 */
module Nutcatch(
                     thickness,               // Material details
                     screwLength, screwDia, // Screw details
                     nutWidth, nutHeight,   // Nut details
                     nutOffset, epsCut=0.1   // Assembly details
                 )
{

    translate([0, -screwDia/2.0, -epsCut-thickness/2.0]) {
        translate([-epsCut, 0, 0])
            cube([screwLength+epsCut, screwDia, thickness+2*epsCut]);
        translate([nutOffset, (screwDia-nutWidth)/2.0, 0])
            cube([nutHeight, nutWidth, thickness+2*epsCut]);
    }

}

//thickness = 3;
//screwLength = 25;
//screwDia = 3;
//nutWidth = 5;
//nutHeight = 5;
//nutOffset = 0;
//epsCut=0.0;
//Nutcatch(thickness, screwLength, screwDia, nutWidth, nutHeight, nutOffset, epsCut);

/*
 * Pole for stacking.
 *
 * :param thickness: Material thickness.
 * :param height: Pole height.
 * :param width: Pole width.
 *
 * Position: Object is centered in all three axes.
 *
 */
module Pole(
                 thickness, height, width // Material details
             )
{
                 
    cube([height, width, thickness], center=true);
                 
}

//thickness = 3;
//height = 5;
//width = 3;
//Pole(thickness, height, width);

/*
 * Pile. Assembly using Pole, Ribbons, Nutcatch.
 *
 * :param thickness: Material thickness.
 * :param height: Height of pile.
 * :param width: Width of pile.
 * :param widthR: Width of ribbon.
 * :param distanceR: Distance between ribbons.
 * :param screwLength: Length of screw not including its top.
 * :param screwDia: Diameter of the screw.
 * :param nutWidth: Width of the nut.
 * :param nutHeight: Height of the nut.
 * :param nutOffset: Distance between upper side of nut and base.
 * 
 * Position: Z-centered, y-centered and shifted to the base along x.
 *
 */
module Pile(
               thickness, height, width,  // Pole
               widthR, distanceR,        // Ribbons
               screwLength, screwDia,   // Nutcatch
               nutWidth, nutHeight,
               nutOffset
            )
{     
    
    // Pole geometry       
    heightP = height;
    thicknessP = thickness;
    widthP = width;

    // Ribbons
    thicknessR = thicknessP;
    lengthR = heightP+1.6*thicknessP;
    epsR = 0.0;
                
    // Nutcatches
    thicknessN = thicknessP;
    epsCut = 0.1;
                
    // Assembly
    translate([height/2, 0, 0]) {
                
    difference() {
                
    union() {
                
    // Basic structure
    Pole(thicknessP, heightP, widthP);

    // Additional ribbons
    Ribbons(thicknessR, widthR, lengthR,
             distanceR, epsR);
        
    }

    // Two nutcatches
    translate([-heightP/2.0, 0, 0])
    Nutcatch(thicknessN,
             screwLength, screwDia,
             nutWidth, nutHeight,
             nutOffset, epsCut);
             
    translate([heightP/2.0, 0, 0])
    rotate([0, 0, 180])
    Nutcatch(thicknessN,
             screwLength, screwDia,
             nutWidth, nutHeight,
             nutOffset, epsCut);
             
    }
     
    }
             
}

//// Pole
//thickness = 3;
//height = 50;
//width = 30;
//// Ribbons
//widthR = 5;
//distanceR = 20;
//// Nutcatch
//screwLength = 20;
//screwDia = 3;
//nutWidth = 6;
//nutHeight = 4;
//nutOffset = 10;
//// Pile
//Pile(thickness, height, width,
//     widthR, distanceR,
//     screwLength, screwDia,
//     nutWidth, nutHeight, nutOffset);

/*
 * Mounting holes.
 * 
 * :param thickness: Thickness of material.
 * :param dia: Diameter of holes.
 * :param nx, ny: Number of holes in direction i.
 * :param dx, dy: Distance between holes in direction i.
 * :param eps: Value added to thickness on top and bottom.
 * :param fn: Resolution of holes.
 *
 * Position: Centered in all three directions.
 */
module Mount(
                   thickness,
                   dia,
                   nx, ny,
                   dx, dy,
                   eps = 0.1,
                   fn = 100
               )
{
                   
    lenXmount=(nx-1)*dx;
    lenYmount=(ny-1)*dy;
                   
    union() {
        for(ix=[0:nx-1]) {
            for(iy=[0:ny-1]) {
                translate([-lenXmount/2.0+ix*dx,
                          -lenYmount/2.0+iy*dy,
                          0]) { 
                    cylinder(h=thickness+2*eps,
                             r=dia/2.0,
                             $fn=fn,
                             center=true);
                }
            }
        }
    }
                   
}

//thickness = 3;
//dia = 4;
//nx = 4;
//ny = 3;
//dx = 10;
//dy = 15;
//eps = 0;
//fn = 100;
//Mount(thickness, dia, nx, ny, dx, dy, eps, fn);

/*
 * Piling.
 *
 * :param thickness: Material thickness.
 * :param dia: Hole diameter.
 * :param slotX, slotY: Slot dimensions.
 * :param distance: Distance between slots.
 * :param rotation: Rotation around z axis in degrees.
 * :param fn: Hole resolution.
 * :param epsT: Tolerance in thickness. This is added on top and bottom to thickness.
 * :param epsS: Tolerance in slot dimensions. This is added around the slot.
 * :param epsH: Tolerance in hole diameter. This is added around the slot as radius.
 *
 * Position: Centered in z and with respect to the hole. Aligned along x.
 */
module Piling(
                thickness,                  // Material
                dia,                        // Hole
                slotX, slotY, distance,     // Slot
                rotation,                   // Position
                fn=100,
                epsT=0,                     // Thickness
                epsS=0,                     // Slot
                epsH=0                      // Hole
              )
{
                  
rotate([0, 0, rotation]) {
    
    union() {
                  
          cylinder(h=thickness+2*epsT, r=dia/2+epsH, $fn=fn, center=true);
                  
          translate([-distance/2, 0, 0]) cube([slotX+2*epsS, slotY+2*epsS, thickness+2*epsT], center=true);
                  
          translate([+distance/2, 0, 0]) cube([slotX+2*epsS, slotY+2*epsS, thickness+2*epsT], center=true);
    
    }
    
}
                  
}

//thickness = 3;
//dia = 2;
//slotX = 4;
//slotY = 4;
//distance = 20;
//rotation = 0;
//fn = 100;
//epsT = 0;
//epsS = 0;
//epsH = 0;
//Piling(thickness, dia, slotX, slotY, distance, rotation,
//       fn, epsT, epsS, epsH);

/*
 * Slot.
 *
 * :param thickness: Material thickness.
 * :param length: Length along x.
 * :param width: Width along y.
 * :param epsT: Tolerance in thickness.
 * :param epsS: Tolerance in length and width.
 *
 * Position: Z-centered, aligned along x and centered in x,y.
 */
module Slot(
                thickness,
                length, width,
                epsT=0,
                epsS=0
            )
{
                
    cube([length+2*epsS, width+2*epsS, thickness+2*epsT], center=true);
                
}

//thickness = 4;
//length = 20;
//width = 6;
//epsT = 0;
//epsS = 0;
//Slot(thickness, length, width, epsT, epsS);

/*
 * Basis.
 *
 * :param thickness: Material thickness.
 * :param length, width: Dimensions along x and y.
 * :param radius: Radius of rounded corners.
 * :param fn: Resolution of corners. Low values, e.g. 4, create flat edges.
 *
 * Position: Centered in all three dimensions.
 */
module Basis(
                thickness,
                length, width,
                radius,
                fn=100
            )
{
    
    // Positions for cylinders that are hulled
    w_trans = (width -2*radius)/2.0;
    l_trans = (length-2*radius)/2.0;
    
    // Hull
    hull(){
        translate([+l_trans,+w_trans,0])
            cylinder(r=radius, h=thickness, $fn=fn, center=true);
        translate([-l_trans,+w_trans,0])
            cylinder(r=radius, h=thickness, $fn=fn, center=true);
        translate([+l_trans,-w_trans,0])
            cylinder(r=radius, h=thickness, $fn=fn, center=true);
        translate([-l_trans,-w_trans,0])
            cylinder(r=radius, h=thickness, $fn=fn, center=true);
    }
    
}

//thickness = 3;
//length = 300;
//width = 200;
//radius = 10;
//fn = 100;
//Basis(thickness, length, width, radius, fn);

/*
 * Plate.
 *
 * TODO and test.
 */
module Plate(
                thickness, length, width, radius,       // Plate
                diaM, nx, ny, dx, dy,                   // Mount
                dxH, dyH,                               // Holes
                diaP, slotX, slotY, distanceP,          // Single pile
                lengthP1, widthP1, rotationP1,          // Pile 1
                lengthP2, widthP2, rotationP2,          // Pile 2
                lengthS, widthS, distanceX_s,           // Slot
                distanceY_s
            )
{
    
    // Tolerances: At female, not at male part.

    // Mount
    thicknessM = thickness;
    
    // Single pile
    thicknessP = thickness;
    
    // Slots
    thicknessS = thickness;
    
difference() {
    
    Basis(thickness,
          length, width,
          radius);

    Mount(thicknessM,
          diaM,
          nx, ny,
          dx, dy);

    Mount(thicknessM,
          diaM,
          2, 2,
          dxH, dyH);
    
    // Two mirror operations
    for(iMirrorY = [0, 1])
    mirror([iMirrorY, 0, 0])
    for(iMirrorX = [0, 1])
    mirror([0, iMirrorX, 0]) {
        
    // Piling 1
    translate([lengthP1/2.0, widthP1/2.0, 0]){
    Piling(thicknessP,
           diaP,
           slotX, slotY, distanceP,
           rotationP1,
           epsT=0.1,
           epsS=0.2,
           epsH=0.2);
    }
    
    // Piling 2
    translate([lengthP2/2.0, widthP2/2.0, 0]){
    Piling(thicknessP,
           diaP,
           slotX, slotY, distanceP,
           rotationP2,
           epsT=0.1,
           epsS=0.2,
           epsH=0.2);
    }
    
}
    
    // Slots
    for(iMirror = [0, 1]){
    mirror([0, iMirror, 0]) {
        
    translate([0, distanceY_s/2.0, 0])
    Slot(thicknessS,
         lengthS, widthS,
         epsT=0.1,
         epsS=0.1);
        
    }
    
    mirror([iMirror, 0, 0]) {
    translate([distanceX_s/2.0, 0, 0])
    rotate([0,0,90])
    Slot(thicknessS,
         lengthS, widthS,
         epsT=0.1,
         epsS=0.1);
    }
    
    }
    
} // Difference

}

//// Plate
//thickness = 3.0;
//length = 150.0;
//width = 125.0;
//radius = 5;
//// Mount
//diaM = 3;
//nx = 9;
//ny = 6;
//dx = 10;
//dy = 10;
//// Holes (using Mount)
//dxH = 140;
//dyH = 115;
//// Single pile
//diaP = 3.0;
//slotX = 5.0;
//slotY = 3.0;
//distanceP = 15.0;
//// Both piles
//lengthP1 = 80;
//widthP1 = 100;
//lengthP2 = 125;
//widthP2 = 70;
//rotationP1 = -10;
//rotationP2 = -75;
//// Slot
//lengthS = 25;
//widthS = 3;
//distanceX_s = 135.0;
//distanceY_s = 110.0;
//// Plate
//Plate(
//                thickness, length, width, radius,       // Plate
//                diaM, nx, ny, dx, dy,                   // Mount
//                dxH, dyH,                               // Holes
//                diaP, slotX, slotY, distanceP,          // Single pile
//                lengthP1, widthP1, rotationP1,          // Pile 1
//                lengthP2, widthP2, rotationP2,          // Pile 2
//                lengthS, widthS, distanceX_s,           // Slot
//                distanceY_s
//);

/*
 * Foot. For Piling.
 * 
 * :param diaUpper: Upper diameter.
 * :param diaLower: Lower diameter.
 * :param height: Height of foot.
 * :param diaScrew: Diameter of screw.
 * :param headDiaScrew: Diameter of screw's head.
 * :param headHeightScrew: Height of screw's head.
 * :param roundingRadius: Rounding of edges.
 * :param epsRound: Added to radius of screw's and its head's hole.
 * :param fn: Hole resolution.
 * 
 * Position: x,y centered. Bottom at z=0.
 * 
 */
module Foot(
                diaUpper, diaLower, height,                 // Outer
                diaScrew, headDiaScrew, headHeightScrew, // Inner
                roundingRadius,                             // Rouding
                epsRound=0.1,                              // Tolerance
                fn=100
            )
{
    
    difference() {
        
    // Basic shape
    hull(){
    
    translate([0, 0, height-2*roundingRadius])
    rotate_extrude(angle=360, $fn=fn)
    translate([diaUpper/2.0-roundingRadius, roundingRadius, 0])
    circle(r=roundingRadius, $fn=fn);
    
    rotate_extrude(angle=360, $fn=fn)
    translate([diaLower/2.0-roundingRadius, roundingRadius, 0])
    circle(r=roundingRadius, $fn=fn);
        
    }
        
    // Space for screw
    translate([0, 0, -1])
    cylinder(d=diaScrew+2*epsRound, h=height+2, $fn=fn);
        
    // Space for screw head
    translate([0, 0, -1])
    cylinder(d=headDiaScrew+2*epsRound,
             h=headHeightScrew+1,
             $fn=fn);
        
    }
}

//diaUpper = 15;
//diaLower = 20;
//height=10;
//diaScrew = 3;
//headDiaScrew = 5.5;
//headHeightScrew = 5;
//roundingRadius = 2;
//epsRound = 0.2;
//fn = 100;            
//Foot(
//        diaUpper, diaLower, height,
//        diaScrew, headDiaScrew, headHeightScrew,
//        roundingRadius,
//        epsRound, fn
//);

// ==================================================
//                       Raspberry Pi mounting
// ==================================================

/*
 * Post. For Raspberry Pi mounting.
 *
 * :param screwDia: Diameter of screw.
 * :param screwHeadDia: Diameter of screw's head.
 * :param screwLength: Length of screw.
 * :param height: Overall height of the post.
 * :param diaUpper: Upper diameter.
 * :param diaLower: Lower diameter.
 * :param epsDia: Added to radius of screwDia and screwHeadDia.
 * :param epsHeight: Added to height in negative direction. Useful for assembly.
 * :param fn: Circle resolution.
 *
 * Position: Centered along x,y and sitting at z=0.
 *
 */
module Post(
    screwDia, screwHeadDia, screwLength,
    height,
    diaUpper, diaLower,
    epsDia=0.0,
    epsHeight=0.0,
    fn=100
             )
{
    
    difference() {
    
    union(){
    translate([0, 0, -epsHeight]){
    cylinder(d=diaUpper, $fn=fn, h=height+epsHeight);
    hull(){
    cylinder(d=diaLower, $fn=fn, h=height+epsHeight-screwLength);
    cylinder(d=diaUpper, $fn=fn, h=height+epsHeight-screwLength*0.9);
    } // hull
    } // union
    } // translate
    
    union(){
    translate([0, 0, -epsHeight-0.1]){
    cylinder(d=screwDia+2*epsDia, $fn=fn, h=height+epsHeight+0.2);
    cylinder(d=screwHeadDia+2*epsDia, $fn=fn, h=height-screwLength+epsHeight+0.2);
    } // translate
    } // unioin
    
    } // diff
    
}

//screwDia = 3;
//screwHeadDia = 5;
//screwLength = 15;
//height = 25;
//diaUpper = 5;
//diaLower = 10;
//epsDia = 0.0;
//epsHeight = 0.0;
//fn = 100;
//Post(
//        screwDia, screwHeadDia, screwLength,
//        height,
//        diaUpper, diaLower,
//        epsDia,
//        epsHeight,
//        fn
//    );

/*
 * Frame. For Raspberry Pi mounting.
 * 
 * :param thickness: Thickness of material.
 * :param screwDia: Diameter of screw.
 * :param dx, dy: x and y distance between holes.
 * :param x, y: x and y coordinates of the arms' end-centers.
 * :param armWidth: Width of the arm.
 * :param lengthPosition: Fraction of longest arm length that the platform will be in the longest arm's direction.
 * :param epsDia: Added to screwDia's radius.
 * :param fn: Hole resolution.
 * 
 * Position: Centered in x,y and at z=0 on top of the frame.
 * 
 */
module Frame(
                thickness,
                screwDia, dx, dy,
                x, y, armWidth, lengthPortion,
                epsDia=0,
                fn=100
               )
{
    
    translate([0, 0, -thickness/2.0])

    difference() {

    union() {

    // Arms
    for(i=[0:len(x)-1]){
        hull(){
        translate([x[i], y[i], 0])
            cylinder(d=armWidth, $fn=fn, center=true, h=thickness);
        translate([0, 0, 0])
            cylinder(d=armWidth, $fn=fn, center=true, h=thickness);
        }
    }
       
    // Basis
    pointNorms = [ for (i = [0:len(x)-1]) sqrt(x[i]*x[i]+y[i]*y[i]) ];
    maxNorm = max(pointNorms);
    // TODO: Avoid creating things twice if multiple points have the same maximal norm!
    for(i=[0:len(x)-1])
        if (sqrt(x[i]*x[i]+y[i]*y[i])==maxNorm){
            r = armWidth/2;
            xPos = abs(x[i])*lengthPortion;
            yPos = abs(y[i])*lengthPortion;
            hull() {
                translate([xPos-r, yPos-r, 0])
                    cylinder(r=r, h=thickness, center=true, $fn=fn);
                translate([-xPos+r, yPos-r, 0])
                    cylinder(r=r, h=thickness, center=true, $fn=fn);
                translate([xPos-r, -yPos+r, 0])
                    cylinder(r=r, h=thickness, center=true, $fn=fn);
                translate([-xPos+r, -yPos+r, 0])
                    cylinder(r=r, h=thickness, center=true, $fn=fn);
            }
        }
        
    } // union

    // Screwing holes
    translate([dx/2.0, -dy/2.0, 0])
        cylinder(h=2+thickness, d=screwDia+2*epsDia, center = true, $fn=fn);
    translate([-dx/2.0, dy/2.0, 0])
        cylinder(h=2+thickness, d=screwDia+2*epsDia, center = true, $fn=fn);
        
    } // difference

}

//thickness = 3;
//screwDia=3;
//dx = 10;
//dy = 10;
//x = [50, -50, ];
//y = [100, -100, ];
//armWidth = 6;
//lengthPortion = 0.5;
//fn = 100;
//epsDia = 0;
//Frame(
//        thickness,
//        screwDia, dx, dy,
//        x, y, armWidth, lengthPortion,
//        epsDia,
//        fn
//       );

/*
 * Mounting. Mounting piece for Raspberry Pi.
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 */
module Mounting( 
            thickness, screwDiaF,                      // Frame
            dx, dy, x, y,
            armWidth, lengthPortion,
            screwDiaP, screwHeadDia, screwLength,   // Post
            height, diaUpper, diaLower,
            epsDia = 0.0,                              // Tolerances
            fn = 100 
                  )
{

    // Dimensions for Posts
    epsHeight = thickness;
    
    union(){
    
    // Posts
    for(i=[0:len(x)-1]) {
        translate([x[i], y[i], 0])
            Post(
                    screwDiaP, screwHeadDia, screwLength,
                    height,
                    diaUpper, diaLower,
                    epsDia,
                    epsHeight,
                    fn
                );
    }
    
    difference() {
    
    // Frame
    Frame(
        thickness,
        screwDiaF, dx, dy,
        x, y, armWidth, lengthPortion,
        epsDia,
        fn
       );
    
    // Make space for Posts
    for(i=[0:len(x)-1]) {
        translate([x[i], y[i], -thickness/2.0])
            cylinder($fn=fn, center=true, h=thickness+2, d=diaLower-0.1);
        
    }
    
    } // difference
    
    } // union

}

//// Frame
//thickness = 3;
//screwDiaF = 3;
//dx = 10;
//dy = 10;
//x = [50, -50, ];
//y = [100, -100, ];
//armWidth = 10;
//lengthPortion = 0.5;
//// Post
//screwDiaP = 3;
//screwHeadDia = 5;
//screwLength = 10;
//height = 20;
//diaUpper = 5;
//diaLower = 10;
//epsDia = 0.25;
//fn = 100;
//// Construction
//Mounting(
//            thickness, screwDiaF,                      // Frame
//            dx, dy, x, y,
//            armWidth, lengthPortion,
//            screwDiaP, screwHeadDia, screwLength,   // Post
//            height, diaUpper, diaLower,
//            epsDia,                                    // Tolerances
//            fn
//);