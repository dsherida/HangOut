//
//  UserModel.m
//  HangOut
//
//  Created by Doug Sheridan on 3/24/14.
//
/*  Description:
        This is the Model that will store information about the user
        that will be shared with the Controllers */

#import "UserModel.h"


@implementation UserModel


+ (UserModel *) sharedUserModel {
    static UserModel *sharedUserModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUserModel = [[self alloc] init];
    });
    return sharedUserModel;
}


- (id) init {
    if (self = [super init]) {
        self.currentUser = nil;
        self.userName = nil;
    }
    return self;
}

/*
    requestAndSetFacebookUserData
        request to open connection to facebook graph,
        parse the data that is sent back,
        store it in the SharedUserModel
 */
- (void) requestAndSetFacebookUserData {
    // Open Source code: https://parse.com/tutorials/integrating-facebook-in-ios
    // Create request for user's Facebook data
    FBRequest *request = [FBRequest requestForMe];
    
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            self.facebookID = facebookID;
            self.userName = userData[@"name"];
            [self setName];
            
            // Other userData fields (not needed [yet?])
            //NSString *location = userData[@"location"][@"name"];
            //NSString *gender = userData[@"gender"];
            //NSString *birthday = userData[@"birthday"];
            //NSString *relationship = userData[@"relationship_status"];
            
            // Download the user's facebook profile picture
            self.profilePictureData = [[NSMutableData alloc] init]; // the data will be loaded in here
            
            // URL should point to https://graph.facebook.com/{facebookId}/picture?type=large&return_ssl_resources=1
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                  timeoutInterval:2.0f];
            // Run network request asynchronously
            NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
        }
    }];
}


// Called every time a chunk of the data is received
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.profilePictureData appendData:data]; // Build the image
}


// Called when the entire image is finished downloading
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Upload the picture to our Parse DB
    [self.currentUser setObject:self.profilePictureData forKey:kUserProfilePicMediumKey];
    [self.currentUser save];
    NSLog(@"Done downloading profile picture. Uploaded to Parse DB.");
}


/*
    setCurrentUser
        get the current user, 
        and return the user object
        --assumes that there is a user already logged in
*/
- (void) setCurrentUser {
    self.currentUser = [PFUser currentUser];
    NSLog(@"setCurrentUser");
}


/*
    setName
        store the user's name in the Parse DB
        --assumes that there is a user already logged in and that we already have the data
          stored in the SharedUserModel singleton
*/
- (void) setName {
    [self.currentUser setObject:self.userName forKey:kUserNameKey];
    [self.currentUser save];
    NSLog(@"setName: %@", self.userName);
}


/*
    getProfilePicture
        - get the current user's profile picture
*/
- (void) getProfilePicture {
    // Open Source code from: https://parse.com/questions/how-can-i-get-the-facebook-id-of-a-user-logged-in-with-facebook
    [FBRequestConnection
     startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             NSString *facebookId = [result objectForKey:@"id"];
             NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [[PFUser currentUser] objectForKey:facebookId]]];
             NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks
             [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];
         }
     }];
}




@end
