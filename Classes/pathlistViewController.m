//
//  pathlistViewController.m
//  pathlist
//
//  Created by Server Engineer on 4/23/11.
//  Copyright 2011 Carticipate. All rights reserved.
//

#import "pathlistViewController.h"

@implementation pathlistViewController



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



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // get the api object
    apiObject = [[FactualAPI alloc] initWithAPIKey:@"SWdhzEah8u1ZXAngcrxkGu3Twnw8FMx33wthXXJ8HJs8xFEg3VoheJJbYAZq7Rk2"];
    
    // alloc query object
    FactualQuery* queryObject = [FactualQuery query];
    
	// setup query
    CLLocationCoordinate2D fakeCoordinate;
    

    
    fakeCoordinate.latitude  =   37.38690;      // at hacker dojo 37.38690, -122.06407
    fakeCoordinate.longitude = -122.06407;
    
    [queryObject setGeoFilter:fakeCoordinate radiusInMeters:14000.00];
	
	// send query to factual (and let the delegate handle it)
	[[apiObject queryTable:@"JBbIvk" optionalQueryParams:queryObject withDelegate:self] retain];

    // resize the map
    [mapView setCenterCoordinate:fakeCoordinate animated:YES];
    [mapView setRegion:MKCoordinateRegionMake(fakeCoordinate, MKCoordinateSpanMake(0.02, 0.02))]; 
    

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

- (void)releaseViewResources;
{
	[mapView   release];
    [apiObject release];
    
	apiObject = nil;	
	mapView   = nil;
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    
    [self releaseViewResources];
}


- (void)dealloc {
	[self releaseViewResources];
    [super dealloc];
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
    
    NSMutableArray *eventPoints = [[NSMutableArray alloc] init];
    PathWayPoint   *event;
    
    NSLog(@"Number of query results %f: ", queryResult.rows);
        
    for (FactualRow *row in queryResult.rows) {
        event  = [[PathWayPoint alloc] init];
                
        event.latitude  = [[row.values objectAtIndex:1] floatValue];
        event.longitude = [[row.values objectAtIndex:2] floatValue];
        event.rating    = [[row.values objectAtIndex:3] floatValue];
                
        [eventPoints addObject:event];
                
        [event release];
        
        NSLog(@"eventPoints count is: %i", [eventPoints count]);
    }
        
        
    [mapView addAnnotations: eventPoints];
    [eventPoints release];
}

// Writing
- (void)requestComplete:(FactualAPIRequest*) request receivedUpdateResult:(FactualUpdateResult*) updateResult {
    
    NSLog(@"Affected Row ID: %i", updateResult.affectedRowId); // contains the row id of the inserted / updated row...
    
    NSLog(@"Insert was folded into existing row: %@\n", [updateResult exists] ? @"YES" : @"NO"); // indicates if the insert was folded into an existing row
    
}


@end
