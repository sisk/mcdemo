//
//  FirstViewController.m
//  MultipeerConnectivityDemo
//
//  Created by Jason Sisk on 3/9/14.
//  Copyright (c) 2014 Jason Sisk. All rights reserved.
//

#import "FirstViewController.h"
#import "AppDelegate.h"

@interface FirstViewController ()
  @property (nonatomic, strong) AppDelegate *appDelegate;

  -(void)sendMyMessage;
  -(void)didReceiveDataWithNotification:(NSNotification *)notification;
@end

@implementation FirstViewController

  - (void)viewDidLoad
  {
      [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _txtMessage.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:@"MCDidReceiveDataNotification"
                                               object:nil];
  }

  -(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self sendMyMessage];
    return YES;
  }

  - (void)didReceiveMemoryWarning
  {
      [super didReceiveMemoryWarning];
      // Dispose of any resources that can be recreated.
  }

  - (IBAction)sendMessage:(id)sender {
    [self sendMyMessage];
  }

  - (IBAction)cancelMessage:(id)sender {
    [_txtMessage resignFirstResponder];
  }

  -(void)sendMyMessage{
    NSData *dataToSend = [_txtMessage.text dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *allPeers = _appDelegate.mcManager.session.connectedPeers;
    NSError *error;
    
    [_appDelegate.mcManager.session sendData:dataToSend
                                     toPeers:allPeers
                                    withMode:MCSessionSendDataReliable
                                       error:&error];
    
    if (error) {
      NSLog(@"%@", [error localizedDescription]);
    }
    
    [_tvChat setText:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"I wrote:\n%@\n\n", _txtMessage.text]]];
    [_txtMessage setText:@""];
    [_txtMessage resignFirstResponder];
  }

  -(void)didReceiveDataWithNotification:(NSNotification *)notification{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    [_tvChat performSelectorOnMainThread:@selector(setText:) withObject:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"%@ wrote:\n%@\n\n", peerDisplayName, receivedText]] waitUntilDone:NO];
  }
@end
