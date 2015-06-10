// all lengths are in cm
// 
// width, depth, height should be understood as if looking at the
// bed from the long side

bedWidth             = 200;
bedDepth             = 140;

standardGap          = 0.2;
floorGap             = 0.3;

postWidth            = 5;
postDepth            = 5;

wheelHeight          = 8;

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
bookshelfDepth       = bedDepth;
bookshelfHeight      = bookshelfFloorCount * bookshelfFloorHeight
                       +  (bookshelfFloorCount + 1) * bookshelfSlabWidth
                       +  bookshelfLedgeHeight;

module bookshelf() {
  translate([bookshelfSlabWidth, 0, floorGap + bookshelfLedgeHeight]) {
    cube([bookshelfFloorWidth, bookshelfDepth, bookshelfSlabWidth]);

    for (i = [1 : bookshelfFloorCount]) {
      translate([0, 0, i * (bookshelfFloorHeight + bookshelfSlabWidth)]) {
        cube([bookshelfFloorWidth, bookshelfFloorDepth, bookshelfSlabWidth]);
      }
    }
  }

  translate([0, 0, floorGap]) {
    cube([bookshelfSlabWidth, bookshelfFloorDepth, bookshelfHeight]);
  }
  translate([bookshelfSlabWidth + bookshelfFloorWidth, 0, floorGap]) {
    cube([bookshelfSlabWidth, bookshelfFloorDepth, bookshelfHeight]);
  }
}


for (i = [1 : bookshelfCount]) {
  translate([(i - 1) * (bookshelfWidth + standardGap), 0, 0]) bookshelf();
}
