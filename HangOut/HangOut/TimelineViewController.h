//
//  TimelineViewController.h
//  HangOut
//
//  Created by Ian Ferreira dos Santos on 4/29/14.
//
//

#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "UserModel.h"
#import "HangOutConstants.h"
#import "HangOutJoinButton.h"
#import "TTTTimeIntervalFormatter.h"
#import "HangOutLoginViewController.h"
#import "HangOutAlertView.h"
#import "HangOutDetailsButton.h"
#import "ListOfAttendeesPFViewController.h"
#import "CommentsPFViewController.h"

@interface TimelineViewController : PFQueryTableViewController <PFLogInViewControllerDelegate,
PFSignUpViewControllerDelegate, UIAlertViewDelegate>

@property (nonatomic,weak) NSString *wishTitle;
@property (nonatomic,weak) NSString *message;
@property (nonatomic,weak) NSString *profilePic;

- (IBAction)detailsButtonClicked:(HangOutDetailsButton *)sender;

@end
