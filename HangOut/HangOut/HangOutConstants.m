//
//  HangOutConstants.m
//  HangOut
//
//  Created by Ian Ferreira dos Santos on 3/23/14.
//
//

#pragma mark - PFObject Activity Class
// Class key
NSString *const kActivityClassKey = @"activity";

// Field keys
NSString *const kActivityTypeKey = @"type";
NSString *const kActivityFromUserKey = @"fromUser";
NSString *const kActivityToUserKey = @"toUser";
NSString *const kActivityContentKey = @"context";
NSString *const kActivityWishKey = @"wish";

// Type values
NSString *const kActivityTypeGoing = @"going";
NSString *const kActivityTypeComment = @"comment";


#pragma mark - PFObject User Class
// Class key
NSString *const kUserClassKey = @"User";

// Field keys
NSString *const kUserNameKey = @"username";
NSString *const kUserFacebookIDKey = @"authData";
NSString *const kUserProfilePicSmallKey;
NSString *const kUserProfilePicMediumKey = @"profilePic";
NSString *const kUserFacebookFriendsKey = @"facebookFriends";
NSString *const kUserAlreadyAutoFollowedFacebookFriendsKey;


#pragma mark - PFObject Wish Class
// Class key
NSString *const kWishClassKey = @"wish";

// Field keys
NSString *const kWishInfoKey = @"info";
NSString *const kWishTitleKey = @"title";
NSString *const kWishUserKey = @"user";
NSString *const kWishPlaceKey = @"place";
NSString *const kWishDateKey = @"date";
NSString *const kWishTimeKey = @"time";
NSString *const kWishPrivacyKey = @"privacy";
