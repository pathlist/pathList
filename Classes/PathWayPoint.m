//
//  SeesmicEvent.m
//  EarthquakeMap
//
//  Created by Server Engineer on 4/23/11.
//  Copyright 2011 Carticipate. All rights reserved.
//

#import "PathWayPoint.h"

@implementation PathWayPoint

@synthesize latitude;
@synthesize longitude;
@synthesize rating;

@synthesize coordinate;

- (CLLocationCoordinate2D)coordinate
{
  CLLocationCoordinate2D coord = {self.latitude, self.longitude};
  return coord;
}

- (NSString*) description
{
  return [NSString stringWithFormat:@"%1.3f, %1.3f, %1.3f", 
          self.latitude, self.longitude, self.rating];
}
@end
