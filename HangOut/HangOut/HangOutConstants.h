//
//  HangOutConstants.h
//  HangOut
//
//  Created by Ian Ferreira dos Santos on 3/23/14.
//
//

#pragma mark - PFObject Activity Class
// Class key
extern NSString *const kActivityClassKey;

// Field keys
extern NSString *const kActivityTypeKey;
extern NSString *const kActivityFromUserKey;
extern NSString *const kActivityToUserKey;
extern NSString *const kActivityContentKey;
extern NSString *const kActivityWishKey;

// Type values
extern NSString *const kActivityTypeGoing;
extern NSString *const kActivityTypeComment;


#pragma mark - PFObject User Class
// Class key
extern NSString *const kUserClassKey;

// Field keys
extern NSString *const kUserNameKey;
extern NSString *const kUserFacebookIDKey;
extern NSString *const kUserProfilePicSmallKey;
extern NSString *const kUserProfilePicMediumKey;
extern NSString *const kUserFacebookFriendsKey;
extern NSString *const kUserAlreadyAutoFollowedFacebookFriendsKey;


#pragma mark - PFObject Wish Class
// Class key
extern NSString *const kWishClassKey;

// Field keys
extern NSString *const kWishInfoKey;
extern NSString *const kWishTitleKey;
extern NSString *const kWishUserKey;
extern NSString *const kWishPlaceKey;
extern NSString *const kWishDateKey;
extern NSString *const kWishPrivacyKey;extern NSString *const kWishTimeKey;