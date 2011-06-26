//
//  LocationCoord2D.m
//  datainsight_desktop
//
//  Created by E.O. Stinson on 2011-06-25.
//  Copyright 2011 San Francisco, CA. All rights reserved.
//

#import "LocationCoord2D.h"


@implementation LocationCoord2D

- (id)init
{
    self = [super init];
    return self;
}
- (id)initWithCLLocationCoordinate2D: (CLLocationCoordinate2D *) loc
{
  self = [super init];
  [(LocationCoord2D *) self setLocation: loc];
  return self;
}

- (id)initWithString: (NSString *) s
{
  self = [super init];
  NSArray * latlon = [s componentsSeparatedByString:@","];
  NSScanner * sc = [NSScanner scannerWithString: [latlon objectAtIndex:0]];
  CLLocationCoordinate2D loc;
  [sc scanDouble: &(loc.latitude)];
  sc = [NSScanner scannerWithString:[latlon objectAtIndex:1]];
  [sc scanDouble: &(loc.longitude)];
  [(LocationCoord2D *) self setLocation: &loc];
  return self;
}

-(void) setLocation: (CLLocationCoordinate2D *) loc {
  location = *loc;
}

-(CLLocationCoordinate2D *) getLocation {
  return &location;
}

-(CLLocationDegrees) latitude {
  return location.latitude;
}

-(CLLocationDegrees) longitude {
  return location.longitude;
}

-(NSString *) asString {
  return [NSString stringWithFormat: @"%f,%f", location.latitude, location.longitude];
}

-(bool) equals: (LocationCoord2D *) loc {
  return ([loc latitude] == [self latitude] && [loc longitude] == [self longitude]);
}

- (void)dealloc
{
    [super dealloc];
}

@end
