//
//  FriendsTimelinePFViewController.m
//  HangOut
//
//  Created by Ian Ferreira dos Santos on 3/24/14.
//
//

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
        PFLogInViewController *login = [[PFLogInViewController alloc] init];
        login.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsFacebook
        | PFLogInFieldsSignUpButton | PFLogInFieldsPasswordForgotten;
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

/*
 // Override to customize what kind of query to perform on the class. The default is to query for
 // all objects ordered by createdAt descending.
 - (PFQuery *)queryForTable {
 PFQuery *query = [PFQuery queryWithClassName:self.className];
 
 // If Pull To Refresh is enabled, query against the network by default.
 if (self.pullToRefreshEnabled) {
 query.cachePolicy = kPFCachePolicyNetworkOnly;
 }
 
 // If no objects are loaded in memory, we look to the cache first to fill the table
 // and then subsequently do a query against the network.
 if (self.objects.count == 0) {
 query.cachePolicy = kPFCachePolicyCacheThenNetwork;
 }
 
 [query orderByDescending:@"createdAt"];
 
 return query;
 }
 */


 // Override to customize the look of a cell representing an object. The default is to display
 // a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
 // and the imageView being the imageKey in the object.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
     static NSString *CellIdentifier = @"wishBox";
 
     PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
         cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     }
 
     // Configure the cell
     UILabel *title = (UILabel *)[cell viewWithTag:10];
     title.text = [object objectForKey:self.wishTitle];
     
     UILabel *message = (UILabel *)[cell viewWithTag:3];
     message.text = [object objectForKey:self.message];
     
     
     PFObject *theUser = [object objectForKey:@"User"];

     PFQuery *query = [PFQuery queryWithClassName:@"_User"];
     [query getObjectInBackgroundWithId:[theUser objectId] block:^(PFObject *theUser, NSError *error) {
         // Do something with the returned PFObject in the gameScore variable.
         UILabel *username = (UILabel *)[cell viewWithTag:20];
         username.text = [theUser objectForKey:@"username"];
         
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
         
     }];
     
     cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell.png"]];
                            
     
 
 return cell;
 }

-(void)joinButtonClicked:(HangOutJoinButton*)sender
{
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
