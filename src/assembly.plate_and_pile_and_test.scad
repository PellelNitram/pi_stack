use <modules.scad>;
include <dimensions.scad>;

// ===============
// Plate
// ===============

// ==== Dimensions ====

// Plate
thickness = 3.0;
length = 150.0;
width = 125.0;
radius = 5;
// Mount
diaM = 3;
nx = 9;
ny = 6;
dx = 10;
dy = 10;
// Holes (using Mount)
dxH = 140;
dyH = 115;
// Single pile
diaP = 3.0;
slotX = 5.0;
slotY = thickness;
distanceP = 15.0;
// Both piles
lengthP1 = 80;
widthP1 = 100;
lengthP2 = 125;
widthP2 = 70;
rotationP1 = -10;
rotationP2 = -75;
// Slot
lengthS = 25;
widthS = thickness;
distanceX_s = 135.0;
distanceY_s = 110.0;

// ==== Construction ====

projection(cut = true)
Plate(
                thickness, length, width, radius,       // Plate
                diaM, nx, ny, dx, dy,                   // Mount
                dxH, dyH,                               // Holes
                diaP, slotX, slotY, distanceP,          // Single pile
                lengthP1, widthP1, rotationP1,          // Pile 1
                lengthP2, widthP2, rotationP2,          // Pile 2
                lengthS, widthS, distanceX_s,           // Slot
                distanceY_s
);

// ===============
// Pile
// ===============

// ==== Dimensions ====

// Pole
// thickness from above
heightPile = 50;
widthPile = 25;
// Ribbons
widthR = slotX;
distanceR = distanceP;
// Nutcatch
screwLength = M3_SCREW_LENGTH_20;
screwDia = 3;
nutWidth = M3_NUT_WIDTH*1.2;
nutHeight = M3_NUT_HEIGHT*1.2;
nutOffset = 5;
// Pile

// ==== Construction ====

projection(cut=true)
translate([0, 80, 0])
Pile(thickness, heightPile, widthPile,
     widthR, distanceR,
     screwLength, screwDia,
     nutWidth, nutHeight, nutOffset);

// ===============
// Test female pile
// ===============

// ==== Construction ====

projection(cut=true)
translate([-40, 80, 0])
intersection(){

cube([35, 20, 20], center=true);

translate([lengthP1/2.0, widthP1/2.0, 0])
Plate(
                thickness, length, width, radius,       // Plate
                diaM, nx, ny, dx, dy,                   // Mount
                dxH, dyH,                               // Holes
                diaP, slotX, slotY, distanceP,          // Single pile
                lengthP1, widthP1, rotationP1,          // Pile 1
                lengthP2, widthP2, rotationP2,          // Pile 2
                lengthS, widthS, distanceX_s,           // Slot
                distanceY_s
);
}