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

UserModel *userModel; // singleton class UserModel


- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // Customize the table
        
        
        // The className to query on
        self.parseClassName = @"wish";
        
        // The key of the PFObject to display in the label of the default cell style
        self.wishTitle = @"title";
        self.message = @"info";
        self.profilePic = @"User";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) { // No user logged in
        HangOutLoginViewController *login = [[HangOutLoginViewController alloc] init];
        login.fields = PFLogInFieldsFacebook;
        login.delegate = self;
        login.signUpController.delegate = self;
        [self presentViewController:login animated:YES completion:nil];
    }
    
    BOOL isLinkedToFacebook = [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]];
    
    if (isLinkedToFacebook && (userModel.currentUser != [PFUser currentUser])) {
        NSLog(@"Setting up UserModel");
        userModel = [UserModel sharedUserModel];
        [userModel requestAndSetFacebookUserData];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    // Return Yes for supported orientations
    return (self.interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Setting up UserModel");
    userModel = [UserModel sharedUserModel];
    [userModel requestAndSetFacebookUserData];
    [self loadObjects];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}


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

//
// Customized code to show only wishes from your friends
//
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
     static NSString *CellIdentifier = @"wishBox";
 
     PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     
     if ([PFUser currentUser]) {
     if (cell == nil) {
         cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     }
 
     // Configure the cell
     UILabel *title = (UILabel *)[cell viewWithTag:10];
     title.text = [object objectForKey:self.wishTitle];
     
     UILabel *message = (UILabel *)[cell viewWithTag:3];
     message.text = [object objectForKey:self.message];
     
     
     // Add actions for details button
//     HangOutDetailsButton *details = (HangOutDetailsButton *)[cell viewWithTag:6];
//     details.object = object;
//     [details addTarget:self action:@selector(detailsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//     UIButton *detailsButton = (UIButton *)[cell viewWithTag:6];
//     [detailsButton addTarget:self action:@selector(detailsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
     
     
     PFUser *theUser = [object objectForKey:@"User"];

     PFQuery *query = [PFQuery queryWithClassName:@"_User"];

     
     [query getObjectInBackgroundWithId:[theUser objectId] block:^(PFObject *theUser, NSError *error) {
         // Do something with the returned PFObject in the gameScore variable.
         UILabel *username = (UILabel *)[cell viewWithTag:20];
         username.text = [theUser objectForKey:@"username"];
         
         UILabel *timeAgo = (UILabel *)[cell viewWithTag:21];
         TTTTimeIntervalFormatter *timeFormatter;
         timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
         NSDate *currentDate = [[NSDate alloc] init];
         NSDate *postDate = [object objectForKey:kWishDateKey];
         timeAgo.text = [timeFormatter stringForTimeIntervalFromDate:currentDate toDate:postDate];
         //NSLog(@"CURRENT: %@", currentDate);
         //NSLog(@"POST: %@", postDate);
         
         PFImageView *image = (PFImageView *)[cell viewWithTag:2];
         image.file = [theUser objectForKey:@"profilePic"];
         [image loadInBackground];
         
         UILabel *place = (UILabel *)[cell viewWithTag:7];
         place.text = [object objectForKey:kWishPlaceKey];
         
         UILabel *date = (UILabel *)[cell viewWithTag:8];
         NSDate *theDate = [object objectForKey:kWishDateKey];
         
         // http://stackoverflow.com/questions/576265/convert-nsdate-to-nsstring
         date.text = [NSDateFormatter localizedStringFromDate:theDate
                                                    dateStyle:NSDateFormatterShortStyle
                                                    timeStyle:NSDateFormatterFullStyle];
         
         HangOutJoinButton *join = (HangOutJoinButton *)[cell viewWithTag:4];
         join.object = object;
         [join addTarget:self action:@selector(joinButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
         
         PFQuery *isGoing = [PFQuery queryWithClassName:kActivityClassKey];
         
         [isGoing whereKey:@"fromUser" equalTo:[PFUser currentUser]];
         [isGoing whereKey:@"toUser" equalTo:[object objectForKey:@"User"]];
         [isGoing whereKey:@"type" equalTo:@"going"];
         [isGoing whereKey:@"wish" equalTo:object];
         [isGoing findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
             
             if (objects.count) {
                 [join setTitle:@"GOING" forState:UIControlStateNormal];
             }
         }];
     }];
     
     
     }
     cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell.png"]];
 return cell;
 }

// When JOIN button is clicked, the following code performs the inclusion of a new activity on Parse
-(void)joinButtonClicked:(HangOutJoinButton*)sender
{
    if ([[sender currentTitle] isEqualToString:@"JOIN"]) {
        PFQuery *query = [PFQuery queryWithClassName:kActivityClassKey];
        
        [query whereKey:@"fromUser" equalTo:[PFUser currentUser]];
        [query whereKey:@"toUser" equalTo:[sender.object objectForKey:@"User"]];
        [query whereKey:@"type" equalTo:@"going"];
        [query whereKey:@"wish" equalTo:sender.object];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (objects.count) {
                NSLog(@"ALREADY GOING");
            } else {
                // Create Wish Object
                PFObject *activity = [PFObject objectWithClassName:kActivityClassKey];
                activity[@"fromUser"] = [PFUser currentUser];
                activity[@"toUser"] = [sender.object objectForKey:@"User"];
                activity[@"type"] = @"going";
                activity[@"wish"] = sender.object;
                
                // Wishes are public, but only the creator can modify it
                PFACL *activityACL = [PFACL ACLWithUser:[PFUser currentUser]];
                [activityACL setPublicReadAccess:YES];
                activity.ACL = activityACL;
                
                [activity saveInBackground];
                NSLog(@"NOW GOING");
            }
        }];
        [sender setTitle:@"GOING" forState:UIControlStateNormal];
    } else {
        HangOutAlertView *alert = [[HangOutAlertView alloc] initWithTitle:@"UNJOIN?"
                                                        message:@"You're already joined. Do you want to unjoin?"
                                                       delegate:self
                                              cancelButtonTitle:@"NO"
                                              otherButtonTitles:@"YES", nil];
        alert.object = sender.object;
        alert.button = sender;
        [alert show];
    }
}

// This alert view is supposed to remove the related activity on Parse
// http://code.tutsplus.com/tutorials/ios-sdk-working-with-uialertview-and-uialertviewdelegate--mobile-3159
- (void) alertView:(HangOutAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"YES"]) {
        // remove on Parse
        PFQuery *query = [PFQuery queryWithClassName:kActivityClassKey];
        [query whereKey:@"fromUser" equalTo:[PFUser currentUser]];
        [query whereKey:@"toUser" equalTo:[alertView.object objectForKey:@"User"]];
        [query whereKey:@"type" equalTo:@"going"];
        [query whereKey:@"wish" equalTo:alertView.object];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            PFObject *object = [objects firstObject];
            [object deleteEventually];
            [alertView.button setTitle:@"JOIN" forState:UIControlStateNormal];
        }];            
    }
}


- (IBAction)detailsButtonClicked:(id)sender{
    NSLog(@"detailsButton was clicked!");
    
    // -- begin reference:
    // Open source code from: http://stackoverflow.com/questions/7504421/getting-row-of-uitableview-cell-on-button-press
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    // -- end reference
    
    // -- begin reference:
    // open source code from: http://stackoverflow.com/questions/2384435/how-can-i-get-a-uitableviewcell-by-indexpath
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    // -- end reference
    
    UILabel *title = (UILabel *)[cell viewWithTag:10];
    NSString *wishTitle = title.text;
    NSLog(@"Wish title: %@", wishTitle);
    
    UILabel *username = (UILabel *)[cell viewWithTag:20];
    NSString *wishOwner = username.text;
    NSLog(@"Wish owner: %@", wishOwner);

    //[self performSegueWithIdentifier:@"detailsSegue" sender:sender];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    // Send some data over
    NSLog(@"Prepare for segue...");
    
    if([segue.identifier isEqualToString:@"detailsSegue"]){
        
        
        
        //UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
        //[self.navigationController pushViewController: myController animated:YES];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [self loadObjects];
}

/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [self.objects objectAtIndex:indexPath.row];
 }
 */

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */

#pragma mark - UITableViewDataSource

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the object from Parse and reload the table view
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, and save it to Parse
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}


@end
