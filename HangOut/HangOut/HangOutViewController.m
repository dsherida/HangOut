//
//  HangOutViewController.m
//  HangOut
//
//  Created by Doug Sheridan on 2/24/14.
//
//

#import "HangOutViewController.h"

@interface HangOutViewController ()

@end

@implementation HangOutViewController

UserModel *userModel;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) { // No user logged in
        PFLogInViewController *login = [[PFLogInViewController alloc] init];
        login.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsFacebook
        | PFLogInFieldsSignUpButton | PFLogInFieldsPasswordForgotten;
        login.delegate = self;
        login.signUpController.delegate = self;
        [self presentViewController:login animated:YES completion:nil];
    }
    
    userModel = [UserModel sharedUserModel];
    [userModel requestAndSetFacebookUserData];
    //[userModel setCurrentUser];     // stores a pointer to the current user in the sharedUserModel
    //[userModel setName];        // stores the name of the current user in the sharedUserModel
}





- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    // Return Yes for supported orientations
    return (self.interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
