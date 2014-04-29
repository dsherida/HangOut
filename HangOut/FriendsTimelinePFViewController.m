//
//  FriendsTimelinePFViewController.m
//  HangOut
//
//  Created by Ian Ferreira dos Santos on 3/24/14.
//
//

/*
 // Query for all friends you have on facebook and who are using the app
 PFQuery *friendsQuery = [PFQuery queryWithClassName:@"User"];
 [friendsQuery whereKey:@"fbID" containedIn:userModel.friendIds];
 NSArray *friendUsers = [friendsQuery findObjects];
 NSLog(@"FRIENDS: %@", friendUsers);
 */

#import "FriendsTimelinePFViewController.h"

@interface FriendsTimelinePFViewController ()

@end

@implementation FriendsTimelinePFViewController

 // Override to customize what kind of query to perform on the class. The default is to query for
 // all objects ordered by createdAt descending.
 - (PFQuery *)queryForTable {

     PFQuery *queryWish;
     
     if ([PFUser currentUser]) {
         queryWish = [PFQuery queryWithClassName:kWishClassKey];
         PFQuery *queryFriend = [PFQuery queryWithClassName:kActivityClassKey];
         [queryFriend whereKey:kActivityTypeKey equalTo:@"follow"];
         [queryFriend whereKey:kActivityFromUserKey equalTo:[PFUser currentUser]];
         
         [queryWish whereKey:@"User" matchesKey:kActivityToUserKey inQuery:queryFriend];
         
         
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
