//
//  HangOutConstants.m
//  HangOut
//
//  Created by Ian Ferreira dos Santos on 3/23/14.
//
//

#pragma mark - PFObject Activity Class
// Class key
NSString *const kActivityClassKey = @"Activity";

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
// Field keys
NSString *const kUserNameKey;
NSString *const kUserFacebookIDKey;
NSString *const kUserProfilePicSmallKey;
NSString *const kUserProfilePicMediumKey;
NSString *const kUserFacebookFriendsKey;
NSString *const kUserAlreadyAutoFollowedFacebookFriendsKey;


#pragma mark - PFObject Wish Class
// Class key
NSString *const kWishClassKey;

// Field keys
NSString *const kWishInfoKey;
NSString *const kWishTitleKey;
NSString *const kWishUserKey;
NSString *const kWishPlaceKey;
NSString *const kWishDateKey;
NSString *const kWishTimeKey;
