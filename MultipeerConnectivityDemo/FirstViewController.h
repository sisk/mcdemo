//
//  FirstViewController.h
//  MultipeerConnectivityDemo
//
//  Created by Jason Sisk on 3/9/14.
//  Copyright (c) 2014 Jason Sisk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <UITextFieldDelegate>
  @property (weak, nonatomic) IBOutlet UITextField *txtMessage;
  @property (weak, nonatomic) IBOutlet UITextView *tvChat;

  - (IBAction)sendMessage:(id)sender;
  - (IBAction)cancelMessage:(id)sender;
@end
