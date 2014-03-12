//
//  AppDelegate.h
//  MultipeerConnectivityDemo
//
//  Created by Jason Sisk on 3/9/14.
//  Copyright (c) 2014 Jason Sisk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MCManager *mcManager;

@end
