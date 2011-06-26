//
//  LocationCoord2D.h
//  datainsight_desktop
//
//  Created by E.O. Stinson on 2011-06-25.
//  Copyright 2011 San Francisco, CA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationCoord2D : NSObject {
  
@private
  CLLocationCoordinate2D location;
}

- (id)initWithCLLocationCoordinate2D: (CLLocationCoordinate2D *) loc;
- (id)initWithString: (NSString *) s;

-(void) setLocation: (CLLocationCoordinate2D *) loc;
-(CLLocationCoordinate2D *) getLocation;
-(NSString *) asString;
-(CLLocationDegrees) latitude;
-(CLLocationDegrees) longitude;
-(bool) equals: (LocationCoord2D *) loc;

@end
