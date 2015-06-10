// all lengths are in cm
// 
// width, depth, height should be understood as if looking at the
// bed from the long side


// solarized colors
base03  = [0,     0.169, 0.212];
base02  = [0.027, 0.212, 0.259];
base01  = [0.354, 0.431, 0.459];
base00  = [0.396, 0.482, 0.514];
base0   = [0.514, 0.580, 0.588];
base1   = [0.576, 0.631, 0.631];
base2   = [0.933, 0.910, 0.835];
base3   = [0.992, 0.965, 0.890];
yellow  = [0.710, 0.537, 0    ];
orange  = [0.796, 0.294, 0.068];
red     = [0.863, 0.196, 0.184];
magenta = [0.824, 0.212, 0.510];
violet  = [0.424, 0.443, 0.769];
blue    = [0.149, 0.545, 0.824];
cyan    = [0.165, 0.631, 0.596];
green   = [0.512, 0.6,   0    ];

tatamiHeight         = 5;
tatamiWidth          = 200;
tatamiDepth          = 140;

postWidth            = 8;
postDepth            = 8;

slatCount            = 13;
slatWidth            = 8;
slatHeight           = 2;
slatDepth            = tatamiDepth;

panelWidth           = tatamiWidth;
panelDepth           = tatamiDepth;
panelHeight          = 1;

sideSlatWidth        = tatamiWidth;
sideSlatHeight       = 4;
sideSlatDepth        = 2;

bedWidth             = tatamiWidth  +  2 * postWidth;
bedDepth             = tatamiDepth  +  2 * postDepth;

standardGap          = 0.8;
floorGap             = 0.3;

wheelHeight          = 8;

sideSlabWidth        = 2.8;

bookshelfSlabWidth   = 1.8;
bookshelfCount       = 3;
bookshelfLedgeHeight = wheelHeight - floorGap;

bookshelfFloorCount  = 2;
bookshelfFloorHeight = 25;
bookshelfFloorDepth  = 20;
bookshelfFloorWidth  = (bedWidth  -  2 * postWidth
                                  -  (bookshelfCount + 1) * standardGap
                                  -  2 * bookshelfCount * bookshelfSlabWidth
                       ) / bookshelfCount;

bookshelfWidth       = bookshelfFloorWidth
                       +  2 * bookshelfSlabWidth;
bookshelfDepth       = bedDepth
                       -  2 * postDepth
                       +  sideSlabWidth
                       -  standardGap;
bookshelfHeight      = bookshelfFloorCount * bookshelfFloorHeight
                       +  (bookshelfFloorCount + 1) * bookshelfSlabWidth
                       +  bookshelfLedgeHeight;

postHeight           = floorGap
                       + bookshelfHeight
                       + sideSlatHeight
                       + slatHeight
                       + panelHeight
                       + tatamiHeight;


module post() {
  color(base0)
  cube([postWidth, postDepth, postHeight]);
}

module posts() {
  translate([0,                    0,                    0]) post();
  translate([0,                    bedDepth - postDepth, 0]) post();
  translate([bedWidth - postWidth, 0,                    0]) post();
  translate([bedWidth - postWidth, bedDepth - postDepth, 0]) post();
}

module sides() {
  color(base1) {
    // left side
    translate([postWidth - sideSlabWidth, postDepth, 0])
    cube([sideSlabWidth, bedDepth  -  2 * postDepth, postHeight]);

    // right side
    translate([bedWidth - postWidth, postDepth, 0])
    cube([sideSlabWidth, bedDepth  -  2 * postDepth, postHeight]);

    // back
    translate([postWidth, bedDepth - postDepth, 0])
    cube([bedWidth  -  2 * postWidth, sideSlabWidth, postHeight]);

    // front
    translate([postWidth,
               postDepth - sideSlabWidth,
               floorGap + bookshelfHeight + standardGap])
    cube([bedWidth - 2 * postWidth,
          sideSlabWidth,
          postHeight - floorGap - bookshelfHeight - standardGap]);
  }
}

module sideSlats() {
  color(base3) {
    cube([sideSlatWidth, sideSlatDepth, sideSlatHeight]);
    
    translate([0, tatamiDepth - sideSlatDepth, 0])
    cube([sideSlatWidth, sideSlatDepth, sideSlatHeight]);
  }
}

module slats() {
  color(base2) {
    for (i = [0 : slatCount - 1]) {
      translate([i * (tatamiWidth - slatWidth) / (slatCount - 1),
                 0, sideSlatHeight])
      cube([slatWidth, slatDepth, slatHeight]);
    }
  }
}

module panel() {
  color(base3)
  translate([0, 0, sideSlatHeight + slatHeight])
  cube([panelWidth, panelDepth, panelHeigth]);
}

module tatamiHolding() {
  sideSlats();
  slats();
//  panel();
}



module bookshelf() {
  color(base00)
  translate([bookshelfSlabWidth, 0, floorGap + bookshelfLedgeHeight]) {
    cube([bookshelfFloorWidth, bookshelfDepth, bookshelfSlabWidth]);

    for (i = [1 : bookshelfFloorCount]) {
      translate([0, 0, i * (bookshelfFloorHeight + bookshelfSlabWidth)]) {
        cube([bookshelfFloorWidth, bookshelfFloorDepth, bookshelfSlabWidth]);
      }
    }
  }

  color(base01) {
    translate([0, 0, floorGap]) {
      cube([bookshelfSlabWidth, bookshelfFloorDepth, bookshelfHeight]);
    }
    translate([bookshelfSlabWidth + bookshelfFloorWidth, 0, floorGap]) {
      cube([bookshelfSlabWidth, bookshelfFloorDepth, bookshelfHeight]);
    }
  }
}



posts();
sides();

translate([postWidth, postDepth, floorGap + bookshelfHeight + standardGap])
tatamiHolding();

translate([postWidth + standardGap, postWidth - sideSlabWidth, 0])
for (i = [1 : bookshelfCount]) {
  translate([(i - 1) * (bookshelfWidth + standardGap), 0, 0]) bookshelf();
}
