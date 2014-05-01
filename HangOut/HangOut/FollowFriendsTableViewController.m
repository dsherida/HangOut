//
//  FollowFriendsTableViewController.m
//  HangOut
//
//  Created by Ian Ferreira dos Santos on 4/16/14.
//
//

#import "FollowFriendsTableViewController.h"

@interface FollowFriendsTableViewController ()

@end

@implementation FollowFriendsTableViewController {
    UserModel *userModel;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    userModel = [UserModel sharedUserModel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [userModel.friends count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
    
    UILabel *name = (UILabel *)[cell viewWithTag:23];
    PFUser *friend = [[userModel friends] objectAtIndex:indexPath.row];
    name.text = friend.username;
    
    HangOutFollowButton *action = (HangOutFollowButton *)[cell viewWithTag:24];
    
    PFQuery *query = [PFQuery queryWithClassName:kActivityClassKey];
    [query whereKey:@"toUser" equalTo:friend];
    [query whereKey:@"type" equalTo:@"follow"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (objects.count) {
                [action setTitle:@"UNFOLLOW" forState:UIControlStateNormal];
            } else {
                [action setTitle:@"FOLLOW" forState:UIControlStateNormal];
            }
        }];
    
    PFImageView *image = (PFImageView *)[cell viewWithTag:25];
    image.file = [friend objectForKey:@"profilePic"];
    [image loadInBackground];
    
    action.friend = friend;
    
    return cell;
}

- (IBAction)actionButtonPressed:(id)sender {
    
    HangOutFollowButton *action = (HangOutFollowButton *)sender;
    
    if ([action.titleLabel.text  isEqualToString: @"FOLLOW"]) {
        PFObject *followActivity = [PFObject objectWithClassName:kActivityClassKey];
        followActivity[@"type"] = @"follow";
        followActivity[@"fromUser"] = [PFUser currentUser];
        followActivity[@"toUser"] = action.friend;
        [followActivity saveInBackground];
        [action setTitle:@"UNFOLLOW" forState:UIControlStateNormal];
    } else {
        PFQuery *query = [PFQuery queryWithClassName:kActivityClassKey];
        [query whereKey:@"fromUser" equalTo:[PFUser currentUser]];
        [query whereKey:@"toUser" equalTo:action.friend];
        [query whereKey:@"type" equalTo:@"follow"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            PFObject *object = [objects firstObject];
            [object deleteInBackground];
            [action setTitle:@"FOLLOW" forState:UIControlStateNormal];
        }];
    }
}
@end
