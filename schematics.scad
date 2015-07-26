//////////////////////////////////////////////////////////////////////////
// all lengths are in cm
// 
// width, depth, height should be understood as if looking at the
// bed from the long side


//////////////////////////////////////////////////////////////////////////
// solarized colors
//
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


//////////////////////////////////////////////////////////////////////////
// draw a slab and keep count of the used material
//
// a  -  long side
// b  -  short side
// w  -  width
//
// o  -  orientation
//         "abw" in any order, a is mapped to the first direction, b to
//         the second and w to the third
//
totalSlabArea = 0;

module slab(a, b, w, o) {
  echo (str (w, " cm slab of dimension ", a, " x ", b, " cm^2"));
  totalSlabArea = totalSlabArea  +  a * b;

  if (o == "abw") {
    cube([a, b, w]);
  } else if (o == "awb") {
    cube([a, w, b]);
  } else if (o == "baw") {
    cube([b, a, w]);
  } else if (o == "bwa") {
    cube([b, w, a]);
  } else if (o == "wab") {
    cube([w, a, b]);
  } else if (o == "wba") {
    cube([w, b, a]);
  }
}

//////////////////////////////////////////////////////////////////////////
// draw a slat
//
// l  -  length
// a  -  long side
// b  -  short side
//
// o  -  orientation
//         "lab" in any order, a is mapped to the first direction, b to
//         the second and w to the third
//
module slat(l, a, b, o) {
  echo (str (a, " x ", b, " cm^2 slat of length ", l, " cm"));
  
  if (o == "lab") {
    cube([l, a, b]);
  } else if (o == "lba") {
    cube([l, b, a]);
  } else if (o == "alb") {
    cube([a, l, b]);
  } else if (o == "abl") {
    cube([a, b, l]);
  } else if (o == "bla") {
    cube([b, l, a]);
  } else if (o == "bal") {
    cube([b, a, l]);
  }
}

//////////////////////////////////////////////////////////////////////////
// draw a post
//
// l  -  length
// a  -  first side
// b  -  second side
//
// o  -  orientation
//         "lab" in any order, c.f. slab
//
module post(l, a, b, o) {
  echo (str (a, " x ", b, " cm^2 post of length ", l, " cm"));
  
  if (o == "lab") {
    cube([l, a, b]);
  } else if (o == "lba") {
    cube([l, b, a]);
  } else if (o == "alb") {
    cube([a, l, b]);
  } else if (o == "abl") {
    cube([a, b, l]);
  } else if (o == "bla") {
    cube([b, l, a]);
  } else if (o == "bal") {
    cube([b, a, l]);
  }
}


//////////////////////////////////////////////////////////////////////////
// configuration

tatamiHeight   = 5;
tatamiWidth    = 200;
tatamiDepth    = 140;

standardGap    = 0.8;
floorGap       = 0.3;

postWidth      = 8;
postDepth      = 8;

slatCount      = 13;
slatWidth      = 8;
slatHeight     = 2;
slatDepth      = tatamiDepth;

sideSlatCount  = 4;
sideSlatWidth  = tatamiWidth;
sideSlatHeight = 4;
sideSlatDepth  = 2;

panelWidth     = tatamiWidth;
panelDepth     = tatamiDepth;
panelHeight    = 1;

bedWidth       = tatamiWidth  +  2 * postWidth;
bedDepth       = tatamiDepth  +  2 * postDepth;

wheelHeight    = 8;

sideSlabWidth  = 2.8;

bsSlabWidth   = 1.8;
bsCount       = 3;
bsLedgeHeight = wheelHeight - floorGap;

bsFloorCount  = 2;
bsFloorHeight = 25;
bsFloorDepth  = 20;
bsFloorWidth  = (bedWidth  -  2 * postWidth
                           -  (bsCount + 1) * standardGap
                           -  2 * bsCount * bsSlabWidth) / bsCount;

bsWidth       = bsFloorWidth +  2 * bsSlabWidth;
bsDepth       = bedDepth -  2 * postDepth +  sideSlabWidth -  standardGap;
bsHeight      = bsFloorCount * bsFloorHeight
                +  (bsFloorCount + 1) * bsSlabWidth
                +  bsLedgeHeight;

postHeight    = floorGap + bsHeight
                + sideSlatHeight + slatHeight + panelHeight
                + tatamiHeight;

middlepostWidth  = 2 * bsSlabWidth;
middlepostDepth  = 10;
middlepostHeight = floorGap + bsHeight;


//////////////////////////////////////////////////////////////////////////
// draw the 4 main posts
//
module posts() {
  echo ("## main posts");

  color(base0) {
    translate([0,                    0,                    0])
      post(postHeight, postWidth, postDepth, "abl");
    translate([0,                    bedDepth - postDepth, 0])
      post(postHeight, postWidth, postDepth, "abl");
    translate([bedWidth - postWidth, 0,                    0])
      post(postHeight, postWidth, postDepth, "abl");
    translate([bedWidth - postWidth, bedDepth - postDepth, 0])
      post(postHeight, postWidth, postDepth, "abl");
  }
}

//////////////////////////////////////////////////////////////////////////
// draw the 4 main sides
//
module sides() {
  echo ("## sides");

  sideA  = bedDepth  -  2 * postDepth;
  sideB  = postHeight;
  backA  = bedWidth  -  2 * postWidth;
  backB  = sideB;
  frontA = backA;
  frontB = postHeight - floorGap - bsHeight - standardGap;

  color(base1) {
    // left side
    translate([postWidth - sideSlabWidth, postDepth, 0])
      slab(sideA, sideB, sideSlabWidth, "wab");

    // right side
    translate([bedWidth - postWidth, postDepth, 0])
      slab(sideA, sideB, sideSlabWidth, "wab");

    // back
    translate([postWidth, bedDepth - postDepth, 0])
      slab(backA, backB, sideSlabWidth, "awb");

    // front
    translate([ postWidth
              , postDepth - sideSlabWidth
              , floorGap + bsHeight + standardGap])
      slab(frontA, frontB, sideSlabWidth, "awb");
  }
}


//////////////////////////////////////////////////////////////////////////
// draw the tatami holding
//
module tatamiHolding() {
  echo ("## tatami holding");

  // side slats
  color(base3) {
    for (i = [0 : sideSlatCount - 1]) {
      translate([0, i * (tatamiDepth - sideSlatDepth) / (sideSlatCount - 1), 0])
        slat(sideSlatWidth, sideSlatHeight, sideSlatDepth, "lba");
    }
  }

  // slats
  color(base2) {
    for (i = [0 : slatCount - 1]) {
      translate([i * (tatamiWidth - slatWidth) / (slatCount - 1),
                 0, sideSlatHeight])
        slat(slatDepth, slatWidth, slatHeight, "alb");
    }
  }

  // panel
  color(base3)
  translate([0, 0, sideSlatHeight + slatHeight])
    slab(panelWidth, panelDepth, panelHeight, "abw");

  // middle posts
  color(base2) {
    for (i = [1 : bsCount - 1]) {
      translate([i * (standardGap + bsWidth)
                 + standardGap - bsSlabWidth, 0, - middlepostHeight])
      for (j = [1 : sideSlatCount - 2]) {
        translate([0,
                   j * (tatamiDepth - middlepostDepth) / (sideSlatCount - 1),
                   0])
          post(middlepostHeight, middlepostWidth, middlepostDepth, "abl");
      }
    }
  }
}


//////////////////////////////////////////////////////////////////////////
// draw one bookshelf
//
module bs() {
  echo("## bookshelf");

  color(base00)
  translate([bsSlabWidth, 0, floorGap + bsLedgeHeight]) {
    slab(bsDepth, bsFloorWidth, bsSlabWidth, "baw");

    for (i = [1 : bsFloorCount]) {
      translate([0, 0, i * (bsFloorHeight + bsSlabWidth)]) {
        slab(bsFloorDepth, bsFloorWidth, bsSlabWidth, "baw");
      }
    }
  }

  color(base01) {
    translate([0, 0, floorGap]) {
      slab(bsFloorDepth, bsHeight, bsSlabWidth, "wab");
    }
    translate([bsSlabWidth + bsFloorWidth, 0, floorGap]) {
      slab(bsFloorDepth, bsHeight, bsSlabWidth, "wab");
    }
  }
}


//////////////////////////////////////////////////////////////////////////
// draw the whole bed

posts();
sides();

translate([postWidth, postDepth, floorGap + bsHeight + standardGap])
tatamiHolding();

translate([postWidth + standardGap, postWidth - sideSlabWidth, 0])
for (i = [1 : bsCount]) {
  translate([(i - 1) * (bsWidth + standardGap), 0, 0]) bs();
}

echo(str("total slab area: ", totalSlabArea, " cm^2"));
