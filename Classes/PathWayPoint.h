//
//  PathWayPoint.h
//
//  Created by Server Engineer on 4/23/11.
//  Copyright 2011 Carticipate. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface PathWayPoint : NSObject <MKAnnotation>{
  float latitude;
  float longitude;
  float rating;
}

@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic) float rating;

//MKAnnotation
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end
