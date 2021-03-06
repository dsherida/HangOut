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
        self.currentUser = [PFUser currentUser];
        self.userName = nil;
        
        // open-source: https://parse.com/tutorials/geolocations
        if (!self.locationManager) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            self.locationManager.delegate = self;
        }
        [self.locationManager startUpdatingLocation];
        [self setIsLocationReady:NO];
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
            [self setFacebookID];
            //[self setLocation];
            
            self.objectId = userData[@"objectId"];
            
            // Download the user's facebook profile picture
            self.profilePictureData = [[NSMutableData alloc] init]; // the data will be loaded in here
            
            // URL should point to https://graph.facebook.com/{facebookId}/picture?type=large&return_ssl_resources=1
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                  timeoutInterval:2.0f];
            // Run network request asynchronously
            NSURLConnection *urlConnection;
            urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
            
            // Issue a Facebook Graph API request to get your user's friend list
            [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    // result will contain an array with your user's friends in the "data" key
                    NSArray *friendObjects = [result objectForKey:@"data"];
                    NSMutableArray *friendIds;
                    friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
                    // Create a list of friends' Facebook IDs
                    for (NSDictionary *friendObject in friendObjects) {
                        [friendIds addObject:[friendObject objectForKey:@"id"]];
                    }
                    
                    // Query for all friends you have on facebook and who are using the app
                    PFQuery *friendsQuery = [PFQuery queryWithClassName:@"_User"];
                    [friendsQuery whereKey:@"fbID" containedIn:friendIds];
                    
                    self.friends = [friendsQuery findObjects];
                }
            }];
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
    PFFile *newImageFile = [PFFile fileWithName:@"profilePic.png" data:self.profilePictureData];
    self.profilePictureFile = newImageFile;
    self.profileUIImage = [UIImage imageWithData:self.profilePictureData];
    
    PFQuery *query = [PFQuery queryWithClassName:kUserClassKey];
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:self.currentUser.objectId block:^(PFObject *user, NSError *error) {
        
        // Now let's update it with some new data. In this case, only user's name
        // will get sent to the cloud. anything else has changed
        user[kUserProfilePicMediumKey] = newImageFile;
        [user saveInBackground];
        
    }];

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
    PFQuery *query = [PFQuery queryWithClassName:kUserClassKey];
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:self.currentUser.objectId block:^(PFObject *user, NSError *error) {
        
        // Now let's update it with some new data. In this case, only user's name
        // will get sent to the cloud. anything else has changed
        user[@"username"] = self.userName;
        [user saveInBackground];
        
    }];
}

- (void) setFacebookID {
    PFQuery *query = [PFQuery queryWithClassName:kUserClassKey];
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:self.currentUser.objectId block:^(PFObject *user, NSError *error) {
        
        // Now let's update it with some new data. In this case, only user's name
        // will get sent to the cloud. anything else has changed
        user[@"fbID"] = self.facebookID;
        [user saveInBackground];
    }];
}

// open-source: http://stackoverflow.com/questions/21194267/how-to-make-parse-com-object-property-unique
- (void) setFriends {
    PFQuery *query = [PFQuery queryWithClassName:kActivityClassKey];
    for (PFUser *friend in self.friends) {
        [query whereKey:@"toUser" equalTo:friend];
        [query whereKey:@"type" equalTo:@"follow"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (objects.count) {
                NSLog(@"ALREADY FOLLOWING");
            } else {
                PFObject *followActivity = [PFObject objectWithClassName:kActivityClassKey];
                followActivity[@"type"] = @"follow";
                followActivity[@"fromUser"] = [PFUser currentUser];
                followActivity[@"toUser"] = friend;
                [followActivity saveInBackground];
                NSLog(@"ADDED");
            }
        }];
    }
}

- (void) setLocation {
        CLLocationCoordinate2D coordinate = [self.userLocation coordinate];
        PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude
                                                      longitude:coordinate.longitude];
    self.location = geoPoint;
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.userLocation = [locations lastObject];
    [self setLocation];
    [self setIsLocationReady:YES];
}

@end
