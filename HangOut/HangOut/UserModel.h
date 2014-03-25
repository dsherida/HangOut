//
//  UserModel.h
//  HangOut
//
//  Created by Doug Sheridan on 3/24/14.
//
/*  Description:
        This is the Model that will store information about the user
        that will be shared with the Controllers */

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "HangOutConstants.h"

@interface UserModel : NSObject <NSURLConnectionDelegate>

@property (strong, nonatomic) PFUser *currentUser;     // the current user
@property (strong, nonatomic) NSString *userName;   // current user's facebook name or username
@property (strong, nonatomic) NSString *facebookID; // current user's facebook ID
@property (strong, nonatomic) NSMutableData *profilePictureData; // store the user's profile picture image data

+ (UserModel *) sharedUserModel;
- (void) requestAndSetFacebookUserData;
- (void) setCurrentUser;
- (void) setName;

@end
