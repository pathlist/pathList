//
//  PathWayPointView.m
//  ...the dot which marks a way point
//
//  Created by Server Engineer on 4/23/11.
//  Copyright 2011 Carticipate. All rights reserved.
//

#import "PathWayPointView.h"

@implementation PathWayPointView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation 
         reuseIdentifier:(NSString *)reuseIdentifier {
  if(self = [super initWithAnnotation:annotation 
                      reuseIdentifier:reuseIdentifier]) {
    self.backgroundColor = [UIColor clearColor];
  }
  return self;
}

- (void)setAnnotation:(id <MKAnnotation>)annotation {
	super.annotation = annotation;
  
	if ([annotation isMemberOfClass:[PathWayPoint class]]) {
		event = (PathWayPoint *)annotation;
    
//		float magSquared = event.rating * event.rating;

		self.frame = CGRectMake(0, 0, 30, 30);

	} 
	
	else {
		self.frame = CGRectMake(0,0,0,0);
	}

}

- (void)drawRect:(CGRect)rect {
  float magSquared = event.rating * event.rating;
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetRGBFillColor(context, 1.0, 1.0 - magSquared * 0.015, 0.211, .6);
  CGContextFillEllipseInRect(context, rect);
}

- (void)dealloc {
  [event release];
  [super dealloc];
}

@end
