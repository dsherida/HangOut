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

@interface HangOutViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

- (IBAction)logOutButtonPressed:(UIButton *)sender;
- (void)viewDidAppear:(BOOL)animated;
@end
