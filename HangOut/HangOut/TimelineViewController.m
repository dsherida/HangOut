//
//  TimelineViewController.m
//  HangOut
//
//  Created by Ian Ferreira dos Santos on 4/29/14.
//
//

#import "TimelineViewController.h"

@interface TimelineViewController ()

@end

@implementation TimelineViewController

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
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
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
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
}


// Customized code to show only wishes from your friends
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
            
            timeAgo.text = [timeFormatter stringForTimeIntervalFromDate:[object createdAt] toDate:currentDate];
            
            PFImageView *image = (PFImageView *)[cell viewWithTag:2];
            image.file = [theUser objectForKey:@"profilePic"];
            [image loadInBackground];
            
            UILabel *place = (UILabel *)[cell viewWithTag:7];
            place.text = [object objectForKey:kWishPlaceKey];
            place.text = [place.text stringByAppendingString:[NSString stringWithFormat:@" (%.2f km)", [userModel.location distanceInKilometersTo:[object objectForKey:@"location"]]]];
            
            UILabel *date = (UILabel *)[cell viewWithTag:8];
            NSDate *theDate = [object objectForKey:kWishDateKey];
            
            // http://stackoverflow.com/questions/576265/convert-nsdate-to-nsstring
            date.text = [NSDateFormatter localizedStringFromDate:theDate
                                                       dateStyle:NSDateFormatterShortStyle
                                                       timeStyle:NSDateFormatterShortStyle];
            
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
        
        HangOutDetailsButton *attendees = (HangOutDetailsButton *)[cell viewWithTag:54];
        attendees.object = object;
        
        HangOutDetailsButton *comments = (HangOutDetailsButton *)[cell viewWithTag:108];
        comments.object = object;
        
        PFQuery *attendeesQuery = [PFQuery queryWithClassName:kActivityClassKey];
        [attendeesQuery whereKey:@"type" equalTo:@"going"];
        [attendeesQuery whereKey:@"wish" equalTo:object];
        
        [attendeesQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            [attendees setTitle:[NSString stringWithFormat:@"%d", number] forState:UIControlStateNormal];
        }];
        
        PFQuery *commentsQuery = [PFQuery queryWithClassName:kActivityClassKey];
        [commentsQuery whereKey:@"type" equalTo:@"comment"];
        [commentsQuery whereKey:@"wish" equalTo:object];
        
        [commentsQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            [comments setTitle:[NSString stringWithFormat:@"%d", number] forState:UIControlStateNormal];
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


- (IBAction)detailsButtonClicked:(id)sender {
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
}

-(void) viewWillAppear:(BOOL)animated
{
    [self loadObjects];
}

#pragma mark - UITableViewDataSource

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Attendees"]) {
        ListOfAttendeesPFViewController *list = [segue destinationViewController];
        HangOutDetailsButton *button = (HangOutDetailsButton*) sender;
        list.object = button.object;
    }
    if ([segue.identifier isEqualToString:@"Comments"]) {
        CommentsPFViewController *list = [segue destinationViewController];
        HangOutDetailsButton *button = (HangOutDetailsButton*) sender;
        list.object = button.object;
    }
}

@end