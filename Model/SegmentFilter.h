//
//  SegmentFilter.h
//  datainsight_desktop
//
//  Created by E.O. Stinson on 2011-06-26.
//  Copyright 2011 San Francisco, CA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationCoord2D.h"

@interface SegmentFilter : NSObject {
@private
  NSMutableArray *segments;
  NSMutableArray *filteredSegments;
  long int filterPointer;
}
-(void) addSegmentWithStart: (CLLocationCoordinate2D *)start end: (CLLocationCoordinate2D *)end incline: (double)incl;
-(NSArray *) calculateSegmentsFrom: (CLLocationCoordinate2D *) start to: (CLLocationCoordinate2D *) end;

@end
