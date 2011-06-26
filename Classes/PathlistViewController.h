//
//  PathlistViewController.h
//  pathlist
//
//  Created by Server Engineer on 4/23/11.
//  Copyright 2011 Carticipate. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <FactualSDK/FactualAPI.h>


@interface PathlistViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, FactualAPIDelegate> {

    IBOutlet MKMapView  *map;
             FactualAPI *apiObject;
    
    MKPolyline                       *lineOnMap;
    
	CLLocationManager				 *locManager;
	NSDate							 *currentLatLonTimestamp;
	NSDate							 *lastLatLonTimestamp;
	NSDate							 *chatWebViewTimestamp;
	
	CLLocationCoordinate2D			  currentLatLon;
	CLLocationCoordinate2D			  lastLatLon;
	BOOL							  deniedLatLon;
    	
	CLLocationCoordinate2D			  mapLeftLatLon;
	CLLocationCoordinate2D			  mapCenterLatLon;
	CLLocationCoordinate2D			  mapCenterLatLonOld;
	CLLocationCoordinate2D			  mapRightLatLon;

	MKCoordinateSpan				  mapSpan;
	MKCoordinateSpan				  mapSpanOld;

	MKCoordinateRegion				  mapRegion;		
	MKCoordinateRegion				  mapRegionOld;
	MKCoordinateRegion				  mapRegionUnAdjusted;
	
	CGPoint							  centerTarget;
	CGPoint							  leftTarget;
	CGPoint							  rightTarget;
	CGPoint							  upperTarget;
	CGPoint							  lowerTarget;	
    

}
@property								CLLocationCoordinate2D	currentLatLon;
@property								CLLocationCoordinate2D	   lastLatLon;
@property								BOOL					 deniedLatLon;
@property(readwrite, retain, nonatomic)	CLLocationManager	   *locManager;				// Steffen added
@property(readwrite, copy,   nonatomic)	NSDate				   *currentLatLonTimestamp;
@property(readwrite, copy,   nonatomic)	NSDate				   *lastLatLonTimestamp;


- (void)releaseViewResources;

/*
-(IBAction) startAdjustSettings:   (id) sender;
-(IBAction) conductAdjustSettings: (id) sender;
-(IBAction) endAdjustSettings:     (id) sender;
-(IBAction) cancelAdjustSettings:  (id) sender;
*/


//-(IBAction) clickInfo:				(id) sender;  // not used at the moment


//--- Blain's RootViewController methods ---
- (void) startUpdatingLocation;
- (void)  stopUpdatingLocation;

// the mapview protocols : Steffen put here for documentation purposes
//- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated;
//- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated;  //implemented

//- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView;
//- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView;
//- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error;


@end

