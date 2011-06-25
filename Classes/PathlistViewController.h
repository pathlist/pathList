//
//  pathlistViewController.h
//  pathlist
//
//  Created by Server Engineer on 4/23/11.
//  Copyright 2011 Carticipate. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <FactualSDK/FactualAPI.h>

#import "PathWayPointView.h"

@interface pathlistViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, FactualAPIDelegate> {

    IBOutlet MKMapView  *mapView;
             FactualAPI *apiObject;

}

@end

