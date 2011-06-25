//
//  PathWayPointView.h
//  ...the dot which marks a way point
//
//  Created by Server Engineer on 4/23/11.
//  Copyright 2011 Carticipate. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "PathWayPoint.h"


@interface PathWayPointView : MKAnnotationView {
  PathWayPoint *event;
}

@end
