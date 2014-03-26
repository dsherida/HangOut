//
//  ProfileViewController.h
//  HangOut
//
//  Created by Doug Sheridan on 3/23/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "UserModel.h"

@interface ProfileViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *UIProfilePic;
@property (strong, nonatomic) IBOutlet UILabel *UINameLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
