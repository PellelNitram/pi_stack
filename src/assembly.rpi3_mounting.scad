use <modules.scad>;
include <dimensions.scad>;

//
// RPi 3 mounting
//

// ==== Dimensions ====

// Frame
thickness = 3;
screwDiaF = 3;
dx = 10;
dy = 10;
x = [58/2, 58/2, -58/2, -58/2];
y = [49/2, -49/2, 49/2, -49/2];
armWidth = 10;
lengthPortion = 0.5;

// Post
screwDiaP = 2.4;
screwHeadDia = 5;
screwLength = 10;
height = 20;
diaUpper = 5;
diaLower = 10;
epsDia = 0.25;
fn = 100;

// ==== Construction ====
Mounting(
            thickness, screwDiaF,                      // Frame
            dx, dy, x, y,
            armWidth, lengthPortion,
            screwDiaP, screwHeadDia, screwLength,   // Post
            height, diaUpper, diaLower,
            epsDia,                                    // Tolerances
            fn
);