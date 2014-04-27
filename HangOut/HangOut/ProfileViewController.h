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

@interface ProfileViewController : PFQueryTableViewController <PFLogInViewControllerDelegate,
PFSignUpViewControllerDelegate>


@property (strong, nonatomic) IBOutlet UIImageView *UIProfilePic;
@property (strong, nonatomic) IBOutlet UILabel *UINameLabel;

@property (nonatomic, strong) NSDictionary *object;
@property (nonatomic,weak) NSString *wishTitle;
@property (nonatomic,weak) NSArray *keyArray;
@property (nonatomic) BOOL doneLoading;

@end
