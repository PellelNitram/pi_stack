use <modules.scad>;
include <dimensions.scad>;

//
// Foot
//

// ==== Dimensions ====
diaUpper                = 15;
diaLower                = 20;
height                   = 10;
diaScrew                = 3;
headDiaScrew           = 5.5;
headHeightScrew       = 5;
roundingRadius         = 2;
epsRound               = 0.5;
fn                       = 100;            

// ==== Construction ====
Foot(
        diaUpper, diaLower, height,
        diaScrew, headDiaScrew, headHeightScrew,
        roundingRadius,
        epsRound, fn
);