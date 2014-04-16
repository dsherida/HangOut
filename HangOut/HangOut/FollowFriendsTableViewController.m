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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
