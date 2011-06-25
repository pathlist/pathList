//
//  pathlistAppDelegate.h
//  pathlist
//
//  Created by Server Engineer on 4/23/11.
//  Copyright 2011 Carticipate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class pathlistViewController;

@interface pathlistAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow               *window;
    pathlistViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow               *window;
@property (nonatomic, retain) IBOutlet pathlistViewController *viewController;

@end

