//
//  FriendsTimelinePFViewController.h
//  HangOut
//
//  Created by Ian Ferreira dos Santos on 3/24/14.
//
//

#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FriendsTimelinePFViewController : PFQueryTableViewController

@property (nonatomic,weak) NSString *wishTitle;
@property (nonatomic,weak) NSString *message;
@property (nonatomic,weak) NSString *profilePic;

@end
