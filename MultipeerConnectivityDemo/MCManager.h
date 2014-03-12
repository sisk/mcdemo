//
//  MCManager.h
//  MultipeerConnectivityDemo
//
//  Created by Jason Sisk on 3/9/14.
//  Copyright (c) 2014 Jason Sisk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MCManager : NSObject <MCSessionDelegate>

// Represents the device. contains properties necessary for
// discovery and session establishment
@property (nonatomic, strong) MCPeerID *peerID;

// Most important; contains all data exchange + communication details
@property (nonatomic, strong) MCSession *session;

// Below is the default Apple browser implementation. A more automated way is advanced.
@property (nonatomic, strong) MCBrowserViewController *browser;

// Current peer uses this to make discovery possible
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;


-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName;
-(void)setupMCBrowser;
-(void)advertiseSelf:(BOOL)shouldAdvertise;
@end
