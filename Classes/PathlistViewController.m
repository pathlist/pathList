//
//  PathlistViewController.m
//  pathlist
//
//  Created by Server Engineer on 4/23/11.
//  Copyright 2011 Carticipate. All rights reserved.
//

#import "PathlistViewController.h"
#import "PathWayPoint.h"

@implementation PathlistViewController

@synthesize	currentLatLon;
@synthesize    lastLatLon;
@synthesize  deniedLatLon;
@synthesize    locManager;				// Steffen added
@synthesize currentLatLonTimestamp;
@synthesize    lastLatLonTimestamp;

- (void)dealloc {
	[self  releaseViewResources];
    [super dealloc];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // get the api object
    apiObject = [[FactualAPI alloc] initWithAPIKey:@"SWdhzEah8u1ZXAngcrxkGu3Twnw8FMx33wthXXJ8HJs8xFEg3VoheJJbYAZq7Rk2"];
    
    // alloc query object
    FactualQuery* queryObject = [FactualQuery query];
    
	// setup query
    CLLocationCoordinate2D fakeCoordinate;
    
    fakeCoordinate.latitude  =   37.78685;      // downtown SF: 37.38690, -122.06407
    fakeCoordinate.longitude = -122.39392;
    
    [queryObject setGeoFilter:fakeCoordinate radiusInMeters:20000.00];
     queryObject.limit = 9000;
	
	// send query to factual (and let the delegate handle it)
    [[apiObject queryTable:@"a9ttss" optionalQueryParams:queryObject withDelegate:self] retain];
    
    // resize the map
    [map setCenterCoordinate:fakeCoordinate animated:YES];
    [map setRegion:MKCoordinateRegionMake(fakeCoordinate, MKCoordinateSpanMake(0.02, 0.02))]; 


/*
  // * Writing to pathlist * //
    
    // create a dictionary 
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    
    // populate relevant fields 
    [dictionary setObject:[NSNumber numberWithDouble:  34.0484970] forKey:@"latitude" ];
    [dictionary setObject:[NSNumber numberWithDouble:-118.4907952] forKey:@"longitude"];
    [dictionary setObject:[NSNumber numberWithDouble:   2        ] forKey:@"rating"   ];
    [dictionary setObject:@"paved"                                 forKey:@"roadtype"]; 
    [dictionary setObject:@"steffenfrost"                          forKey:@"userid"];
    [dictionary setObject:@""                                      forKey:@"date"];
    [dictionary setObject:@"Test Path"                             forKey:@"pathname"];
    
    // ok add the row ...
    [[apiObject submitRowData:@"JBbIvk" facts:dictionary withDelegate:self
                optionalRowId:nil 
               optionalSource:@"Some Mobile App" 
              optionalComment:@"Comment"
            optionalUserToken:nil]               retain];
*/
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)releaseViewResources
{
	[map       release];
    [apiObject release];
    
	apiObject = nil;	
	map       = nil;
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    
    [self releaseViewResources];
}


#pragma mark -
#pragma mark FactualAPIDelegate

// Reading
- (void)requestComplete:(FactualAPIRequest*) request receivedQueryResult:(FactualQueryResult*) queryResult; {
    
    NSLog(@"queryResult          : %@",  queryResult);
//  NSLog(@"queryResult requestID: %@", [queryResult requestId]);       // why does this crash?
//  NSLog(@"queryResult requestID: %@", [queryResult requestType]);     // ...crashes
    NSLog(@"queryResult requestID: %@", [queryResult tableId]);
    
    // update UI w/ info from factual...
    NSLog(@"Number of query results %f: ", queryResult.rows);

    for (FactualRow *row in queryResult.rows) {
        
        CLLocationCoordinate2D coordStart;
        CLLocationCoordinate2D coordEnd;
        float                  incline;
        
        coordStart.latitude  = [[row.values objectAtIndex:1] floatValue];
        coordStart.longitude = [[row.values objectAtIndex:2] floatValue];
          coordEnd.latitude  = [[row.values objectAtIndex:3] floatValue];
          coordEnd.longitude = [[row.values objectAtIndex:4] floatValue];
                     incline = [[row.values objectAtIndex:5] floatValue];
        
        NSUInteger numPoints = 2;
        CLLocationCoordinate2D *pathSegment = malloc( sizeof(CLLocationCoordinate2D) * numPoints );
        
        pathSegment[0] = coordStart;
        pathSegment[1] = coordEnd;
        
        MKPolyline *polyline = [MKPolyline polylineWithCoordinates:pathSegment count:numPoints];
        
        [map addOverlay:polyline];
        free(pathSegment);        
    } 
}
    
// Writing
- (void)requestComplete:(FactualAPIRequest*) request receivedUpdateResult:(FactualUpdateResult*) updateResult {
    
    NSLog(@"Affected Row ID: %i", updateResult.affectedRowId); // contains the row id of the inserted / updated row...
    
    NSLog(@"Insert was folded into existing row: %@\n", [updateResult exists] ? @"YES" : @"NO"); // indicates if the insert was folded into an existing row
    
}


#pragma mark Core Location entry Points

- (void) startUpdatingLocation;
{
    //	NSLog(@"MapVC*: startUpdatingLocation...");
    
	if (deniedLatLon || (locManager != nil)) return;
	
    //	NSLog(@"MapVC*: are we about to alloc another CLLocationManager here?");
	locManager = [[CLLocationManager alloc] init];
	if (! [CLLocationManager locationServicesEnabled]) {
		NSLog(@"Cross your fingers, folks! User has requested us to get a location, but hasn't enabled locationServices. The update request will trigger a dialog.");
	}
	
	locManager.delegate = self;
	locManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
	[locManager startUpdatingLocation];
	
    //	NSLog(@"... finishing MapVC*: startUpdatingLocation...");
}

- (void) stopUpdatingLocation;
{
    //	NSLog(@"MapVC*: stopUpdatingLocation...");	
	[locManager stopUpdatingLocation];
	[locManager autorelease];				//  Should we remove this and add the below???
    //	[locManager release];					//	Steffen added, 
	locManager = nil;
    //	NSLog(@"... finishing MapVC*: stopUpdatingLocation...");	
}


#pragma mark MKMapView Protocols

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKPolylineView *polylineView = [[[MKPolylineView alloc] initWithPolyline:overlay] autorelease]; 
    polylineView.lineWidth   = 5.0;
    polylineView.strokeColor = [UIColor greenColor];
    polylineView.fillColor   = [UIColor greenColor];
    return polylineView;
}

/*
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    //	NSLog(@"MapVC: regionDidChangeAnimated: START");
	
	
	// get the new span, see if the ZOOM changed (significantly); if so, update the MKAnnotationView and listenCircle
	mapRegionOld	= mapRegion;
	mapRegion		= [map region];
	
	double deltaX = fabs((mapRegion.span.longitudeDelta - mapRegionOld.span.longitudeDelta) / mapRegion.span.longitudeDelta);
	double deltaY = fabs((mapRegion.span.latitudeDelta  - mapRegionOld.span.latitudeDelta ) / mapRegion.span.latitudeDelta );
	
	if ( (deltaX > 0.1) || (deltaY > 0.1) ) {		//		[self resizeCirclesOfChatEvents]; ...deal with pinners later

        // Do something, maybe?
	}
	
	// get the map coordinates where you generate the chat, if visible
	mapCenterLatLonOld  =  mapCenterLatLon;
	mapLeftLatLon		= [map convertPoint:leftTarget toCoordinateFromView: map];
    
	
    //	NSLog(@"MapVC: regionDidChangeAnimated: END");
}
*/

/* currently unused MKMapView Protocol methods
 - (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {}
 - (void)mapViewWillStartLoadingMap:(MKMapView *)mapView {}
 - (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {}
 - (void)mapViewDidFailLoadingMap:  (MKMapView *)mapView withError:(NSError *)error {}  */


/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

@end
