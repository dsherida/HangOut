//
//  LocalTimelinePFViewController.m
//  HangOut
//
//  Created by Ian Ferreira dos Santos on 3/29/14.
//
//

#import "LocalTimelinePFViewController.h"

@interface LocalTimelinePFViewController ()

@end

@implementation LocalTimelinePFViewController


// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    
    PFQuery *queryWish;
    
    if ([PFUser currentUser]) {
        queryWish = [PFQuery queryWithClassName:kWishClassKey];
        PFQuery *queryFriend = [PFQuery queryWithClassName:kActivityClassKey];
        [queryFriend whereKey:kActivityTypeKey equalTo:@"follow"];
        [queryFriend whereKey:kActivityFromUserKey equalTo:[PFUser currentUser]];
        
        [queryWish whereKey:@"User" doesNotMatchKey:kActivityToUserKey inQuery:queryFriend];
        [queryWish whereKey:@"User" notEqualTo:[PFUser currentUser]];
        
        UserModel *userModel = [UserModel sharedUserModel];
        
        if ([userModel isLocationReady]) {
            [queryWish whereKey:@"location" nearGeoPoint:userModel.location withinKilometers:100];
        }
        
        // If Pull To Refresh is enabled, query against the network by default.
        if (self.pullToRefreshEnabled) {
            queryWish.cachePolicy = kPFCachePolicyNetworkOnly;
        }
        
        // If no objects are loaded in memory, we look to the cache first to fill the table
        // and then subsequently do a query against the network.
        if (self.objects.count == 0) {
            queryWish.cachePolicy = kPFCachePolicyCacheThenNetwork;
        }
        
        [queryWish orderByDescending:@"createdAt"];
    }
    
    return queryWish;
}


@end
