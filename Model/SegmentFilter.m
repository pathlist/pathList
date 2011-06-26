//
//  SegmentFilter.m
//  datainsight_desktop
//
//  Created by E.O. Stinson on 2011-06-26.
//  Copyright 2011 San Francisco, CA. All rights reserved.
//

#import "SegmentFilter.h"


@implementation SegmentFilter

-(void) clear
{
  if (!segments) {
    segments = [NSMutableArray new];
  }
  [segments removeAllObjects];
}

- (id)init
{
    self = [super init];
    if (self) {
      [self clear];
    }
    
    return self;
}

-(void) addSegmentWithStart: (CLLocationCoordinate2D *)start end: (CLLocationCoordinate2D *)end incline: (double)incl
{
  LocationCoord2D *pt1 = [[LocationCoord2D alloc] initWithCLLocationCoordinate2D:start];
  LocationCoord2D *pt2 = [[LocationCoord2D alloc] initWithCLLocationCoordinate2D:end];
  [segments addObject: [NSArray arrayWithObjects: pt1, pt2, [NSNumber numberWithDouble:incl], nil]];
}

double getDistance(LocationCoord2D *pt1, LocationCoord2D *pt2) {
  /*
   get_distance(pt1, pt2)
   
   takes two pts, where pt is tuple of two floats, i.e. (x,y)
   returns euclidean distance between those pts
   */
  double x1 = [pt1 latitude];
  double x2 = [pt2 latitude];
  double y1 = [pt1 longitude];
  double y2 = [pt2 longitude];
  return sqrt(pow(fabs(x1 - x2), 2) + pow(fabs(y1 - y2), 2));
}

NSMutableArray * filterByRouteDirection(NSArray *segments, LocationCoord2D *start, LocationCoord2D *end) {
  NSMutableArray *newSegments = [NSMutableArray new];
  for (NSMutableArray *segment in segments) {
    // If the distance between the segment start and the start point is lower than the distance between
    // the segment end and the start point, AND the distance between the segment start and the end point
    // is greater than the distance between the segment end and the end point, then this is a good segment
    if (getDistance([segment objectAtIndex: 0], start) < getDistance([segment objectAtIndex:1], start) &&
        getDistance([segment objectAtIndex: 0], end) > getDistance([segment objectAtIndex:1], end)) {
      [newSegments addObject:segment];
    } else if (getDistance([segment objectAtIndex: 1], start) > getDistance([segment objectAtIndex:0], start)) {
      // Alternatively, if the segment end is further from the start point than the segment start, use that too
      [newSegments addObject:segment];        
    }
  }
  return newSegments;
}

-(NSArray *) calculateSegmentsFrom: (CLLocationCoordinate2D *) start to: (CLLocationCoordinate2D *) end {
  filteredSegments = [NSMutableArray new];

  LocationCoord2D *startC = [[LocationCoord2D alloc] initWithCLLocationCoordinate2D:start];
  LocationCoord2D *endC = [[LocationCoord2D alloc] initWithCLLocationCoordinate2D:end];

  filteredSegments = filterByRouteDirection(segments, startC, endC);
  return filteredSegments;
}

- (void)dealloc
{
    [super dealloc];
}

@end
