//
//  ConnectionsViewController.m
//  MultipeerConnectivityDemo
//
//  Created by Jason Sisk on 3/9/14.
//  Copyright (c) 2014 Jason Sisk. All rights reserved.
//

#import "ConnectionsViewController.h"
#import "AppDelegate.h"

@interface ConnectionsViewController ()
  @property (nonatomic, strong) AppDelegate *appDelegate;
  @property (nonatomic, strong) NSMutableArray *arrConnectedDevices;

  -(void)peerDidChangeStateWithNotification:(NSNotification *)notification;
@end

@implementation ConnectionsViewController

  -(void)peerDidChangeStateWithNotification:(NSNotification *)notification{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];

    if (state != MCSessionStateConnecting) {
      if (state == MCSessionStateConnected) {
        [_arrConnectedDevices addObject:peerDisplayName];
      }
      else if (state == MCSessionStateNotConnected){
        if ([_arrConnectedDevices count] > 0) {
          int indexOfPeer = [_arrConnectedDevices indexOfObject:peerDisplayName];
          [_arrConnectedDevices removeObjectAtIndex:indexOfPeer];
        }
      }

      [_tblConnectedDevices reloadData];
      
      BOOL peersExist = ([[_appDelegate.mcManager.session connectedPeers] count] == 0);
      [_btnDisconnect setEnabled:!peersExist];
      [_txtName setEnabled:peersExist];
    }
  }

  -(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
  }

  -(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arrConnectedDevices count];
  }

  -(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    
    cell.textLabel.text = [_arrConnectedDevices objectAtIndex:indexPath.row];
    
    return cell;
  }

  -(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
  }

  - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
  {
      self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
      if (self) {
          // Custom initialization
      }
      return self;
  }

  - (void)viewDidLoad
  {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[_appDelegate mcManager] setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    [[_appDelegate mcManager] advertiseSelf:_swVisible.isOn];
    [_txtName setDelegate:self];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:@"MCDidChangeStateNotification"
                                               object:nil];
    
    _arrConnectedDevices = [[NSMutableArray alloc] init];
    [_tblConnectedDevices setDelegate:self];
    [_tblConnectedDevices setDataSource:self];
  }

  - (void)didReceiveMemoryWarning
  {
      [super didReceiveMemoryWarning];
      // Dispose of any resources that can be recreated.
  }

  - (IBAction)browseForDevices:(id)sender {
    [[_appDelegate mcManager] setupMCBrowser];
    [[[_appDelegate mcManager] browser] setDelegate:self];
    [self presentViewController:[[_appDelegate mcManager] browser] animated:YES completion:nil];
  }


  -(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [_appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
  }


  -(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [_appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
  }


  -(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_txtName resignFirstResponder];
    
    _appDelegate.mcManager.peerID = nil;
    _appDelegate.mcManager.session = nil;
    _appDelegate.mcManager.browser = nil;
    
    if ([_swVisible isOn]) {
      [_appDelegate.mcManager.advertiser stop];
    }
    _appDelegate.mcManager.advertiser = nil;
    
    
    [_appDelegate.mcManager setupPeerAndSessionWithDisplayName:_txtName.text];
    [_appDelegate.mcManager setupMCBrowser];
    [_appDelegate.mcManager advertiseSelf:_swVisible.isOn];
    
    return YES;
  }

  - (IBAction)toggleVisibility:(id)sender {
    [_appDelegate.mcManager advertiseSelf:_swVisible.isOn];
  }
@end
