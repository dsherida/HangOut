//
//  HangOutViewController.h
//  HangOut
//
//  Created by Doug Sheridan on 2/24/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "UserModel.h"

@interface HangOutViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>


- (void)viewDidAppear:(BOOL)animated;


@end
